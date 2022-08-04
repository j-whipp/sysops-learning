# DNS Domain Name System

## what is it?

DNS allows for the translation of machine readable addresses into human readable formats and vice-versa.
ex. instead of typing 172.217.164.78 in my address bar I can just type google.com

Core service that underpins all infrastructure and the internt in general
 - It's a discovery service at heart
1) I type google.com
2) DNS will perform discovery to see what is the IP of google.com before sending me there since 'google.com' means nothing on its own to the computer
3) The DNS record that contains the IP we need is located in some **zone file**. this zone file is hosted by a dns server known as a name server or NS
4) DNS resolver software or server queries the DNS sytem on your behalf to search for the zone file and gets the result thru a few more intermediary steps ofc
   
### DNS ROOT

Using a root hints file, we can have a pointer to the root dns servers. or your OS or DNS resolver software will query the dns root servers which host the dns root zone

 - built on a chain of trust model, you start with the implicit trust of the 13 root servers which delegate further responsibility to registries which host additonal top-level-domain name servers for that given domain.
   - ex. verisign is the TLD manager for .com domain aka it's authoratative for .com
   - when you query google.com your dns lookup is sent to a root dns server --> then sent to verisign's hosted TLD nameservers(NS) --> the NS then takes your query and sends to the amazon.com zone
   - Remember you essentially read the the domain name backwards so starting with .com to get to the .com nameservers -> then immediately to the left of .com is amazon.com so the target is the amazon.com zone which is managed by well amazon of course



