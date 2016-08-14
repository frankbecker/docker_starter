FROM phusion/baseimage:0.9.9

ENV HOME /root

# ### Generate SSH key for production usage
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh



# === Some Environment Variables
ENV    DEBIAN_FRONTEND noninteractive
#      xterm is vor better terminal interaction, this is set to 'dumb' by default
ENV    TERM xterm

## Proxy seetings if necessary
##ENV    http_proxy http.proxy.domain.com:8000 
##ENV    https_proxy http.proxy.domain.com:8000 

# === MySQL Installation
RUN apt-get update
RUN echo "mysql-server mysql-server/root_password password password" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections
RUN apt-get install -y mysql-server

ADD build/my.cnf    /etc/mysql/my.cnf


RUN mkdir -p        /etc/service/mysql
ADD build/mysql.sh  /etc/service/mysql/run
RUN chmod +x        /etc/service/mysql/run

RUN mkdir -p        /var/lib/mysql/
RUN chmod -R 755    /var/lib/mysql/

## I removed this line, but for dumping database uncomment this line and check setup.sh for more dumping DB and setting proper user privelages according to your application.
#ADD build/DB_dump.sql  /etc/mysql/db.sql
ADD build/setup.sh  /etc/mysql/mysql_setup.sh
RUN chmod +x        /etc/mysql/mysql_setup.sh
##RUN chmod +x        /etc/mysql/mysql_setup.sh
CMD ["/etc/mysql/mysql_setup.sh"]
EXPOSE 3306
# === END MySQL Installation

# === Mongodb Installation
 #Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install -y mongodb-10gen
##RUN mkdir -p /data/db
##RUN chown -R mongodb:mongodb /data
RUN echo "bind_ip = 0.0.0.0" >> /etc/mongodb.conf

# Create a runit entry for mongo service
RUN mkdir /etc/service/mongo
ADD build/run_mongo.sh /etc/service/mongo/run
RUN chown root /etc/service/mongo/run
RUN chmod +x /etc/service/mongo/run

# Spin-docker currently supports exposing port 22 for SSH and
# one additional application port (Mongo runs on 27017)
EXPOSE 27017
# === END Mongodb Installation

# === UCARP Installation
RUN apt-get install -y ucarp
# === END UCARP Installation


# === Clean up APT when done
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# Node.js Installation 

# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"

RUN apt-get update && apt-get install -y curl

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.10.38
ENV NPM_VERSION 2.10.0

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear


##  This Environment variable needed for installing global NPMs
ENV NODE_PATH /usr/local/lib/node_modules
# === END Node.js Installation 



# === Python Installation  
# remove several traces of debian python
#RUN apt-get purge -y python.*
RUN apt-get update && apt-get install -y libgcrypt11-dev zlib1g-dev && apt-get install -y build-essential && apt-get install -y gcc-4.6-base cpp-4.6 libgomp1 libquadmath0 libc6-dev
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYTHON_VERSION 2.7.9

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -x \
	&& mkdir -p /usr/src/python \
	&& curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
	&& curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
	&& gpg --verify python.tar.xz.asc \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz* \
	&& cd /usr/src/python \
	&& ./configure --enable-shared --enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	&& curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& rm -rf /usr/src/python

# install "virtualenv", since the vast majority of users of this image will want it
#RUN pip install virtualenv

# === END Python Installation


# === Ruby Installation 
RUN \
  apt-get update && \
  apt-get install -y ruby ruby-dev ruby-bundler && \
  rm -rf /var/lib/apt/lists/*

# Define working directory.

# === END Ruby Installation


# ===  Oracle DB driver Installation
RUN apt-get update && apt-get install unzip && apt-get install -y libaio1 libaio-dev

RUN mkdir /opt/oracle

ADD build/instantclient-basic-linux.x64-12.1.0.2.0.zip    /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip
ADD build/instantclient-sdk-linux.x64-12.1.0.2.0.zip      /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip

RUN chmod +x        /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip
RUN chmod +x        /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip

RUN unzip -d /opt/oracle /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip
RUN unzip -d /opt/oracle /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip
RUN mv /opt/oracle/instantclient_12_1 /opt/oracle/instantclient
RUN ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so

ENV LD_LIBRARY_PATH /opt/oracle/instantclient:$LD_LIBRARY_PATH
ENV OCI_LIB_DIR /opt/oracle/instantclient
ENV OCI_INC_DIR /opt/oracle/instantclient/sdk/include

RUN npm install oracledb -g

## === END    Oracle DB driver Installation


##  GLOBAL NPMs Installation

RUN npm install gulp -g
RUN npm install pm2 -g
RUN npm install -g grunt-cli
RUN npm install -g grunt
RUN npm install -g nodemon

## === END  GLOBAL NPMs Installation


## Git Installation

RUN apt-get install -y git-core
# Color our GIT output
RUN git config --global color.ui auto

WORKDIR /Users
## === END  Git Installation

# === Clean up APT when done
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*