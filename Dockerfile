

FROM phusion/baseimage
MAINTAINER Jason Kingsbury
RUN apt-get -q update


# Install cron & dev stuff
RUN apt-get -y install cron build-essential make libxml-sax-expat-perl

# Get prereq perl stuff
RUN cpan File::Copy::Recursive File::Glob LWP::Simple TVDB::API Getopt::Long Switch WWW::TheMovieDB XML::Simple JSON::Parse

# Let's prep the handbrake install
RUN mkdir -p /data/bin && mkdir -p /data/in && mkdir -p /data/movies && mkdir -p /data/episodes && mkdir -p /data/music

# Pull the latest handbrake batch script 
ENV HOME /root
COPY sorttvcron /data/bin/
COPY sorttv.pl /data/bin/
COPY sorttv.conf /data/bin/
RUN chmod 755 /data/bin/sorttv.pl

# Setup Cron Job
RUN cat /data/bin/sorttvcron >> /etc/crontab

# Setup Cron Log
RUN touch /var/log/sorttv.log

# Setup Cron Entrypoint
ENTRYPOINT ["cron"]

# Setup Volumes
VOLUME ["/data/in"]
VOLUME ["/data/movies"]
VOLUME ["/data/episodes"]

# Define default command.
CMD ["cron", "-f", "&&", "tail", "-f", "/var/log/sorttv.log"]
