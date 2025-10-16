terraform {
  required_version = ">= 1.6.0"
  required_providers {
    hcloud     = { source = "hetznercloud/hcloud", version = "~> 1.48" }
    cloudflare = { source = "cloudflare/cloudflare", version = "~> 4.39" }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}