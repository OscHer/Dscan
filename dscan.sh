#!/bin/bash
# Main script for dscan project.
# More info: https://github.com/OscHer/Dscan
# Dependencies:
#  sslscan: Protocol scanner.

# Variables section
# Binaries
SSLSCAN_BIN=$(which sslscan) # Get sslscan full path. #IMPROV: This could be abstracted to use any other scan utility since detection and parsing are fully parametrizable.
SSLSCAN_OPTIONS="--no-check-certificate --no-cipher-details --no-sigs --no-ciphersuites --no-fallback  --no-renegotiation --no-groups --no-heartbleed --no-compression"
# Inventory file
INVENTORY='fichero.txt' # Harcoded for requirements of the test. #IMPROV Should be just a default and overwritten with params '-f' or the like
# Debug
DEBUG=1 # Set to 1 for verbose output. # IMPROV: intialize if '-v' when launch
# DB section
MYSQL_HOSTNAME='localhost' # Harcoded since it's a local connection
#MYSQL_USERNAME='' # Default container username. May change later
#MYSQL_PASSWORD='' # Default container username. May change later

# Check ip. True if given a correct IP. False if not.
# Developer comment: this may seem lazy, but since ip route exists in most linux distros this seems a better approach for a smaller Docker image and avoids stupidly complex regexp. Cons: user who launches the script may have not permissions to execute this command.
check_ip()
{
  IP=$1 # IMPROV: Avoid injection with some pre-cleaning.

  ip route get $IP > /dev/null 2>&1 ; echo $?
}

# Scan one host. Input: valid ip address. Output: array with ssl/tls info
scan_one_host ()
{
  HOST=$1 # TODO: This seems redundant but later we can add resolving strategies if hostname provided 

  [[ $DEBUG -eq 1 ]] && echo ${FUNCNAME[0]}: $HOST # Debug mode
  $SSLSCAN_BIN $SSLSCAN_OPTIONS $HOST:80 | grep abled

}

# Main function: highest level of abstraction of this algorithm.
# This functions calls all other involved after making some tests
main()
{

  [[ -r $INVENTORY ]] || (echo "ERROR: Cannot read '$INVENTORY'." && exit 1) # Check if inventory file is readable
  [[ -x $SSLSCAN_BIN ]] || (echo "ERROR: Cannot execute '$SSLSCAN_BIN'. Check for the binary file or execution permissions." && exit 2) # Check if sslscan is available for execution

  # Loop over inventory file
  for SERVER in $(cat $INVENTORY); do
    # Check for valid IP or jump 
      if [[ $(check_ip $SERVER) -eq 0 ]] 
        then
          echo "Scanning $SERVER"      # Scan host port 443
        # If port reachable 
          # Insert to ddbb
      # Scan host port 8443
        # If port reachable
          # Insert to ddbb   
      else # Not valid IP: skip
        echo "$SERVER is not a valid IP address" 
      fi
  done
}


main
