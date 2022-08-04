<#
can have an infinite number of sub email accounts all linked to your main@gmail.com with ZERO configuration
https://support.google.com/a/users/answer/9308648?hl=en
ex. youremail+Prod@gmail.com & youremail+Dev@gmail.com 
    Both will send mail just to youremail@gmail.com but you can setup filters and whatnot
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
    }
    start-sleep -Seconds 10
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

function New-IAMAdminsFromRootAccount {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]
        $ProfileName
    )
    $un = "$($ProfileName.tolower().trim('root'))iam-admin"

    Set-AWScredential -ProfileName $ProfileName    
    New-IAMGroup -GroupName 'Administrators'    
    New-IAMUser -UserName $un
    Add-IAMUserToGroup -GroupName 'Administrators' -Username $un
    New-IAMLoginProfile -Username $un -passwordresetrequired $true -password (Read-Host "enter OTP")
    $KeyObj = New-IAMAccessKey -UserName $un
    $credsplat = @{
        AccessKey = $KeyObj.AccessKeyID 
        SecretKey = $KeyObj.SecretAccessKey 
        StoreAs = "$($ProfileName.tolower().trim('root'))iam-admin"
    }
    Set-AWScredential @credsplat
    Get-AWSCredentials -ListProfileDetail
    if(!(Get-IAMAttachedGroupPolicies -GroupName 'Administrators')) {
$AdminAccessDoc = @"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
"@
        "Writing policy to group"
        Write-IAMGroupPolicy -GroupName 'Administrators' -PolicyName "AdministratorAccess" -policydocument $AdminAccessDoc
    }
    Get-IamGroupPolicies -GroupName 'Administrators'                                                            
}
#endregion

#region PARAMS
$CoreModules = @(
    'AWS.Tools.Installer'
)
$SubModules = @(
    'AWS.Tools.IdentityManagement'
)
#endregion

#region MAIN
Test-Modules -CoreModules $coremodules -subModules $SubModules

Try {
    #get root cred object for each root account
    $rootProfiles = (Get-AWSCredential -ListProfileDetail | where-object profilename -like "*-root").ProfileName
    $rootProfiles | Foreach-Object { New-IAMAdminsFromRootAccount -ProfileName $_ }
}
Catch {
    throw $_.Exception.Message
}

Try {
    #get root cred object for each root account
    $rootProfiles = (Get-AWSCredential -ListProfileDetail | where-object profilename -like "*-root").ProfileName
    $rootProfiles | Foreach-Object { Remove-AWSCredentialProfile -ProfileName $_ -Force ; write-output "DONT FORGET TO DELETE THE KEYS VIA THE CONSOLE TOO FOR $_" }
}
Catch {
    throw $_.Exception.Message
}

write-output "Ready to create org..refer to create-org.ps1 under config"
#endregion