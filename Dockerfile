FROM stefanfritsch/baseimage_statup:1.0
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

ENV CEPH_RELEASE_STATUP=nautilus
ENV DEBIAN_FRONTEND=noninteractive

## Add ceph repo
RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN apt-add-repository "deb https://download.ceph.com/debian-${CEPH_RELEASE_STATUP}/ $(lsb_release -sc) main"

## set timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

## install ceph, git and python3 packages
RUN apt-get update \
  && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
  && apt-get install -y --no-install-recommends tzdata git screen python3-yaml python3-apscheduler ceph-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## clone auto_snapshot repo
RUN git clone https://github.com/STAT-UP/auto_snapshot /auto_snapshot \
  && chmod u+x /auto_snapshot/auto_snapshot.py

COPY fix-ceph-config.bash /etc/my_init.d/fix-ceph-config.bash
RUN chmod u+x /etc/my_init.d/fix-ceph-config.bash

