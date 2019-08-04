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
}

//Mount HDD
//Startup script
//firewall rule
resource "google_compute_network" "vpc-network" {
    name = "${var.instance_network}"
}

resource "google_compute_firewall" "default" {
    name = "allow-mcs"
    network= "${google_compute_network.vpc-network.name}"
    allow {
        protocol = "tcp"
        ports    = ["25565"]
    }
    source_ranges = ["0.0.0.0/0"]
  
}
//Bucket
resource "google_storage_bucket" "mcs-bucket" {
    name     = "nlwilkingminecraftstoragebucket"
    location = "AU"
  
}

