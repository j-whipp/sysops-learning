# Cloudwatch

## What is it?
A service which collects and manages operational data on your behalf.
Three components:
 - **Metrics** (data relating to aws products, apps, on-premise compute perf counters, etc)
   - some metrics are gathered natively
     - ex. cpu util on an ec2 isntance is collected by default
 - **Logs** (of aws propducts, apps, on-premise windows logs, etc)
   - in order to gather logs of components outside AWS will need to install cloudwatch agent on that resource
 - **Events** (captures info on events AWS services take & setting scheduled events)

## Key concepts:

### Namespace
 - container for monitoring data
   - organize data into different areas
 - All AWS data must go into a namespace of the format **AWS/service** ex. AWS/EC2 contains all metrics for EC2
 - contain related metrics

### Metrics
 - collection of related datapoints in a time ordered structure
 - examples:
   - cpu util% over time
   - mem usage % over time
   - DISK IO over time
   - Network IO


