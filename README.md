# AD-Onboarding-Script
A PowerShell script that automates new employee onboarding in Active Directory —
creates the user account in the correct Organizational Unit, generates a temporary
password, and adds the user to the appropriate department security group.

## What it does
1. Takes employee details as parameters (first name, last name, department)
2. Validates the department against an allowed list
3. Check whether the username already exist, to avoid collisions
4. Generates a random temporary password and forces a password change at first logon
5. Creates the AD user account in the correct department OU
6. Add the user to the corresponding department security group
7. Prints a summary

## Prerequistes
- Windows Server with the Active Directory module for PowerShell (`RSAT-AD-PowerShell` / `ActiveDirectory` module)
- An existing OU structure:
```
  OU=Employees
    OU=IT
    OU=Sales
```
- Security groups matching each department: `Dept-IT`, `Dept-Sales`
- Run as user with permission to create AD accounts

## Usage
```powershell
.\Onboarding.ps1 -FirstName "Anna" -LastName "Nowak" -Department "Sales"
```
Allowed values for `-Department`: `IT`, `Sales`

## Disclaimer

Built and tested in a local Hyper-V lab environment (Windows Server 2025 + `test.local` domain) as a learning project
