# NSXT-Terraform
This repository contains a sample configuration that can be used to deploy networks off a tier-0 router in NSX-T. 

This configuration will deploy a production and dev tier-1 routers. Each router also has two segments created that can be used for web and application tier workloads. 

This type of configuration could be very useful in a homelab scenario where you wish to blow away networks and reconfigure the environment on a regular basis.

At this current time this nsx-t terraform covers resources hanging off a tier-0 router. At the current time the NSX-T terraform provider does not cover more than this. 

For information about Terraform and NSX-T integration, have a look at the provider documentation here[link](https://www.terraform.io/docs/providers/nsxt/index.html).

# Usage 

To use this configuration there are a few changes that you will need to make. 

- Within the terraform.tfvars file, configure account information for your NSX-T environment to allow terraform access. 
- Modify the overlay and vlan transport zone names to the display name of your configured transport zones. 
- Change the ID associated with your tier-0 router. This can be found from within the NSX-T manager UI. 
- Modify the 4 logical router downlink port subnets to the networks ranges you wish to configure on this subnet. The 10.0.x.x ranges used are just example ranges. 

