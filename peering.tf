
resource "google_compute_network_peering" "peering1" {
  name         = "peering1"
  network      = google_compute_network.vpc_network1.id
  peer_network = google_compute_network.vpc_network2.id
  
  import_custom_routes = true
  export_custom_routes = true
  depends_on = [
    #google_compute_network.vpc_network1
    google_compute_network.vpc_network1
  ]
  }

resource "google_compute_network_peering" "peering2" {
  name         = "peering2"
  network      = google_compute_network.vpc_network2.id
  peer_network = google_compute_network.vpc_network1.id
  
  import_custom_routes = true
  export_custom_routes = true
  depends_on = [
    #google_compute_network.vpc_network2
    google_compute_network.vpc_network2


  ]
  
 
}
