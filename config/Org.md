# Organizations
 - An orgnization is an entity that allow you to consolidate your AWS accounts so you can manage them as a single unit.
 - Contains 1 management account and zero or more member accounts. Heirarchical like Active directory

## Structure
### Root
 - The parent container for all accounts in the org and it applies to ALL OUs and   accounts. 
 - You can only have one root container
   - automatically created when you create an org

### Org Unit (OU)
 - container for accounts within a root. Can also contain nested OUs
  
`An OU can have exactly one parent, and currently each account can be a member of exactly one OU.`

### Accounts
 - The AWS accounts you create which contain the resources and identities that can access those resources
 - Two types of Accounts in an Org:
   - Management Account - used to create the org
     - Can create member accounts
     - Invite other existing accounts into the org
     - Remove accounts from org
     - manage invitations
     - apply policies to entities(roots,OU,accounts) within the org
     - Enable integration with supported AWS services to provide service functionality across all of the accounts in the organization
   - Member Account which just inherit whatever policies you apply

## Setting up Org via Scripts
Craeted an org manually, but now going to use the `Create-SysOpsOrg` script in `~/config/`

Pre-reqs:
 - Created a Managment/Prod/Dev AWS Account
 - Ran `Create-AWSCredentialsJSON` in `~/config/` to secure api keys
 - Ran `IAM.ps1` in `~/IAM/` to create iam-admins under each AWS account

After running the script 1 Management Account + 2 Member Accounts all reside within root parent container
![](/Images/orgafter.png)
