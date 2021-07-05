


resource "google_cloudbuild_trigger" "build-trigger" {
  name = "build-frontend"

  github {
    owner = "n3rdkid"
    name = "terraform-gcp-nextjs"
    push {
      branch = "main"
    }
  }
    build {
    timeout = "600s"
    step {
    name = "node:14"
    entrypoint = "yarn"
    args = [
            "install"]
    dir = "./client"
    }
    step {
    name = "node:14"
    entrypoint = "yarn"
    args = [
        "build"]
    dir = "./client"
    }
    step {
    name = "gcr.io/cloud-builders/docker"
    args = [
        "build",
        "-t",
        "gcr.io/${var.project}/zip",
        "./client"]
    dir = "./docker_zip"
    }
    images = [
    "gcr.io/${var.project}/zip"]
    step {
    name = "gcr.io/${var.project}/zip"
    args = [
        "-r",
        "artifact.zip",
        ".",
        "-x",
        "*/.git/*"]
    dir = "./client"
    }
    step {
    name = "bash"
    args = [
        "ls",
        "-la",
        ]
    dir = "./client"
    }
    artifacts {
        objects {
            location = var.artifacts_location
            paths = [
            "artifact.zip"]
        }
        }
 }
}

resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.region
}
resource "google_app_engine_standard_app_version" "gcp_terraform" {
  version_id = "v1"
  runtime    = "nodejs14"
  service = "default"

  deployment {
  zip {
      source_url = var.artifacts_url
  }
  }
  handlers {
    url_regex = "/.*"
    security_level = "SECURE_ALWAYS"
    script {
      script_path = "auto"
    }
  }

  delete_service_on_destroy = true
}