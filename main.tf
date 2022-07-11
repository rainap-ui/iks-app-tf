terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  client_certificate = base64decode(var.kubeclientcert)
  client_key = base64decode(var.kubeclientkey)
  cluster_ca_certificate = base64decode(var.kubeclustercert)
  }

resource "kubernetes_manifest" "python-docker-deployment" {

  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "sample-app"
      }
      "name"      = "sample-app"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = 2
      "selector" = {
        "matchLabels" = {
          "app" = "sample-app"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "sample-app"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "rainap/python-docker"
              "name"  = "sample-app"
            },
          ]
        }
      }
    }
  }

}