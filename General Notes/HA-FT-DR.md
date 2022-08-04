# High-availability
 - HA aims to ensure an agreed level of operational performance, aka uptime, for a higher than normal period.
 - HA doesnt aim to stop failure
 - HA systems are designed to be online and providing services as often as possible (uptime)
 - Often uses automation for self-healing of failed services
 - purely focused on maximizing uptime through fast or automatic recovery of issues
 - often requires redundant infrastructure for fail-over in an **active stand by architecture**
   - think failover NVRs
   - still causes a brief outage

# Fault-tolerance
 - FT aims to ensure a system can continue to operate in the event of a failure of some(one or more faults) of its components
 - If a system is FT, it has to contoniue to operate through a failure without impacting customers(causing an outage/downtime/etc)
 - ex. nuclear power plant infrastructure needs to be more than just HA, it needs fault-tolerance so as to not fail
 - ex2. medical equipment at hospitals monitoring the life of an individual can't afford to fail, need to be FT
 - can use redudnant infrastrcuture but this time in ab **active, active configuration**
   - ex2. that medical equipment can be configured to talk to two servers at the same time so if one fails there's no hiccups
 - Large airplanes are massively fault-tolerant systems so if one of the systems in a stack fails it can keep going without faults
   - dual avionics systems
   - extra engines
   - duplicate hydrolics
   - etc
 - FT is generally expensive to implement, at least moreso than HA


# disaster-recovery

## what is it?

Disaster Recovery(DR) is a set of policies, tools, and procedures to *enable the recovery* or *continuation* of *vital* technology infrastructure and systems *following a natural or human-induced disaster*

AKA Planning for what to do when shit hits the fan because HA and FT ain't getting the job done when the datacenter is flooding or there's a tornado over the datacenter