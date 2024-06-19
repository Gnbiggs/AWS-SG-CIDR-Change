 #!/bin/bash

 #Ash for the profile
 echo " "
 echo "Enter your AWS profile:"
 read PROFILE
 echo " "

# Ask for the certificate name
echo "Enter the Certificate Name:"
read CERT
echo " "

echo "--------------------"
aws-vault exec $PROFILE -- aws rds describe-db-instances --query "DBInstances[?CACertificateIdentifier=='$CERT'].[DBInstanceIdentifier,CACertificateIdentifier]"
echo "--------------------"


  

