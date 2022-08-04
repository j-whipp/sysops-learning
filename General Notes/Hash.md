# Hashing

## what is it?
  - Hashing is when you pass objects/vars/data/etc thru hash functions and receive back fixed length "hashes"
  - (data object) -in-> [Hash Function] -out-> (hash)
 
 - One way process, cannot for example go from  (hash) --> [Hash Function] --> (data object)
  
 - Theoretically possible to brute force every possible hash and find the data object that created it, although good luck?
Only other alternative is for there to be a flaw in the hash function(algorithm)


## Real world example:

You create a UN and PW for website ---> your credential info is stored server side
 - if stored in plaintext gg no re
 - ideally stored as hashes so when you attempt a log in a hash of ur pwd is compared against the hash in the server's login db

collisions theortically exist with md5 and others, pay attention to the algo and aim for sha2-256 variants?

