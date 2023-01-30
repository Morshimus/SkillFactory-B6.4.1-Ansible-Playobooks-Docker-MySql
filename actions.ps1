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
        [Securestring]$dbPassword = $(Read-Host 'What is your password?' -AsSecureString)
    )
    
    $path = $($(Get-Location).path -replace "\\", "/") -replace "C:","/mnt/c"
    
    wsl -d Ubuntu-20.04 -u $user -e ansible-playbook --extra-vars 'local_wsl_user=$user password_db=$dbPassword '  $path/provisioning.yaml

    wsl -d Ubuntu-20.04 -u $user -e docker exec -ti 
}