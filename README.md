# RStudio-nginx
## Wrapper script for installing R and RStudio Server behind an nginx reverse proxy

This script assumes you have a pretty clean Ubuntu 20.04, 22.04 or 24.04 LTS install.

We will:
* Add the official R 4.x respository
* Add the APT keys for this repository
* Install R (r-base and r-base-dev)
* Download and install RStudio Server
* Install and configure nginx (more on this below)


Once complete you'll have:
* RStudio Server being served on port 8787 and also as a redirect on port 80 (http://127.0.0.1:8787 & http://127.0.0.1)

## Instructions
### Installation
Simply download and run the install-rstudionginx.sh script. This should be as simple as:
```
wget https://raw.githubusercontent.com/jb2cool/RStudio-nginx/main/install-rstudionginx.sh
bash install-rstudionginx.sh
```

### Updating
Occasionally you'll want to update to newer versions of R, RStudio Server and nginx. R and nginx would likely have already been updated by your regular update schedule on your machine but since RStudio Server was downloaded and installed manually this needs a more manual approach to update it. Use the update script to update to the latest versions of all programs. Simply download and run the update-rstudionginx.sh script. This should be as simple as:
```
wget https://raw.githubusercontent.com/jb2cool/RStudio-nginx/main/update-rstudionginx.sh
bash update-rstudionginx.sh
```

## Cautions
* The install script will overwrite your /etc/nginx/sites-enabled/default file, if you have already made customisations to this file ensure you have a backup.
* Don't run the update script from within RStudio-Server itself, if you do you'll end up pulling the rug from under your own feet, do this from a separate session.
