provider "google"{
    credentials="${file("${var.path}/networksecure.json")}"
    project="gcp-ngt-training"
    #region="us-central1"
}
variable "project" {
    default = "gcp-ngt-training"
}
variable "path" {
    default="C:/Users/THLOHITH/Desktop/terraformdemo/demo1/analysis"
}