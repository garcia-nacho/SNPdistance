FROM staphb/snippy
LABEL maintainer="Nacho Garcia <iggl@fhi.no>"

RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

ARG USER=docker
ARG GROUP=docker
ARG UID
ARG GID

ENV USER=$USER
ENV GROUP=$GROUP
ENV UID=$UID
ENV GID=$GID
ENV HOME="/home/${USER}"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends iqtree gubbins
RUN cd /home/docker/ && wget http://www.microbesonline.org/fasttree/FastTree && mv FastTree /usr/bin/FastTree && chmod +x /usr/bin/FastTree

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'


RUN apt-get update \
        && apt-get install -y --no-install-recommends \
		littler \
        r-cran-littler \
		r-base \
		r-base-dev \
        r-base-core\
		r-recommended \
	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installBioc.r /usr/local/bin/installBioc.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installDeps.r /usr/local/bin/installDeps.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages(c('sp','seqinr', 'ggplot2', 'writexl', 'ape', 'reshape2', 'igraph', 'ggnetwork', 'ggrepel'))"

USER docker

RUN mkdir /home/docker/code
COPY snippy.runner.sh /home/docker/code
COPY SNPdistance.R /home/docker/code
COPY references /home/docker/references
ENV inputfolder="fastq"
ENV agent="GAS"
WORKDIR /Data
CMD ["sh", "-c", "/home/docker/code/snippy.runner.sh ${inputfolder} ${agent}"]