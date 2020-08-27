FROM debian:testing-slim
ENV TZ America/Edmonton
ENV DEBIAN_FRONTEND noninteractive

# Install required packages for application using apt
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get upgrade -y && apt-get install -yq csh bash g++ gcc git cron \
 postfix sudo build-essential libssl-dev ca-certificates xvfb \
 default-jre-headless libfreetype6-dev libcurl4-openssl-dev curl wget \
 pandoc libgeos-dev libgdal-dev libproj-dev xz \
 r-base-core r-base-dev r-recommended r-cran-curl

# Install Commonly used R packages:
RUN echo "install.packages(c('data.table','ggplot2','stringr','lubridate','ProjectTemplate','curl','RCurl','h2o','gridExtra','ggrepel','readxl','geosphere','sp','cowplot','showtext','extrafont','knitr','rmarkdown','config','bit64','rgeos','rgdal','rworldmap','maptools','rworldxtra','nord'),repos='https://cran.rstudio.com')" | /usr/bin/R --no-save

# Install tinytex
RUN echo "install.packages(c('tinytex'),repos='https://cran.rstudio.com'); tinytex::install_tinytex()" | /usr/bin/R --no-save

# Set-up /app directory:
RUN mkdir /app
WORKDIR /app

# Set-up Xvfb for any headless web requirements
RUN echo "#!/bin/sh" > /app/Xvfb.start
RUN echo "/usr/bin/Xvfb :99 -ac -screen 0 1366x768x16 &" >> /app/Xvfb.start
RUN echo "export DISPLAY=99.0" >> /app/Xvfb.start
RUN chmod +x /app/Xvfb.start

# Final container intialization (see docker-compose.yml & run.sh for entrypoint & volumes)
CMD /bin/bash
