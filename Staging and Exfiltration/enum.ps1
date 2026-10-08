# This script is for educational purposes only.
# It seeks and documents various pieces of information about a Windows host, then saves it to multiple files
# in a directory it creates.
# User discretion is greatly advised.

# Create the directory to save files to.
mkdir \Temp\enum 2>&1

# Show the current user, and their groups and privileges.
whoami /all > C:\Temp\enum\users.txt 2>&1

# Show all running processes.
tasklist > C:\Temp\enum\processes.txt 2>&1

# Show open network sockets and active connections.
netstat -ano > C:\Temp\enum\connections.txt 2>&1

# Show running services.
sc query > C:\Temp\enum\services.txt 2>&1

# Show all local user accounts.
net user > C:\Temp\enum\users.txt 2>&1

# Show all local groups.
net localgroup > C:\Temp\enum\groups.txt 2>&1

# List users in the local Administrators group.
net localgroup Administrators > C:\Temp\enum\admins.txt 2>&1

# Show network configurations.
ipconfig /all > C:\Temp\enum\network_configuration.txt 2>&1

# Show firewall policies.
netsh advfirewall show allprofiles > C:\Temp\enum\firewall.txt 2>&1

# Show the ARP table.
arp -a > C:\Temp\enum\arp.txt 2>&1

# List SMB sessions.
net session > C:\Temp\enum\smb.txt 2>&1

# Show various system information.
systeminfo > C:\Temp\enum\system.txt 2>&1
