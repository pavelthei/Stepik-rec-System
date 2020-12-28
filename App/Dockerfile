FROM rocker/shiny-verse:latest

# copy the app to the image
# COPY *.Rproj /srv/shiny-server/
COPY *.R /srv/shiny-server/
# COPY data /srv/shiny-server/data

RUN R -e "install.packages(c('shiny', 'shinyWidgets', 'shinydashboard', 'markdown', 'knitr', 'kableExtra'), dependencies = TRUE)" && \
    R -e "install.packages(c('readr', 'dplyr', 'stringr', 'tidyverse', 'RPostgreSQL'), dependencies = TRUE)"

# select port
EXPOSE 3838

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

# run app
CMD ["/usr/bin/shiny-server.sh"]