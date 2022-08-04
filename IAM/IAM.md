- [IAM Service](#iam-service)
  - [What is it?](#what-is-it)
  - [One more time to drive it home](#one-more-time-to-drive-it-home)
  - [Accessing IAM for the first time after you've logged into root accounts](#accessing-iam-for-the-first-time-after-youve-logged-into-root-accounts)
  - [Best Practices](#best-practices)
    - [Access Keys](#access-keys)
      - [Small exercise](#small-exercise)
      - [Structure of Access Keys](#structure-of-access-keys)
  - [Types of Identity objects](#types-of-identity-objects)
    - [Users](#users)
    - [Groups](#groups)
    - [Roles](#roles)
      - [Best Practices](#best-practices-1)
  - [Access Control Models](#access-control-models)
    - [RBAC](#rbac)
    - [ABAC](#abac)
  - [Accesss Management](#accesss-management)
    - [Policies](#policies)
    - [Permissions](#permissions)
  - [IAM Identifiers](#iam-identifiers)
    - [Friendly names/paths](#friendly-namespaths)
    - [IAM ARNs](#iam-arns)
    - [Unique identifiers](#unique-identifiers)
  - [Policy Documents](#policy-documents)


# IAM Service
## What is it?
<li>A <b>global</b> service, probably the core of aws i guess</li>
<li>The service you use to define who can access what by specifying
<b>fine-grained permissions</b>.</li>
<li>Access to anything is <b>denied by default</b> and access is granted ONLY when permissions specify an <b>"Allow"</b></li>

`Any data is always secure across all AWS regions`
## One more time to drive it home
 - IAM has 3 main jobs
   - Manages Identities - Identity Provider(IDP) for managing identities(users/roles/groups)
   - Authenticate - proves who you are
   - Authorize - Allow or Deny access to resources
 - No cost
 - One global database for your account and globally resillient
 - IAM only controls local identities in it's AWS Account
   - it CANNOT control/accesss/act on extrnal accounts
## Accessing IAM for the first time after you've logged into root accounts
Again as noted earlier, upon creation the root account does **NOT** have API/CLI access.
 1. Need to generate **Access keys**
      * Access key ID
      * Secret Access Key
 2. copy the two values over into config_*.json for each AWS Account and open powershell run ```& .\Create-AWSCredentialsJSON.ps1```
     * This creates a secured credential file you can interact with using `AWS.Tools.Common` powershell module to cryptographically sign the web request
      * https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html


`Seriously immediately, per https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html "The secret access key is available for download only when you create it. If you don't download your secret access key or if you lose it, you must create a new one."`


## Best Practices
 - **Never** use root except for the few tasks only it can accomplish https://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html#aws_tasks-that-require-root

- Instead create an **IAM Admin with AdministratorAccess** and only ever use root in emergencies(like resetting an iamadmin pwd) or to do one of the tasks in the above link
  - Like everything, I immediately scripted this since I had multiple accounts and didnt want to configure an admin group for each and then an iam admin and then add the iam admin to the group and then attach the policy etc etc
  - ----> [here](iam.ps1)


### Access Keys
 - Long-term credentials used within AWS. Called this because they don't change "regularly" or "rotate".
   - you as the owner have to explicitly change them
   - can be **created**, **deleted**, made **inactive**, or made **active**

#### Small exercise
1) An IAM User with just console login has **1 Username** and **1 Password** but **no AccessKeys**
2) An IAM User with just API/CLI access has **1 Username** and **no Password** and **1 or at most 2 AccessKeys**
3) You can probably guess what an IAM user with both forms of access has...

#### Structure of Access Keys
1. Access Key ID <---- Think Public Key/Username/Anyone can know this
2. Secret Access Key <---- Think Private Key/Password/Nobody can know this but you and AWS


## Types of Identity objects
### Users
 - Identities which represent humans or applications used to interact with AWS
   - Popularly used for providing console access or programmatic access
### Groups
 - Collections of related IAM users(ideally, but in theory its just a collection of IAM users related or not)
 - Allows for scalable permission management of related users e.g. dev team, finance, qa team
### Roles
 - Identity object with specific permission policies that determine what the identity can and cannot do in AWS
 - Does not have any credentials(pwd or accesskeys) associated with it by design
 - Instead a role is meant to be assumable by anyone who needs it
   - Can be used by AWS services
   - Can be used for granting external accesss to your account in a scalable fashion
`Generally used when you want to grant acesss to services in your account to an unknown number of entities i.e. being scalable`



#### Best Practices
https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html#use-roles

 - tldr apply permissions to Roles and have Users assume Roles wherever possible. 

## Access Control Models
### RBAC
### ABAC
## Accesss Management
### Policies
### Permissions
## IAM Identifiers
### Friendly names/paths
### IAM ARNs
### Unique identifiers
## Policy Documents
 - Can be used to Allow or Deny access to AWS services ONLY when attached to an IAM User/Group/Role
 - JSON document
