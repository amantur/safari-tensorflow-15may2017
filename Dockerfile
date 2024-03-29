FROM python:3.9
MAINTAINER Aman Tur "https://amantur.com"

# Usual update / upgrade
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends apt-utils \
 && apt-get install -y jq \
 && apt-get install git

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker

# Working enviroment
ENV APPDIR /home/docker
RUN install -o docker -d ${APPDIR}

WORKDIR ${APPDIR}

#RUN git clone https://github.com/amantur/safari-tensorflow-15MAY2017.git

COPY requirements.txt requirements.txt

RUN pip3 install --user --upgrade pip

RUN ["/bin/bash","-c","echo `pwd` && pip3 install --user --upgrade tensorflow"]

RUN ["/bin/bash","-c","echo `pwd` && pip3 install --user --upgrade -r ~/requirements.txt"]

ENV PATH=/home/docker/.local/bin:${PATH}

RUN python3 -c 'import tensorflow, numpy, jupyter, matplotlib'

EXPOSE 8888

# Entrypoint
CMD ["/bin/bash", "-c", "cd ${APPDIR} && jupyter notebook --ip=0.0.0.0"]
