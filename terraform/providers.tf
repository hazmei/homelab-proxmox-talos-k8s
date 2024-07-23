provider "talos" {}

provider "time" {}

provider "local" {}

provider "null" {}

# Use env var
# export PM_API_URL="https://<ip-addr>:8006/api2/json"
# export PM_API_TOKEN_ID="<user>@<realm>!<token-name>"
# export PM_API_TOKEN_SECRET="<token-secret>"
provider "proxmox" {
  pm_tls_insecure = true
  pm_timeout      = 300 # in seconds

  pm_debug    = false
  pm_parallel = 4
}