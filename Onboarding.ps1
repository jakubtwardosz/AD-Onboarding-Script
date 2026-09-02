param(
    [Parameter(Mandatory=$true)]
    [string]$FirstName,

    [Parameter(Mandatory=$true)]
    [string]$LastName,

    [Parameter(Mandatory=$true)]
    [ValidateSet("IT", "Sales")]
    [string]$Department
)

# ===== Derive values from parameters =====
$Username = ($FirstName.Substring(0,1) + $LastName).ToLower()
$FullName = "$FirstName $LastName"
$OUPath = "OU=$Department,OU=Employees,DC=test,DC=local"
$DepartmentGroup = "Dept-$Department"

# ===== Check if the username already exists =====
if (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue) {
    Write-Host "ERROR: Username '$Username' already exists in AD!" -ForegroundColor Red
    exit
}

# ===== Generate temporary password =====
$TempPassword = "Start" + (Get-Random -Minimum 1000 -Maximum 9999) + "!"
$SecurePassword = ConvertTo-SecureString $TempPassword -AsPlainText -Force

# ===== Create the account =====
New-ADUser -Name $FullName `
    -GivenName $FirstName `
    -Surname $LastName `
    -SamAccountName $Username `
    -UserPrincipalName "$Username@test.local" `
    -Path $OUPath `
    -AccountPassword $SecurePassword `
    -ChangePasswordAtLogon $true `
    -Enabled $true

# ===== Add to department group =====
Add-ADGroupMember -Identity $DepartmentGroup -Members $Username

# ===== Summary =====
Write-Host "=== Account created successfully ===" -ForegroundColor Green
Write-Host "Username: $Username"
Write-Host "Temporary password: $TempPassword"
Write-Host "Department: $Department (OU: $OUPath)"
