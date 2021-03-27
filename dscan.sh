#!/bin/bash
# Main script for dscan project.
# More info: https://github.com/OscHer/Dscan

# Variables section
# DB section


MYSQL_HOSTNAME='localhost' # Harcoded since it's a local connection
#MYSQL_USERNAME='' # Default container username. May change later
#MYSQL_PASSWORD='' # Default container username. May change later

# Parameters section
INVENTORY='fichero.txt'


# Functions
# Check args # TODO

# Get hosts. Input: existing file with ips. Output: Add SSL/TSL info of desired host of valid IPs to database
get_hosts()
{
  FILE=$1 # Inventory. TODO: check syntax and avoid code injection.
  for HOST in $(cat $FILE); do
    echo $HOST
  done
}

# Scan one host. Input: valid ip address. Output: array with ssl/tls info
scan_one_host ()
{
  echo $1
}
  # Add one register to mysql
# Main
# Check args or exit #TODO

get_hosts $INVENTORY   
