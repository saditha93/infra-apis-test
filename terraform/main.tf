# Import your SSH key to Hetzner
resource "hcloud_ssh_key" "me" {
  name       = "local-key"
  public_key = file(var.ssh_pubkey_path)
}

# Basic firewall: allow ssh, http, https
resource "hcloud_firewall" "fw" {
  name = "api-fw"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# Cloud-init: install Docker & docker-compose plugin
locals {
  cloud_init = <<-EOF
  #cloud-config
  package_update: true
  packages:
    - apt-transport-https
    - ca-certificates
    - curl
    - gnupg
    - software-properties-common
  runcmd:
    - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
    - apt-get update
    - apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    - usermod -aG docker ubuntu
    - systemctl enable docker
    - systemctl start docker
  EOF
}

resource "hcloud_server" "vm" {
  name         = var.server_name
  server_type  = var.server_type
  image        = var.server_image
  location     = var.hcloud_loc
  ssh_keys     = [hcloud_ssh_key.me.id]
  firewall_ids = [hcloud_firewall.fw.id]
  user_data    = local.cloud_init
}

# Cloudflare A records for both APIs
data "cloudflare_zone" "zone" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "api1" {
  zone_id = data.cloudflare_zone.zone.id
  name    = replace(var.api1_host, ".${var.cloudflare_zone}", "")
  type    = "A"
  value   = hcloud_server.vm.ipv4_address
  proxied = var.enable_cf_proxy
  ttl     = 1
}

resource "cloudflare_record" "api2" {
  zone_id = data.cloudflare_zone.zone.id
  name    = replace(var.api2_host, ".${var.cloudflare_zone}", "")
  type    = "A"
  value   = hcloud_server.vm.ipv4_address
  proxied = var.enable_cf_proxy
  ttl     = 1
}
