#!/bin/bash -e

## fix ceph settings
mon_host="$(cat /secrets/rook-ceph-config-mon/mon_host)"

mkdir -p /etc/ceph \
  && ln -s /secrets/rook-ceph-admin-keyring/etc/ceph/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring \
  && cp /secrets/rook-ceph-config/etc/ceph/ceph.conf /etc/ceph/ceph.conf \
  && echo "mon host = ${mon_host}" >> /etc/ceph/ceph.conf
