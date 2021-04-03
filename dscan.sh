#!/bin/bash
# Main script for dscan project.
# More info: https://github.com/OscHer/Dscan
# Dependencies:
#  sslscan: Protocol scanner.

# Variables section
declare -A scanResultArray # Iterator array to get protocol=state as pair=value as a result of scanned HOST:PORT
PORT_LIST=(443 8443)

# Binaries
SSLSCAN_BIN=$(which sslscan) # Get sslscan full path. #IMPROV: This could be abstracted to use any other scan utility since detection and parsing are fully parametrizable.
SSLSCAN_OPTIONS="--no-check-certificate --no-cipher-details --no-sigs --no-ciphersuites --no-fallback  --no-renegotiation --no-groups --no-heartbleed --no-compression"
MYSQL_BIN=$(which mysql) # Get mysql client full path.

# Inventory file
INVENTORY='fichero.txt' # Harcoded for requirements of the test. #IMPROV Should be just a default and overwritten with params '-f' or the like

# Debug
DEBUG=2 # Set to integer value for verbose output. # IMPROV: intialize if '-v' when launching and count 'v's for verbosity levels. In python this is trivial, but since I decided to go with (I WAS TOTALLY WRONG!) now I have to stick with it.

# DB section
MYSQL_HOSTNAME='127.0.0.1' # Harcoded since it's a local connection
MYSQL_USER="root" # TODO: parametrize and obfuscate
MYSQL_PASSWORD="rootpass" # TODO: parametrize and obfuscate
MYSQL_DB="ssldb"
MYSQL_TABLE="ips"

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
  HOST=$1 # IMPROV: This seems redundant but later we can add resolving strategies if hostname provided 
  PORT=$2 # Port we'll scan for SSL negotiation

  [[ $DEBUG -eq 1 ]] && echo ${FUNCNAME[0]}: $HOST:$PORT # Debug mode

  # Scan host:port and format output into a key-value array
  while IFS='\n' read -r line; do
    CLAVE="$(echo $line | cut -d' ' -f1 | tr -d '.')"
    VALOR="$(echo $line | cut -d' ' -f2)" # Get original value of scanned port
    [[ "$VALOR" == "enabled" ]] && VALOR=1 || VALOR=0 # Translate returned value into bool value

    #TODO: insert avoid sql-injection methods here

    scanResultArray[$CLAVE]=$VALOR # Assign key-value already parsed      
    [[ $DEBUG -eq 1 ]] && echo $HOST'--'$CLAVE'---'$VALOR'--' # Debug purpose
  done < <($SSLSCAN_BIN $SSLSCAN_OPTIONS $HOST:$PORT 2>/dev/null | grep abled | tr -s " ")

  [[ $DEBUG -eq 1 ]] && for CLAVE in "${!scanResultArray[@]}"; do echo "$CLAVE"'='${scanResultArray[$CLAVE]}; done
}

# Main function: highest level of abstraction of this algorithm.
# This functions calls all other involved after making some tests
main()
{

  [[ -r $INVENTORY ]] || (echo "ERROR: Cannot read '$INVENTORY'." && exit 1) # Check if inventory file is readable
  [[ -x $SSLSCAN_BIN ]] || (echo "ERROR: Cannot execute '$SSLSCAN_BIN'. Check for the binary file or execution permissions." && exit 2) # Check if sslscan is available for execution

  # Loop over inventory file
  for SERVER in $(cat $INVENTORY); do
    if [[ $(check_ip $SERVER) -eq 0 ]]; then # If its a valid IP we scan it
      for SCANNEDPORT in ${PORT_LIST[@]}; do

        PORTSCANNED=$SCANNEDPORT
        echo -n "Scanning $SERVER:$PORTSCANNED: "
        scanResultArray=()
        scan_one_host $SERVER $PORTSCANNED

        # TODO: Get this into a function which receives the array. Not stylish but the clock is ticking.
        # If we reached desired ports, add register to ddbb
        if [[ ${scanResultArray[@]} ]]; then # Scan host port 443 # IMPROV: provide an array of ports to iterate it instead of hardcoding
          [[ $DEBUG -eq 2 ]] && (echo ; for CLAVE in "${!scanResultArray[@]}"; do echo "$CLAVE"'='${scanResultArray[$CLAVE]}; done)
           
          # Insert scan result into mysql # TODO: insert connectivity checks here
          # DEVELOPER NOTE: I know database fields are  not named as asked, but I'll cross that bridge after a MVP release
          $MYSQL_BIN -h $MYSQL_HOSTNAME -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e "insert into \`$MYSQL_TABLE\` (\`ip\`,\`puerto\`,\`SSLv2\`,\`SSLv3\`,\`TLSv10\`,\`TLSv11\`,\`TLSv12\`,\`TLSv13\`) VALUES ('$SERVER','$PORTSCANNED', '${scanResultArray[SSLv2]}','${scanResultArray[SSLv3]}','${scanResultArray[TLSv10]}','${scanResultArray[TLSv11]}','${scanResultArray[TLSv12]}','${scanResultArray[TLSv13]}')" || echo "Unable to connect to DB" #2> /dev/null
        else 
          echo "Unreachable. Skipping"
        fi
      done

    else # Not valid IP: skip
      echo "$SERVER is not a valid IP address" 
    fi
  done
}


main
