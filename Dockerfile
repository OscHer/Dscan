FROM mysql:5.7
RUN apt-get update -y  && apt-get -y install curl
ARG owner
ENV OWNER ${owner}
RUN mkdir -p /dscan_files
RUN curl https://raw.githubusercontent.com/OscHer/Dscan/master/dscan.sh > /dscan_files/dscan.sh
RUN chmod +x /dscan_files/dscan.sh && /dscan_files/dscan.sh


