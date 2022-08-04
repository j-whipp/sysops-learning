<#
.NOTES
=======================================================================================
This file will invoke the AWS SDK to securely generate a config in RegisteredAccounts.json
in $env:LOCALAPPDATA\AWSToolkit. Can then easily retreive credentials with tools in
AWS.Tools.Common

MUST configure the three config_*.json files in the $pwd
with the manually generated root account access keys before running this script

The credentials are utilized when crafting requests to AWS thru AWs.Toools or AWSPowerShell
==================================================================================
#>

#region FUNCTIONS
function Test-RunningInElevatedSession {
    [CmdletBinding()]
    [OutputType([bool])]

    #returns True if elevated
    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    
    if( -not $isAdmin ) {
        #build an exception -> use it to then create an error record -> ultimately throw it
        #this is one way to build custom exceptions
        $exception = New-Object System.InvalidOperationException "The current Windows PowerShell session is not running as Administrator. Start Windows PowerShell by using the Run as Administrator option, and then try running the script again."
        $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, "InvalidOperationException", ([System.Management.Automation.ErrorCategory]::PermissionDenied),$null
        throw $errorRecord
    }
    else {
        $isAdmin
    }
}
#endregion 

#region PARAMS
$CoreModule = @(
    'AWS.Tools.Installer'
)
$SubModules = @(
    'AWS.Tools.IdentityManagement'
)
$configs = @(
    'config_management.json',
    'config_prod.json',
    'config_dev.json'
)
#endregion

#region MAIN
try {
    Test-RunningInElevatedSession
}
catch {
    throw $error[0]
    exit
}


# install coremodules
foreach ($mod in $coremodule) { 
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

foreach ($config in $configs) {
    if( ! (Test-Path -PathType Leaf $config) ) {
        throw "$config not found. YIKES!"
    }
    
    $ConfigFileName = Split-Path -Path "$pwd\$config" -Leaf 
    $Object = Get-Content $ConfigFileName | convertfrom-json
    if( ($object.accountname -like "Your*") -or ($object.securitykey -like "Your*") -or ($object.AccessKeyID -like "Your*") ){
        throw "OOPS! you forgot to edit the json file $config"
    }
    # Let AWS SDK securely store the credential, encrypts given input and stores in json file
    # stored in %USERPROFILE%\AppData\Local\AWStoolkit\RegisteredAccounts.json
    # can only ever be decrypted by the account that encrypted it
    Write-output "Creating secure credential for $($Object.AccountName) inside $env:USERPROFILE\AppData\Local\AWStoolkit\RegisteredAccounts.json"
    Set-AWScredential -AccessKey $($object.AccessKeyID) -SecretKey $($Object.SecretKey) -StoreAs $($Object.AccountName)

    # recreate the current configs
    Get-Item $config | Remove-item -Force
    $newConfigObj = [PSCustomObject]@{
        AccessKeyID = 'YourAccessKeyIDHere'
        SecretKey = 'YourSecretKeyHere'
        AccountName = 'YourAccountNameHere'
    }
    $json = $newConfigObj | convertto-json
    $json | out-file "$config"

    Write-output "Done re-creating json templates"
    Get-AWSCredential -ListProfileDetail
}
#endregion

#region CLEANUP
#good practice to clear these files if you don't already have psreadline save history turned off..more on this https://0xdf.gitlab.io/2018/11/08/powershell-history-file.html
get-childitem "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\*" | foreach-object { remove-item $_ -force }

#if you want to explore how safe strings are in memory https://get-powershellblog.blogspot.com/2017/06/how-safe-are-your-strings.html
#tldr not very, so reading up on implementing garbage collection is probably a good idea

#endregion
