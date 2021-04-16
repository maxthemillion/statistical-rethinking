LABEL version="0.1"
LABEL description="This image encapsulates an environment to run the rethinking package for \
    the statistics course statistical rethinking on a simple linux image"

FROM r-base 
RUN apt-get update && apt install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev 

ARG DOWNLOAD_STATIC_LIBV8=1

ADD config /src/config
RUN Rscript /src/config/config.R

RUN R -e "install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies=TRUE)"

RUN R -e "install.packages('devtools')"
RUN R -e 'install.packages(c("coda","mvtnorm","devtools","loo","dagitty"))'
RUN R -e 'devtools::install_github("rmcelreath/rethinking")'

