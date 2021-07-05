terraform {
  backend "gcs" { 
    bucket  = "gcp-nextjs-terraform"
    prefix  = "dev"
    credentials = "./serviceAccount.json"
  }
}