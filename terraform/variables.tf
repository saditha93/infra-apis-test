variable "hcloud_token" { type = string }
variable "cloudflare_api_token" { type = string }

variable "ssh_pubkey_path" {
  type        = string
  description = "Path to your public SSH key (e.g. ~/.ssh/id_ed25519.pub)"
}

variable "server_name" {
  type    = string
  default = "flask-apis-1"
}

variable "server_type" {
  type    = string
  default = "cx22"
}

variable "server_image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "hcloud_loc" {
  type    = string
  default = "hel1"
}

variable "cloudflare_zone" { type = string }
variable "api1_host" { type = string }
variable "api2_host" { type = string }

variable "enable_cf_proxy" {
  type    = bool
  default = true
}
