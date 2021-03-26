# Dscan
Dscan is a dockerized port scanner (no pun intended) whose sole purpose is to find out SSL/TlS protocol version given a list of hosts.

	

## Install
### Dependencies
* Docker: [All distros](https://docs.docker.com/engine/install/)
  * Fedora >=33:
  ```bash    
    $ sudo dnf -y install dnf-plugins-core
    $ sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    $ sudo dnf install docker-ce docker-ce-cli containerd.io
   ```  
 
## Appendix
TODO
### Disclaimer
TODO

### History
This software vas developed under Fedora 33.

I decided to use bash script instead of python despite the complexity of the final code since it has fewer dependencies on a linux docker than the python approach. Not that I have explore the python solution much, but my spider sense goes crazy when I think about a dockerfile with mysql, pip, mysql python libraries, python sslscan and others.
