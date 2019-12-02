#
# The first step is to configure the VMware NSX provider to connect to the NSX
# REST API running on the NSX manager.
#
provider "nsxt" {
  host                  = "${var.nsx_manager}"
  username              = "${var.nsx_username}"
  password              = "${var.nsx_password}"
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

#
# Define Tags to add to terraform components
#
variable "nsx_tag_scope" {
  default = "project"
}

variable "nsx_tag" {
  default = "terraform"
}

data "nsxt_edge_cluster" "edge_cluster" {
  display_name = "Prod Edge Cluster"
  id = "94e9764d-1bd7-4d35-9108-6b0117e7d8e1"
}

data "nsxt_transport_zone" "overlay_tz" {
  display_name = "Overlay TZ"
}

data "nsxt_transport_zone" "vlan_tz" {
  display_name = "VLAN TZ"
}

data "nsxt_logical_tier0_router" "tier0_router" {
  id = "d7b9a940-ac65-4596-b188-42c790436a60"
}
resource "nsxt_logical_tier1_router" "tier1_router1" {
  display_name = "Prod - T1"
  description            = "Tier1 router provisioned by Terraform"
  edge_cluster_id        = "${data.nsxt_edge_cluster.edge_cluster.id}"
  enable_router_advertisement = true
  advertise_connected_routes  = true
}


resource "nsxt_logical_tier1_router" "tier1_router2" {
  display_name = "Dev - T1"
  description            = "Tier1 router provisioned by Terraform"
  edge_cluster_id        = "${data.nsxt_edge_cluster.edge_cluster.id}"
  enable_router_advertisement = true
  advertise_connected_routes  = true
}

resource "nsxt_logical_switch" "switch1" {
  admin_state       = "UP"
  description       = "LS created by Terraform"
  display_name      = "Prod - Web"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode  = "MTEP"

  tag {
    scope = "${var.nsx_tag_scope}"
    tag   = "${var.nsx_tag}"
  }
}

resource "nsxt_logical_port" "logical_port1" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP Prod - Web"
  logical_switch_id = "${nsxt_logical_switch.switch1.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port1" {
  description                   = "DP1 provisioned by Terraform"
  display_name                  = "Prod - Web"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router1.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port1.id}"
  ip_address                    = "10.0.6.1/24"
}


resource "nsxt_logical_switch" "switch2" {
  admin_state       = "UP"
  description       = "LS created by Terraform"
  display_name      = "Prod - App"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode  = "MTEP"

  tag {
    scope = "${var.nsx_tag_scope}"
    tag   = "${var.nsx_tag}"
  }
}

resource "nsxt_logical_port" "logical_port2" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP Prod - App"
  logical_switch_id = "${nsxt_logical_switch.switch2.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port2" {
  description                   = "DP1 provisioned by Terraform"
  display_name                  = "Prod - App"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router1.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port2.id}"
  ip_address                    = "10.0.7.1/24"
}

resource "nsxt_logical_switch" "switch3" {
  admin_state       = "UP"
  description       = "LS created by Terraform"
  display_name      = "Dev - Web"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode  = "MTEP"

  tag {
    scope = "${var.nsx_tag_scope}"
    tag   = "${var.nsx_tag}"
  }
}

resource "nsxt_logical_port" "logical_port3" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP Dev - Web"
  logical_switch_id = "${nsxt_logical_switch.switch3.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port3" {
  description                   = "DP1 provisioned by Terraform"
  display_name                  = "Prod - Web"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router2.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port3.id}"
  ip_address                    = "10.0.4.1/24"
}


resource "nsxt_logical_switch" "switch4" {
  admin_state       = "UP"
  description       = "LS created by Terraform"
  display_name      = "Dev - App"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode  = "MTEP"

  tag {
    scope = "${var.nsx_tag_scope}"
    tag   = "${var.nsx_tag}"
  }
}

resource "nsxt_logical_port" "logical_port4" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP Prod - App"
  logical_switch_id = "${nsxt_logical_switch.switch4.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port4" {
  description                   = "DP1 provisioned by Terraform"
  display_name                  = "Prod - App"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router2.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port4.id}"
  ip_address                    = "10.0.5.1/24"
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1-1" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  display_name                  = "ProdT1-Port"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router1.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.link_port_tier0_1.id}"
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0_1" {
  description       = "TIER0_PORT1 provisioned by Terraform"
  display_name      = "Prod-T1-Link"
  logical_router_id = "${data.nsxt_logical_tier0_router.tier0_router.id}"
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1-2" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  display_name                  = "DevT1-Port"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router2.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.link_port_tier0_2.id}"
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0_2" {
  description       = "TIER0_PORT1 provisioned by Terraform"
  display_name      = "Dev-T1-Link"
  logical_router_id = "${data.nsxt_logical_tier0_router.tier0_router.id}"
}