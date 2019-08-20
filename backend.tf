terraform {
  backend "gcs" {
    bucket  = "tf-backend-techdox"
    prefix  = "terraform/state"
  }
}
