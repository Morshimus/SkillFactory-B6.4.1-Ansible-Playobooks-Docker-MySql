function ansible {
    param (
        [Parameter(Mandatory=$False)]
        [string]$distr = "Ubuntu-20.04",
        [Parameter(Mandatory=$False)]
        [String]$user = "morsh92",
        [Parameter(Mandatory=$False,Position=0)]
        [String]$args
    )
    wsl -d $distr -u $user -e ansible $args
} 

Set-Alias ansible-playbook ansiblePlaybook
function ansiblePlaybook {
    param (
        [Parameter(Mandatory=$False)]
        [string]$distr = "Ubuntu-20.04",
        [Parameter(Mandatory=$False)]
        [String]$user = "morsh92",
        [Parameter(Mandatory=$False,Position=0)]
        [String]$args
    )
    wsl -d $distr -u $user -e ansible-playbook $args
} 

function createWslMySQLDockerContainer {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$user,
        [Parameter(Mandatory=$false,Position=1)]
        [SecureString]$dbPassword = $(Read-Host 'What passowrd you want set to db?' -AsSecureString)
    )
    
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword)
    $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $path = $($(Get-Location).path -replace "\\", "/") -replace "C:","/mnt/c"
    
 
    
    wsl -d Ubuntu-20.04 -u $user -e ansible-playbook --extra-vars "local_wsl_user=$user password_db=$unsecurePassword"  $path/provisioning.yaml

    $latest = wsl -d Ubuntu-20.04 -u $user -e docker -H unix:///mnt/wsl/shared-docker/docker.sock ps --latest --quiet 
    
    $passArg = "-p$unsecurePassword"

    Wait-Event -Timeout 40

    wsl -d Ubuntu-20.04 -u $user -e docker -H unix:///mnt/wsl/shared-docker/docker.sock exec -it $latest mysql -uroot $passArg


}