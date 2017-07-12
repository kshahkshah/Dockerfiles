FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git bash
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN useradd --create-home --shell /bin/bash deploy
USER deploy
WORKDIR /home/deploy

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# install ruby-build
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby, set it as default, get bundler
RUN ["/bin/bash", "-l", "-c", "rbenv install 2.3.3"]
RUN ["/bin/bash", "-l", "-c", "rbenv global 2.3.3"]
RUN ["/bin/bash", "-l", "-c", "gem install bundler"]
