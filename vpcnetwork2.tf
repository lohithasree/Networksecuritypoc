#creating vpcnetwork

resource "google_compute_network" "vpc_network2" {
  name                    = "vpc-net-2"
  auto_create_subnetworks ="false"
}
#creating custom subnetwork with enable vpc flow logs in specifies ip ranges
resource "google_compute_subnetwork" "subnetwork1-network2" {
  name          = "subnet-1-network2"
  network       = "${google_compute_network.vpc_network2.self_link}"
  region = "asia-south1"
  ip_cidr_range = "111.130.0.0/20"
  
  
 depends_on = [
    google_compute_network.vpc_network2
  ]
}

resource "google_compute_firewall" "allow_http_ssh_rdp_icmp_network2" {
  name    = "firewall-allow-http-ssh-rdp-icmp-network2"
  network       = "${google_compute_network.vpc_network2.self_link}"
  priority = 0
  source_ranges = ["0.0.0.0/0"]
#allowing tcp protocol with required ports
  allow {
    protocol="tcp"
    ports=["80","22","3389"]
  }
  allow {
    protocol = "icmp"
  }
  target_service_accounts = [google_service_account.serviceaccount_2.email]
   depends_on = [
    google_compute_network.vpc_network2
  ]
}


# Add the networkc-us-vm instance1

module "vm1-asia-net2" {
  source              = "./instance"
  instance_name       = "vm1-asia-net2"
  instance_zone       = "asia-south1-a"
  instance_network = "${google_compute_network.vpc_network2.self_link}"
  instance_subnetwork = "${google_compute_subnetwork.subnetwork1-network2.self_link}"
  instance_tags = ["http-server","vm3"]
  #installing apache server
  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html"

    #Apply the firewall rule to allow external IPs to access this instance
  #tags = ["http-server"]
  instance_email  = google_service_account.serviceaccount_2.email
    instance_scopes = ["cloud-platform"]
	
  
}

# Add the networkc-us-vm instance2
module "vm2-asia-net2" {
  source              = "./instance"
  instance_name       = "vm2-asia-net2"
  instance_zone       = "asia-south1-b"
  instance_network = "${google_compute_network.vpc_network2.self_link}"
  instance_subnetwork = "${google_compute_subnetwork.subnetwork1-network2.self_link}"
  instance_tags = ["vm4"]
  metadata_startup_script = ""
  instance_email  = google_service_account.serviceaccount_2.email
    instance_scopes = ["cloud-platform"]
	
  
}
