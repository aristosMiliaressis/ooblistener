ooblistener
==

**Features**
- fully automated setup
- 
- custom xsshunter
  - No GUI 
  - sqlite3 instead of postgres
  - apache mod_wsgi instead of nginx
  - discord notifications instead of email
  - BXSS probe served on all paths
  - exfiltrates everything that xsshunter does 
    - plus local storage & session storage
    - plus request path so that it can be used to transfer extra correlation info
- 
- interactsh dns server listening on port 53
- interactsh smtp server listening on port 25 & 587
- interactsh http & https servers listening on port 8 & 4
  - nonstandard port prevents spam traffic

</br>

**Prerequisites**
- a domain name
- an aws account
- a discord account

</br>

**Dependencies**
- jq
- openssh
- terraform
- ansible
- packer
- aws cli installed & configured
- certbot

</br>

**Setup Steps**
```bash
# 1) create discord server
# https://www.writebots.com/discord-bot-token/
./create_discord_server.sh $discord_bot_token

# 2) create the AMI
./create_ami.sh

# 3) deploy EC2
./deploy.sh $domain_name

# 4) setup glue records as dictated by the output of `deploy.sh` & wait for them to propagate
```

PS: steps one and two only have to run once, than you can use the `deploy.sh` & `teardown.sh` scripts to spin up and destroy the server whenever needed.

PS: the EC2 instance is a t2.micro and you get one of those for free with every aws account so this setup is free if you have no other EC2s in your account.

</br>

**To Do**
- figure out why interactsh-client breaks when interactsh-server is running on non standard port
- 
- add browser ssrf payload to xsshunterlite
- 
- bxss fetch referer page if it is same site
- register service worker for persistence?
-
- setup interactsh with smb support
