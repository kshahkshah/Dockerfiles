FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git bash
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# install our specific deps, we do not need a fancy Ruby version
RUN apt-get install -y ruby

## START COPY FROM https://hub.docker.com/r/stilliard/pure-ftpd/~/dockerfile/

RUN apt-get -y --force-yes --fix-missing install dpkg-dev debhelper

# install dependancies
RUN apt-get -y build-dep pure-ftpd

# build from source
RUN mkdir /tmp/pure-ftpd/ && \
	cd /tmp/pure-ftpd/ && \
	apt-get source pure-ftpd && \
	cd pure-ftpd-* && \
	./configure --with-tls --with-everything && \
	sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
	dpkg-buildpackage -b -uc

# install the new deb files
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
RUN apt-get -y install openbsd-inetd
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb

## END COPY

# create FTP group
RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /home/ftpusers -s /dev/null ftpuser

# create deploy user
RUN useradd --create-home --shell /bin/bash deploy

# FTP Settings
ENV PUBLICHOST ftp.getswill.com
VOLUME ["/home/ftpusers"]

# copy the dummy passfile into deploy users home
COPY passfile /home/deploy/passfile

# copy the script into deploy users home
COPY auth.rb /home/deploy/auth.rb
RUN chmod u+x /home/deploy/auth.rb

EXPOSE 21 30000-30009

# set up deploy user
# USER deploy
# WORKDIR /home/deploy
#
#
# RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
# RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
#
# # install ruby-build
# RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
#
# # install ruby, set it as default, get bundler
# RUN ["/bin/bash", "-l", "-c", "rbenv install 2.3.3"]
# RUN ["/bin/bash", "-l", "-c", "rbenv global 2.3.3"]
# RUN ["/bin/bash", "-l", "-c", "gem install bundler"]

# startup
# USER root
CMD pure-authd -p /var/run/pure-authd.pid -B -s /var/run/ftpd.sock -r /home/deploy/auth.rb & pure-ftpd -l extauth:/var/run/ftpd.sock -E -j -R -P $PUBLICHOST -p 30000:30009
