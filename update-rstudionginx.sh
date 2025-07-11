#!/bin/bash
# Update R/RStudio Server/nginx on Ubuntu

# Exit on error
set -e

# Setting up logging
LOG_FILE=$HOME/update-rstudionginx.log
touch "$LOG_FILE" || { echo "Cannot write to log file: $LOG_FILE"; exit 1; }
log() {
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}
log "Starting update of R, RStudio Server, and nginx..."

# Update repository list and install R
log "Updating R..."
sudo apt-get update && sudo apt-get install r-base r-base-dev -y

# Update RStudio Server
log "Downloading RStudio Server..."
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
log "Updating RStudio Server..."
sudo gdebi --non-interactive rstudio-latest.deb
rm rstudio-latest.deb

# Update nginx
log "Updating nginx..."
sudo apt-get install nginx -y

# Cleaning up logging
echo "If you made it this far you probably don't need to keep the update log file"
rm -i $LOG_FILE
