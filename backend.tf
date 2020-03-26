terraform {
  backend "gcs" {
    bucket  = "tf-backend-minecraft"
    prefix  = "terraform/state"
  }
}
