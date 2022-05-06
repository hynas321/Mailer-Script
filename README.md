# Mailer-Script
## Description
Bash script that allows sending an e-mail to a recipient or multiple recipients.
## Configuration
1. Type in terminal `sudo apt install mailutils`
2. Set `postfix` as `internet site` during installation
3. Type in terminal `sudo nano /etc/postfix/main.cf`
4. Set `inet_interfaces` to `loopback-only` in the main.cf file
5. Type in terminal `sudo systemctl restart postfix`
## Sending an email
To send an e-mail there should be an e-mail file created (text file). Optionally file containing different email addresses can be included.
## Email file structure
- recipient definiton
- subject
- title
- content

Recipient definition can be either a single email address or a name of the file with email addresses in the current directory.

## Email address structure
- address 1
- address 2
- address 3
- etc...
