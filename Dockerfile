FROM mysql:5.7
RUN apt-get update -y  && apt-get -y install curl
COPY ./fichero.txt /dscan_files/fichero.txt
RUN mkdir -p /dscan_files && curl https://raw.githubusercontent.com/OscHer/Dscan/master/dscan.sh > /dscan_files/dscan.sh && chmod +x /dscan_files/dscan.sh 
RUN /dscan_files/dscan.sh

