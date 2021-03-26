# Dscan
Dscan is a dockerized port scanner (no pun intended) whose sole purpose is to find out SSL/TlS protocol version given a list of hosts.

	

## Install
### Dependencies
* Host
  * docker-ce
  * docker-ce-cli
  * containerd.io
 
## Appendix
TODO
### Disclaimer
TODO

### History
This software vas developed under Fedora 33.

I decided to use bash script instead of python despite the complexity of the final code since it has fewer dependencies on a linux docker than the python approach. Not that I have explore the python solution much, but my spider sense goes crazy when I think about a dockerfile with mysql, pip, mysql python libraries, python sslscan and others.
