#!/bin/bash
# Main script for dscan project.
# More info: https://github.com/OscHer/Dscan
# Dependencies:
#  sslscan: Protocol scanner.

# Variables section
# Binaries
SSLSCAN_BIN=$(which sslscan) # Get sslscan full path


# Debug
DEBUG=1 # Set to 1 for verbose output. # TODO: intialize if '-v' when launch

# DB section
MYSQL_HOSTNAME='localhost' # Harcoded since it's a local connection
#MYSQL_USERNAME='' # Default container username. May change later
#MYSQL_PASSWORD='' # Default container username. May change later

# Parameters section
INVENTORY='fichero.txt'


# Functions
# Check dependencies # TODO
  # scan binary or exit with error
# Check args # TODO
  # inventory file exists or exit with error

# Get hosts. Input: existing file with ips. Output: Add SSL/TSL info of desired host of valid IPs to database
get_hosts()
{
  [[ $DEBUG -eq 1 ]] && echo ${FUNCNAME[0]}: # Debug mode
  FILE=$1 # Inventory. TODO: check syntax and avoid code injection.
  for HOST in $(cat $FILE); do
    scan_one_host $HOST
  done
}

# Scan one host. Input: valid ip address. Output: array with ssl/tls info
scan_one_host ()
{
  HOST=$1 # TODO: This seems redundant but later we can add resolving strategies if hostname provided 

  [[ $DEBUG -eq 1 ]] && echo ${FUNCNAME[0]}: $HOST # Debug mode
  sslscan --no-check-certificate --no-cipher-details --no-sigs --no-ciphersuites --no-fallback  --no-renegotiation --no-groups --no-heartbleed --no-compression $HOST:443 | grep abled

}
  # Add one register to mysql
# Main
# Check args or exit #TODO

get_hosts $INVENTORY   
