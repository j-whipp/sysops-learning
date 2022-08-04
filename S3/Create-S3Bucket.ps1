<#
    .Description
    Some additional basic ways to interact with AWS S3 and IAM using powershell
#>


#region functions
function Test-Modules {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $CoreModules,
        
        [Parameter(Mandatory=$false)]
        [string[]]
        $SubModules
    )

    #install core modules
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
        else {write-host "core module $mod already present"}
    }
    start-sleep -Seconds 7
    #install submodules
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

$CoreModules = @(
    'AWS.Tools.Installer'
)
$SubModules = @(
    'AWS.Tools.Common'
    'AWS.Tools.S3'
)
Test-Modules -CoreModules $coremodules -submodules $SubModules

#
# set the session
#
Get-AWSCredential -ProfileName {{credential_profile_name}} | Set-AWScredential

#
# Create a storage group followed by storage admin user
#

#
# Assign a storage admin policy
#

#
# Set a new session credential profile with the newly created user
#

#
# S3 operations below
#

# create a bucket
$BucketName = {{bucket_name}}
$Region = {{region}}
New-S3Bucket -BucketName $BucketName -Region $Region

# upload an object
$uploadObj = {{path_to_file}}   # replace this
$fname = {{object_name}}        # replace this
Write-S3Object -BucketName $BucketName -Key $fname -File $uploadObj

#Delete the S3 bucket to cleanup
Remove-S3Bucket -BucketName $BucketName -deletebucketcontent -Force
