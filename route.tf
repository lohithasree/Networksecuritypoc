
resource "google_compute_route" "r1" {
  name        = "router1"
  dest_range  = "10.130.0.0/23"
  network     = "vpc-net-1"
  tags = ["vm1"]
  next_hop_instance="vm2-eu-net1"
  next_hop_instance_zone="europe-west1-c"
  priority    = 0
  depends_on = [module.vm2-eu-net1
  ]
 

}


resource "google_compute_route" "r2" {
  name        = "route2"
  dest_range  = "111.130.0.0/19"
  network     = "vpc-net-2"
  
  next_hop_instance="vm1-asia-net2"
  next_hop_instance_zone="asia-south1-a"
  priority    = 0
 depends_on = [
   module.vm1-asia-net2
 ]
}
