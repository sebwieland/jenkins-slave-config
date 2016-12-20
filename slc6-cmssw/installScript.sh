#!/bin/bash
# Script to configure VM for Jenkins
export GITREPODIR=`pwd`

# Add Jenkins user and create Jenkins workdir
sudo adduser jenkins --shell /bin/bash
mkdir /home/jenkins/jenkins_slave
chown jenkins:jenkins /home/jenkins/jenkins_slave

# Add SSH public keys
# First create file to keep file permissions properly
mkdir /home/jenkins/.ssh
touch /home/jenkins/.ssh/authorized_keys
chown -R jenkins:jenkins /home/jenkins/jenkins_slave
# Back as root add authorized_keys
cat $GITREPODIR/authorized_keys >> /home/jenkins/.ssh/authorized_keys

# Install java needed by Jenkins
yum -y install java

# Install build tools
yum -y groupinstall "Development Tools"

# Install cernvmfs repo
yum -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
# Install cernvmfs
yum -y install cvmfs cvmfs-config-default
cvmfs_config setup
# Copy default.local config to proper place
cp $GITREPODIR/default.local /etc/cvmfs/default.local
# Copy additional Configs to proper place
cp $GITREPODIR/cms.cern.ch.local /etc/cvmfs/config.d
cp $GITREPODIR/cern.ch.local /etc/cvmfs/domain.d
# Check config
cvmfs_config probe
