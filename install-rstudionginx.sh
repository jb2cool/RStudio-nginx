#!/bin/bash
# Install R/RStudio Server/nginx on Ubuntu

# Exit on error
set -e

# Setting up logging
LOG_FILE=$HOME/install-rstudionginx.log
touch "$LOG_FILE" || { echo "Cannot write to log file: $LOG_FILE"; exit 1; }
log() {
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}
log "Starting installation of R, Shiny Server, and nginx..."

# Add CRAN repository to APT sources
log "Adding CRAN repository..."
if [[ $(lsb_release -is) == "Ubuntu" ]]
then
    echo "Linux distribution is Ubuntu, proceeding to add R repository to APT"
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
else
    echo "Non-compatible Linux distribution, please seek further instructions on how to install R here https://cloud.r-project.org/bin/linux/"
    exit 1
fi

# Add CRAN repository key
log "Adding CRAN repository key..."
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# Update repository list and install R
log "Installing R..."
sudo apt-get update && sudo apt-get install r-base r-base-dev -y

# Install RStudio Server
log "Installing RStudio Server dependencies..."
sudo apt-get install gdebi-core -y
log "Downloading RStudio Server..."
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
log "Installing RStudio Server..."
sudo gdebi --non-interactive rstudio-latest.deb
rm rstudio-latest.deb

# Install nginx
log "Installing nginx..."
sudo apt-get install nginx -y

# Configure nginx with RStudio Server redirect
log "Downlkoading and installing pre-configured nginx config..."
sudo wget https://raw.githubusercontent.com/jb2cool/RStudio-nginx/main/default -O /etc/nginx/sites-enabled/default

# Restart services
log "Reloading nginx service..."
sudo systemctl reload nginx

# Clean up install script
log "Cleaning up install script..."
rm install-rstudionginx.sh

# Tell user everything works
log "End of install output to user..."
echo ""
echo ""
echo "###############################################################################"
echo "# RStudio Server is now available on http://127.0.0.1:8787 & http://127.0.0.1 #"
echo "###############################################################################"
echo ""
echo ""

# Cleaning up logging
echo "If you made it this far you probably don't need to keep the installation log file"
rm -i $LOG_FILE
