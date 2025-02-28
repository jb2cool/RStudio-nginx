#!/bin/bash
# Update R/RStudio Server/nginx on Ubuntu

# Update repository list and install R
sudo apt-get update && sudo apt-get install r-base r-base-dev -y

# Update RStudio Server
sudo apt-get install gdebi-core -y
if [[ $(lsb_release -rs) == "20.04" ]]
then
    wget https://www.rstudio.org/download/latest/stable/server/focal/rstudio-server-latest-amd64.deb  -O rstudio-latest.deb
elif [[ $(lsb_release -rs) == "22.04" ]]
then
    wget https://www.rstudio.org/download/latest/stable/server/jammy/rstudio-server-latest-amd64.deb  -O rstudio-latest.deb
elif [[ $(lsb_release -rs) == "24.04" ]]
then
    wget https://www.rstudio.org/download/latest/stable/server/jammy/rstudio-server-latest-amd64.deb  -O rstudio-latest.deb
else
    echo "Non-compatible version"
fi
sudo gdebi --non-interactive rstudio-latest.deb
rm rstudio-latest.deb

# Update nginx
sudo apt-get install nginx -y
