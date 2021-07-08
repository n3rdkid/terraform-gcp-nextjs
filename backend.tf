terraform {
  backend "gcs" { 
    bucket  = "cloud-artfiactbuild-test-123-artfiact"
    credentials = "./serviceAccount.json"
  }
}