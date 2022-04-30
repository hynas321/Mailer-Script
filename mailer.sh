#!/bin/sh

function first_message {
	clear
	echo "In order to send an email please enter -s"
	echo "Program information is available under the parameter -h"
	echo "The current version is available under the parameter -v"
	echo "Parametrs -h and -v terminate the program"
}

function check_file {
	arg=$1
	
	if ! [ -f "$PWD/$arg" ]; then
		echo "ERROR: The file called '$arg' does not exist in the current directory."
		exit 0
	fi
}

function check_address {
	if [[ "$address" == *"@" ]]; then
		recipient=${address%@}
		clear
		echo "Recipient '$recipient' has been set."
		basic_sending

	elif [[ "$address" == *"@"* ]]; then
		recipient=$address
		clear
		echo "Address '$address' has been set."
		basic_sending
		
	else
		check_file "$address"
		extended_sending
	fi
}

function check_char { 	
	if [ "$char" = "n" ]; then
		clear
		echo "The mail has not been sent."
		exit 0
		
	elif ! [ "$char" = "n" -o "$char" = "y" ]; then
		clear
		echo "ERROR: Wrong parameter."
		exit 0
	fi
}

function print_content {
	subject=$(awk 'NR==2' $file_name)
	title_en=$(awk 'NR==3' $file_name)
	
	echo ""
	echo "Subject: $subject"
	echo "Title to enlarge: $title_en"
	echo "Content:"
	xargs < $file_name | head -n +4 | tail -$(($(wc -l < $file_name) - 3)) $file_name
	echo ""
	echo "Would you like to send the email? [y/n]"
}

function files_function {
	clear
	printf "Step 1/2 Please enter name of the file with email structure:\n"
	
	read file_name
	check_file "$file_name"
	tmp=$(awk 'NR==3' $file_name)
	
	if [ ${#tmp} -gt 10 ]; then
		echo "ERROR: The third line in the file $file_name exceeded its limit of 10 characters"
		exit 0
	fi
		
	printf "Step 2/2 Please enter email address with '@', localhost name ending with '@' or name of the file with email addresses:\n"
	
	read address
	check_address "$address"
}

function basic_sending {
	print_content
	read char
	check_char
	
	printf "$(banner $title_en)\n$(xargs < $file_name | head -n +4 | tail -$(($(wc -l < $file_name) - 3)) $file_name)" | mail -s "$subject" $address
	
	clear
	echo "Email has been successfully sent"
}

function extended_sending {
	clear
	
	echo "The mail will be sent to following mail addresses:"
	cat $address | while read recipient
	do 
		echo $recipient
	done

	print_content
	read char
	check_char
	
	cat $address | while read recipient
	do 
		address=$recipient
		
		printf "$(banner $title_en)\n$(xargs < $file_name | head -n +4 | tail -$(($(wc -l < $file_name) - 3)) $file_name)" | mail -s "$subject" $address
	done
	
	clear
	echo "Email has been successfully sent"
}

function help_message {
	clear
	echo "CONFIGURATION:"
	echo "sudo apt install mailutils"
	echo "(Postfix set as 'internet site')"
	echo "sudo nano /etc/postfix/main.cf"
	echo "inet_interfaces = loopback-only"
	echo "sudo systemctl restart postfix"
	echo ""
	echo "To send an email there should be an email file."
	echo "Optionally file containing different email addresses can be included."
	echo "files_function must be in the same folder as the script file."
	
	printf "\nEmail file structure:\n"
	printf "<recipient definition>\n<subject>\n<title>\n<content>\n"
	printf "\nRecipient definition can be either a single email address or a name of the file with email addresses in the current directory.\n"
	
	printf "\nEmail address file structure:\n"
	printf "<address 1>\n<address 2>\n<address 3>\netc...\n"
	exit 0
}

function version_message {
	clear
	echo "Mailer Version 1.0.0"
	exit 0
}

function main {

first_message
read param

if [ "$param" = "-s" ]; then
	files_function
	
elif [ "$param" = "-h" ]; then
	help_message
	
elif [ "$param" = "-v" ]; then
	version_message

else 
	echo "ERROR: Wrong parameter"; exit 0
fi

}

main
