FROM mysql:5.7

RUN apt-get update -y  && apt-get -y install wget
RUN wget https://raw.githubusercontent.com/OscHer/Dscan/master/dscan.sh && chmod +x dscan.sh

