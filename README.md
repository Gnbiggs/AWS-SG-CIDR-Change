# AWS-SG-CIDR-Change
Remove an old IP or Add a new IP to CIDR blocks

To use this script for Windows you will need the following:

Scoop - Install via PowerShell using the command:

ex "& {$(irm get.scoop.sh)} -RunAsAdmin"

Next use Scoop to install 'aws-vault' via PowerShell:

scoop install aws-vault

Next download and install git:

https://git-scm.com/download/win

After you will need to install and setup AWS CLI:

https://awscli.amazonaws.com/AWSCLIV2.msi

Once you have your credentials within your .aws config file, you can then run the script using git bash command line.
