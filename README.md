ooblistener ![build: tag](https://github.com/aristosMiliaressis/ooblistener/actions/workflows/build.yml/badge.svg)
==

</br>

**Features**
- fully automated setup including vps and discord server
  - interactsh is hosted on ports 8:http, 4:https, 25:smtp, 53:dns, 389:ldap, 445:smb
  - notifications are sent to discord.
- payload server
  - supports custom file serving.
  - if no file in the web root matches the path a blind xss probe is returned.
    - the probe exfiltrate everything that xsshunter does + localStorage.
    - all exfiltrated data is stored in an SQLite db.
    - notifications are sent to discord.
  - generates a cert for the root domain and a wildcard for subdomains.
  - no http to https redirect (allowing for shorter curl based command injection payloads)
  - CORS reflection of origin, method & headers

</br>

**Prerequisites**
- a domain name
- a contabo account
- a discord account

</br>

**Setup Steps**
```bash
# 1) create discord server
# https://www.writebots.com/discord-bot-token/
./create_discord_server.sh $discord_bot_token

# 2) deploy VPS
./deploy.sh $domain_name

# 3) setup glue records as dictated by the output of `deploy.sh` & wait for them to propagate
```
