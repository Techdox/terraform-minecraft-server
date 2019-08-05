//Provider
provider "google" {
  credentials = "${file("terraform-practice-nlw-c5a6bc11462e.json")}"
  project     = "${var.project_name}"
  region      = "${var.region_name}"
  zone        = "${var.zone_name}"
}

//Aditional HDD
resource "google_compute_disk" "default" {
  name = "minecraft-disk"
  type = "pd-ssd"
  zone = "${var.zone_name}"
  physical_block_size_bytes = "16384"
}

//Static IP
resource "google_compute_address" "static-ip-address" {
  name = "mcs-ip"
}
//Create VM
resource "google_compute_instance" "default" {
  name = "${var.instance_name}"
  machine_type = "${var.machine_type}"

  boot_disk {
      initialize_params {
          image = "${var.instance_image}"
        }
    }
  attached_disk {
      source = "${google_compute_disk.default.self_link}"
  }
  network_interface {
      network = "${google_compute_network.vpc-network.name}"
      subnetwork = "${var.subnetwork}"
      access_config {
          nat_ip = "${google_compute_address.static-ip-address.address}"

      }
  }
  metadata = {
      startup-script = <<SCRIPT
      mkdir -p /home/minecraft
      mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-minecraft-disk
      mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft
      apt-get update
      apt-get install -y default-jre-headless
      cd /home/minecraft
      wget https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar
      java -Xms1G -Xmx3G -d64 -jar server.jar nogui
      sed -i 's/false/true/g' eula.txt
      java -Xms1G -Xmx3G -d64 -jar server.jar nogui
      SCRIPT
  }
}

//Network creation
resource "google_compute_network" "vpc-network" {
    name = "${var.instance_network}"
}
//firewall rules
resource "google_compute_firewall" "default" {
    name = "allow-mcs"
    network= "${google_compute_network.vpc-network.name}"
    allow {
        protocol = "tcp"
        ports    = ["25565"]
    }
    source_ranges = ["${google_compute_instance.default.network_interface.0.network_ip}"]
}

resource "google_compute_firewall" "defaultssh" {
    name = "allow-ssh"
    network= "${google_compute_network.vpc-network.name}"
    allow {
        protocol = "tcp"
        ports    = ["22"]
    }
    source_ranges = ["${google_compute_instance.default.network_interface.0.network_ip}"]
}

//Bucket
resource "google_storage_bucket" "default" {
    name     = "nlwilkingminecraftstoragebucket2019"
}

//IP Of Server
output "serverip" {
  value = "${google_compute_address.static-ip-address.address}"
}
