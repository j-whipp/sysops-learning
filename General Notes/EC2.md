# EC2 Elastic Compute Cloud

## what is it?
 - A cloud compute service, largely regarded as the default compute service in aws
 - provides access to virutal machines running in the "cloud"
 - AZ resilient
   - meaning if an Availability zone fails then those EC2 instances will fail too
 - IaaS (Infrastructure as a service)
 - private by default, if you want public access it needs to be configured via igw and networking rules
  
## Instance States
Most common to think about:
 - Running
   - When in running state you are charged per second or per hour on cpu/memory/storage/networking
 - Stopped
   - when stopped you no longer incur cpu/memory/networking costs, BUT storage costs remain of course
 - Terminated
   - can be terminated from either a running or stopped state
   - non-reversible, destroys everythign essentially..


