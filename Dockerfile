FROM httpd:2.4.58
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      file \
      git \
      libbz2-dev \
      libpcre3-dev \
      libssl-dev \
      libtool \
      unzip \
      wget \
      ;
WORKDIR /tmp/OpenAM
RUN git clone https://github.com/reneserral/OpenAM-Web-Agents.git /tmp/OpenAM
RUN ./prepare-apache.sh && \
    make apachezip && \
    unzip /tmp/OpenAM/build/Apache_v24_Linux_64bit_4.1.0.zip -d /usr/ && \
    rm /tmp/OpenAM/build/Apache_v24_Linux_64bit_4.1.0.zip
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["httpd-foreground"]
