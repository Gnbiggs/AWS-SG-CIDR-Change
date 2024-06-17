#!/bin/bash

# Ask for the profile
echo "Enter your AWS profile:"
read PROFILE

# Specify your CIDR block
echo "Enter the CIDR block you want to search for:"
read CIDR

if [ -z "$CIDR" ]
	then 
		echo "No CIDR Block has been input, Moving to next section..."
	
else

echo "Enter yes to skip searching all security groups for the old CIDR block or enter no to search for old CIDR range is all Security Groups: (Enter: yes/no)"
read SKIP_SG

	if [ "$SKIP_SG" == "yes" ]
	then 

	echo "Skipping Security Group search..."

	else

# Create a new file on the desktop
OUTPUT_FILE=~/Desktop/security_group_info.txt
echo "Security Group Information:" > $OUTPUT_FILE

# List all security groups and their names
SECURITY_GROUPS=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --query "SecurityGroups[*].[GroupId,GroupName]" --output text)

# Check each security group for the CIDR block
while read -r SECURITY_GROUP SECURITY_GROUP_NAME; do
    RESULT=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --group-ids $SECURITY_GROUP --query "SecurityGroups[*].IpPermissions[*].IpRanges[*].CidrIp" --output text 2>/dev/null)

	if [[ $RESULT == *"$CIDR"* ]]; then
        # Get the port number of the CIDR block
        PORT=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --group-ids $SECURITY_GROUP --query "SecurityGroups[*].IpPermissions[?IpRanges[?CidrIp=='$CIDR']].FromPort" --output text 2>/dev/null)

        # Print the security group information
		echo "Searching for Old CIDR blocks..."
		echo "-------------------------------"
        echo "Security Group ID: $SECURITY_GROUP"
        echo "Security Group Name: $SECURITY_GROUP_NAME"
		echo "CIDR: $CIDR"
        echo "Port: $PORT"
		echo "-------------------------------"
		
		# Store the security group information
		echo "Out putting Security Group information to document which will be located on your Desktop..."
		echo "-------------------------------"
        echo "Security Group ID: $SECURITY_GROUP" >> $OUTPUT_FILE
        echo "Security Group Name: $SECURITY_GROUP_NAME" >> $OUTPUT_FILE
        echo "CIDR: $CIDR" >> $OUTPUT_FILE
        echo "Port: $PORT" >> $OUTPUT_FILE
        echo "-------------------------------" >> $OUTPUT_FILE
		echo "Retrieving next Security Group Info..."
		
	fi
	done <<< "$SECURITY_GROUPS"

fi
	# Ask if the user wants to remove the CIDR block from SSH
    echo "Do you want to remove the CIDR block? (yes/no)"
    read ANSWER

while true; do

	# Ask if the user wants to remove the CIDR block from SSH
    echo "Do you want to remove the CIDR block? (yes/no)"
    read ANSWER
	
	if [[ $ANSWER == "yes" ]]; then

		# Ask for the security group ID
		echo "Enter the security group ID:"
		read SECURITY_GROUP_ID
		
		# Ask for port number
		echo "Enter port number you want to remove:"
		read PORTNO
		
        # Remove the CIDR block from the security group
		echo "Attempting to remove CIDR block..."
        REMOVAL=$(aws-vault exec $PROFILE -- aws ec2 revoke-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port $PORTNO --cidr $CIDR)
		echo "Successfully removed: $REMOVAL"
	fi
	
	# Ask if the user wants to continue
	echo "Do you want to remove another CIDR block? (yes/no)"
    read ANSWER
	
	 if [[ $ANSWER == "no" ]]; then
        break
    fi
done

fi

# Specify your CIDR block
echo "Enter the NEW_CIDR block you want to search for:"
read NEW_CIDR

if [ -z "$NEW_CIDR" ]
	then 
		echo "No CIDR Block has been input, Moving to next section..."
	
else

echo "Enter yes to skip searching all security groups for the new CIDR block or enter no to search for new CIDR range is all Security Groups: (Enter: yes/no)"
read SKIP_SG

	if [ "$SKIP_SG" == "yes" ]
	then 

	echo "Skipping Security Group search..."

	else
# Create a new file on the desktop
OUTPUT_FILE=~/Desktop/new_security_group_info.txt
echo "Security Group Information:" > $OUTPUT_FILE

# List all security groups and their names
SECURITY_GROUPS=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --query "SecurityGroups[*].[GroupId,GroupName]" --output text)

# Check each security group for the New CIDR block
while read -r SECURITY_GROUP SECURITY_GROUP_NAME; do

	RESULT=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --group-ids $SECURITY_GROUP --query "SecurityGroups[*].IpPermissions[?FromPort==`$PORT`].IpRanges[*].CidrIp" --output text 2>/dev/null)
    
	if [[ $RESULT == *"$NEW_CIDR"* ]]; then
        # Get the port number of the New CIDR block
        PORT=$(aws-vault exec $PROFILE -- aws ec2 describe-security-groups --group-ids $SECURITY_GROUP --query "SecurityGroups[*].IpPermissions[?IpRanges[?CidrIp=='$New_CIDR']].FromPort" --output text 2>/dev/null)

        # Print the security group information
		echo "Searching for New CIDR blocks..."
		echo "-------------------------------"
        echo "Security Group ID: $SECURITY_GROUP"
        echo "Security Group Name: $SECURITY_GROUP_NAME"
		echo "New CIDR: $New_CIDR"
        echo "Port: $PORT"
		echo "-------------------------------"
		
		# Store the security group information
		echo "Out putting Security Group information to document which will be located on your Desktop..."
		echo "-------------------------------"
        echo "Security Group ID: $SECURITY_GROUP" >> $OUTPUT_FILE
        echo "Security Group Name: $SECURITY_GROUP_NAME" >> $OUTPUT_FILE
        echo "New CIDR: $New_CIDR" >> $OUTPUT_FILE
        echo "Port: $PORT" >> $OUTPUT_FILE
        echo "-------------------------------" >> $OUTPUT_FILE
		echo "Retrieving next Security Group Info..."
		
    fi
done <<< "$SECURITY_GROUPS"

fi

while true; do

	# Ask if the user wants to add the CIDR block from SSH
    echo "Do you want to add the CIDR block? (yes/no)"
    read ANSWER
	
	if [[ $ANSWER == "yes" ]]; then

		# Ask for the security group ID
		echo "Enter the security group ID:"
		read SECURITY_GROUP_ID
		
		# Ask for port number
		echo "Enter port number you want to add:"
		read PORTNO
		
		# Add the CIDR block to the security group
		echo "Attempting to add New CIDR block..."
		ADD=$(aws-vault exec $PROFILE -- aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port $PORTNO --cidr $NEW_CIDR)
		echo "Successfully added: $ADD"
	fi
	
	# Ask if the user wants to continue
	echo "Do you want to addd another New CIDR block? (yes/no)"
    read ANSWER
	
	 if [[ $ANSWER == "no" ]]; then
        break
    fi
done

fi