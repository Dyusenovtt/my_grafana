terraform {
  required_providers {
    yandex = { source = "yandex-cloud/yandex" }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1gnb8ps1ogn1lagdmqk"
  folder_id                = "b1gqdmccc2tqlgncgnr1"
}

resource "yandex_vpc_network" "mon_net" {
  name = "monitoring-network"
}

resource "yandex_vpc_subnet" "mon_subnet_a" {
  name           = "mon-subnet-a"
  network_id     = yandex_vpc_network.mon_net.id
  v4_cidr_blocks = ["10.6.1.0/24"]
  zone           = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "monitoring" {
  name        = "monitoring"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.mon_subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/root/.ssh/id_rsa.pub")}"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    ip = yandex_compute_instance.monitoring.network_interface.0.nat_ip_address
  })
  filename = "${path.module}/artifacts/inventory.ini"
}
