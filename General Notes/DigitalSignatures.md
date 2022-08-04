# Digital Signatures

## recap on public key crypto
pkc facilitated with public and private key architecture
 - private key
   - secret known only to you
 - public key
   - not secret, anyone can know it and should be publicly distributed

### Examples:
 - Signing something uses the private key which can be verified using the public key
   - Bob distributes a file that's digitally signed with his priv_key creating a digitally signed hash
   - Alice obtains bob's pub_key
   - Alice receives the file with the digitally signed hash
   - Alice takes the file and creates a hash using Bob's public key
   - The resultant hash should match the digitally signed hash from Bob
   - This process **verified the integrity** of the file ensuring it did not change in transit AND **verified the authenticity** as it was Bob's public key that provided the matching hash
