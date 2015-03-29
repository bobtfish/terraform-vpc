# terraform-vpc

Module to build a VPC.

Builds out 2 AZs: primary and secondary, with 3 subnets setup:

  * front (gets a public IP)
  * back (dedicated well known IP machines)
  * ephemeral (elb IPs and ASG managed / auto-scaling machines)

Builds an Internet gateway and a 'public' route table that routes
0.0.0.0/0 by the igw

Inputs:
  * region - default eu-central-1
  * account - The account/profile from your ~/.aws/credentials file
  * networkprefix - The first 2 octets of the IP address for this VPC. E.g. 10.84

Outputs:
  * primary-az-frontsubnet
  * primary-az-dedicatedsubnet
  * primary-az-ephemeralsubnet
  * secondary-az-frontsubnet
  * secondary-az-dedicatedsubnet
  * secondary-az-ephemeralsubnet
  * public-routetable

