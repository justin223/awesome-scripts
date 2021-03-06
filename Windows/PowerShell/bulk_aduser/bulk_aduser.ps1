# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-Csv C:\Users\Administrator\Desktop\sample.csv

#Loop through each row containing user details in the CSV file 
foreach ($user in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$username 	= $user.AccountSid
	$password 	= $user.Password
    $displayName = $user.Name
    $userPrincipleName = $user.UPN
	$OU 		= $user.OU
    $email      = $user.Mail
    $homeDrive = $user.homeDrive
    $homeDirectory = $user.homeDirectory


	#Check to see if the user already exists in AD
	if (Get-ADUser -F { SamAccountName -eq $username })
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $username already exists in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName $userPrincipleName `
            -Name $displayName `
            -Enabled $True `
            -DisplayName $displayName `
            -Path $OU `
            -EmailAddress $email `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) -ChangePasswordAtLogon $True `
            -HomeDrive $homeDrive `
            -HomeDirectory $homeDirectory

        New-Item -ItemType Directory -Path "$homeDirectory"
        ## icacls "$homeDirectory" /grant "$($username):(OI)(CI)F" /T 
        $acl = Get-Acl "$homeDirectory"
        $args = "$username", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        $aclrule = New-Object System.Security.AccessControl.FileSystemAccessRule $args
        $acl.SetAccessRule($aclrule)
        Set-Acl "$homeDirectory" $acl

	}
}
