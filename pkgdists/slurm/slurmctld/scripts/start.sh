#!/bin/bash

if [ -z ${SLURM_CLUSTER_NAME+x} ]; then echo "SLURM_CLUSTER_NAME not set" && exit 1; fi
if [ -z ${SLURM_CONTROL_MACHINE+x} ]; then echo "SLURM_CONTROL_MACHINE not set" && exit 1; fi
if [ -z ${SLURM_NODE_NAMES+x} ]; then echo "SLURM_NODE_NAMES not set" && exit 1; fi

sed -i -e "s/###SLURM_CLUSTER_NAME###/${SLURM_CLUSTER_NAME}/g" /usr/local/etc/slurm.conf
sed -i -e "s/###SLURM_CONTROL_MACHINE###/${SLURM_CONTROL_MACHINE}/g" /usr/local/etc/slurm.conf
sed -i -e "s/###SLURM_NODE_NAMES###/${SLURM_NODE_NAMES}/g" /usr/local/etc/slurm.conf

/usr/bin/supervisord --nodaemon
