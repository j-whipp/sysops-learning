# AWS Services

## Public vs Private Services

 - Services are either Public or Private in nature(as relating to networking access)
 - You will never reach an EC2 instance by default from the outside world, you'd have to take a series as steps as the EC2 admin to make it discoverable
   - such as implementing an Internet gateway(IGW) and have NAT map a public IP to the EC2 private IP
   - this contrasts to S3 which is a public service

<img height='450' width='650' src="./Images/ServicesNetworking.png">


## Resilience
Services can be classified as one of three resilience types..
 - globally resilient
   - Few services are global, that is they'd only be down if every single AWS datacenter in the world went down too
   - IAM/route53
 - regionally resilient
   - regionally resilient services a single region with data replicated to multiple AZs
   - if an AZ fails the service can continue..if ALL the AZs in a region fail it the service fails too
 - AZ resilient
   - services running in a single AZ and if that AZ fails then so does the service
   - very prone to failure if the AZ has problems
   - EC2 falls under AZ resilient