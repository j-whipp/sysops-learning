<#
.NOTES
==================================================================================== 
This script creates an Organization under the Management Account and 
invites the Dev and Prod Accounts to join.

It also handles accepting the invites(handshakes in this case).

I used this to stand up orgs using free trial accounts for more practice managing 
realistic scenarios where you're managing multiple accounts in an enterpsie setting
==================================================================================
#>

#region FUNCTIONS
function Test-Modules {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $CoreModules,
        
        [Parameter(Mandatory)]
        [string[]]
        $SubModules
    )

    # install core modules
    foreach ($mod in $coremodules) { 
        if ( ! (Get-Module -Name $mod -listavailable)) {
            try {
                Write-Host "Missing $mod, installing now.." -ForegroundColor 'darkyellow'
                Install-Module -Name $mod -Force -Scope CurrentUser -Repository $(Get-PSRepository).Name
                Import-Module -Name $mod
            }
            catch {
                Write-Error $_.Exception.Message -ErrorAction 'Stop'
                Exit
            }
        }
    }
    start-sleep -Seconds 10
    # install submodules
    foreach ($submod in $SubModules) { 
        if ( ! (Get-Module -Name $submod -listavailable)) {
            try {
                Write-Host "Missing $submod, installing now.." -ForegroundColor 'darkyellow'
                Install-AWSToolsModule -Name $submod -Scope CurrentUser -Force
                Import-Module -Name $submod
            }
            catch {
                Write-Error $_.Exception.Message -ErrorAction 'Stop'
                Exit
            }
        }
    }
}
#endregion

#region PARAMS
$CoreModules = @(
    'AWS.Tools'
    'AWS.Tools.Installer'
)
$SubModules = @(
    'AWS.Tools.Organizations'
)
#endregion

#region MAIN
Test-Modules -CoreModules $coremodules -subModules $SubModules

# Launches API session under provided mgmt/admin profile
Set-AWSCredential -ProfileName '{{mgmt_credential_profile}}'

# create the Org
try {
    $orgParams = @{
        FeatureSet = 'ALL'
        Region = 'us-east-1'
    }
    New-OrgOrganization @orgParams -Select *
    start-sleep 5
    Get-ORGOrganization -Region ($orgParams.region)
}
catch {
    throw $_.Exception.Message
}

# Send invites to Dev + prod accounts, in this case we chose handshake type EMAIL so we provided an email in the target_id
# https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/Organizations/THandshakePartyType.html
try {
    $ProdAccountParams = @{
        Target_ID = "{{email}}+Prod@gmail.com"
        Note = "Invite to SysOpsLearning Org"
        Target_Type = "EMAIL"
        Region = 'us-east-1'
    }
    $DevAccountParams = @{
        Target_ID = "{{email}}+Dev@gmail.com"
        Note = "Invite to SysOpsLearning Org"
        Target_Type = "EMAIL"
        Region = 'us-east-1'
    }
    New-ORGAccountInvitation @ProdAccountParams
    New-ORGAccountInvitation @DevAccountParams
    "Invited 2 emails {0} and {1}" -f $ProdAccountParams.Target_ID, $DevAccountParams.target_id
}
catch {
    throw $_.Exception.Message
}

# accept the invites on the non-mgmt accounts
try {
    $profiles = ( (Get-AWSCredential -ListProfileDetail).where{ $_.ProfileName -ne '{{mgmt_credential_profile}}' } ).ProfileName
    foreach ($pf in $profiles) {
        Set-AWSCredential -ProfileName $pf
        $hs = Get-ORGAccountHandshakeList -Region 'us-east-1'
        Confirm-ORGhandshake -HandshakeID $hs.id -Region 'us-east-1'
    }
} 
Catch {
    throw $_.Exception.Message
}