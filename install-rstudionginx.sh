#!/bin/bash
# Install R/RStudio Server/nginx on Ubuntu

# Add repository to APT sources
if [[ $(lsb_release -is) == "Ubuntu" ]]
then
    echo "Linux distribution is Ubuntu, proceeding to add R repository to APT"
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
else
    echo "Non-compatible Linux distribution, please seek further instructions on how to install R here https://cloud.r-project.org/bin/linux/"
    exit 1
fi

# Add repo key
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# Update repository list and install R
sudo apt-get update && sudo apt-get install r-base r-base-dev -y

# Install RStudio Server
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

# Install nginx
sudo apt-get install nginx -y

# Configure nginx with RStudio Server redirect
sudo wget https://raw.githubusercontent.com/jb2cool/RStudio-nginx/main/default -O /etc/nginx/sites-enabled/default

# Restart services
sudo systemctl reload nginx

# Clean up install script
rm install-rstudionginx.sh

# Tell user everything works
echo ""
echo ""
echo "###############################################################################"
echo "# RStudio Server is now available on http://127.0.0.1:8787 & http://127.0.0.1 #"
echo "###############################################################################"
echo ""
echo ""
