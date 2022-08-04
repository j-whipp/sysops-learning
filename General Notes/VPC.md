# VPC - Virtual Private Cloud

## what is it?
 - a virtual network inside AWS
 - all your compute lives here
 - foundational service thats connects your on-prem compute to the private compute you create if you're in hybrid model
 - regionally resilient
 - vpc is within 1 account & 1 region
 - private and isolated unless configured otherwise
 - on account creation a default vpc is created

**exam point**
How many default VPCs can you have per region?
 - One default VPC per region
  

### Default VPC
 - VPC CIDR is always 172.31.0.0./16
 - one subnet per AZ in that region
 - one default vpc per region
 - could be removed in theory, but some services rely on that default vpc existing so it should be left alone? more on this later...
 - resources assigned to default vpc receive public ipv4 addrs by default

#### Default VPC summed up
 - default vpcs aren't flexible, networking ranges are largely pre-carved and logically structured for you
 - be careful when assigning services to the default vpc, they will automatically obtain public ipv4 addresses