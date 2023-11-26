ooblistener
==

**Prerequisites**
- a domain name
- an aws account
- a discord account & bot token

**Dependencies**
- jq
- openssh
- terraform
- ansible
- aws cli installed & configured

**Steps**
```bash
# 1) create discord server
# https://www.writebots.com/discord-bot-token/
./create_discord_server.sh $discord_bot_token

# 2) create the AMI
./create_ami.sh $domain_name

# 3) deploy EC2
./deploy.sh

# 4) setup glue records as dictated by the output of `deploy.sh` & wait for them to propagate
```

**To Do**
- grab certificate from server once it's issued
- add option to provide existing certificate
