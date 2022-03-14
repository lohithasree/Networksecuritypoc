#creating vpcnetwork
resource "google_compute_network" "vpc_network1" {
  name                    = "vpc-net-1"
  auto_create_subnetworks ="false"
}
#creating custom subnetwork with enable vpc flow logs in specifies ip ranges
resource "google_compute_subnetwork" "vpc_subnetwork1" {
  name          = "subnet-1"
  network       = "${google_compute_network.vpc_network1.self_link}"
  region = "us-central1"
  ip_cidr_range = "168.130.0.0/20"
  
  
 depends_on = [
    google_compute_network.vpc_network1
  ]
}
resource "google_compute_subnetwork" "vpc_subnetwork2" {
  name          = "subnet-2"
  network       = "${google_compute_network.vpc_network1.self_link}"
  region = "europe-west1"
  ip_cidr_range = "10.130.0.0/24"
  
  
 depends_on = [
    google_compute_network.vpc_network1
  ]
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on network1
resource "google_compute_firewall" "network1_allow_http_ssh_rdp_icmp" {
  name    = "firewall1-allow-http-ssh-rdp-icmp"
  network       ="${google_compute_network.vpc_network1.self_link}"
  priority = 0
  source_ranges = ["0.0.0.0/0"] #
#allowing tcp protocol with required ports
  allow {
    protocol = "tcp"
    ports    = ["22","80","3389"]
  }
  allow {
    protocol = "icmp"
  }
  target_service_accounts = [google_service_account.serviceaccount_1.email]
   depends_on = [
    google_compute_network.vpc_network1
  ]
}

module "vm1-us-net1" {
  source              = "./instance"
  instance_name       = "vm1-us-net1"
  instance_zone       = "us-central1-a"
  instance_network = "${google_compute_network.vpc_network1.self_link}"
  instance_subnetwork = "${google_compute_subnetwork.vpc_subnetwork1.self_link}"
  instance_tags = ["vm1"]
  metadata_startup_script=""
  instance_email  = google_service_account.serviceaccount_1.email
    instance_scopes = ["cloud-platform"]
	
}

# Create the subnetworkb-eu-vm" instance
module "vm2-eu-net1" {
  source              = "./instance"
  instance_name       = "vm2-eu-net1"
  instance_zone       = "europe-west1-c"
  instance_network = "${google_compute_network.vpc_network1.self_link}"
  instance_subnetwork = "${google_compute_subnetwork.vpc_subnetwork2.self_link}"
  instance_tags = ["vm2"]
  metadata_startup_script=""
  instance_email  = google_service_account.serviceaccount_1.email
    instance_scopes = ["cloud-platform"]
	
}
