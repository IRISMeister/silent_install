#!/bin/bash -e

if [ $(whoami) != "root" ]; then
  echo "please sudo"
  exit 1
fi

# ++ edit here for optimal settings ++
password=sys
globals8k=64
routines=64
locksiz=16777216
gmheap=37568
ssport=51773
webport=52773
kittemp=/tmp/iriskit
# -- edit here for optimal settings --
if [ -n "$WRC_USERNAME" ]; then
  if [ ! -e $kit.tar.gz ]; then
    wget -qO /dev/null --keep-session-cookies --save-cookies cookie --post-data="UserName=$WRC_USERNAME&Password=$WRC_PASSWORD" 'https://login.intersystems.com/login/SSO.UI.Login.cls?referrer=https%253A//wrc.intersystems.com/wrc/login.csp' 
    wget --secure-protocol=TLSv1_2 -O $kit.tar.gz --load-cookies cookie "https://wrc.intersystems.com/wrc/WRC.StreamServer.cls?FILE=/wrc/Live/ServerKits/$kit.tar.gz"
    rm -f cookie
  fi
fi

if [ $# -eq 2 ]; then
  instance=$1
  installdir=$2
else
  instance=iris
  installdir=/usr/irissys
fi

#read -p "Will install instance '$instance' into '$installdir'.  Are you sure? (y/N): " yn
#case "$yn" in 
#  [yY]*) ;;
#  *) exit 1;;
#esac

# Specifies the effective user for InterSystems IRIS processes. 
export ISC_PACKAGE_IRISGROUP=irisusr
# Specifies the effective user for the InterSystems IRIS Superserver. 
export ISC_PACKAGE_IRISUSER=irisusr
#Specifies the group that is allowed to start and stop the instance
export ISC_PACKAGE_MGRGROUP=irisowner
#Specifies the login name of the owner of the installation. For example:
export ISC_PACKAGE_MGRUSER=irisowner

export ISC_PACKAGE_INSTANCENAME=$instance
export ISC_PACKAGE_INSTALLDIR=$installdir

export ISC_PACKAGE_UNICODE=Y
export ISC_PACKAGE_INITIAL_SECURITY=Normal
export ISC_PACKAGE_USER_PASSWORD=$password
export ISC_PACKAGE_CSPSYSTEM_PASSWORD=$password
export ISC_PACKAGE_CLIENT_COMPONENTS=
export ISC_PACKAGE_SUPERSERVER_PORT=$ssport
export ISC_PACKAGE_WEBSERVER_PORT=$webport
export ISC_INSTALLER_MANIFEST=$kittemp/$kit/manifest/Installer.cls
export ISC_INSTALLER_LOGFILE=installer_log
export ISC_INSTALLER_LOGLEVEL=3
export ISC_INSTALLER_PARAMETERS=routines=$routines,locksiz=$locksiz,globals8k=$globals8k,gmheap=$gmheap

useradd -m $ISC_PACKAGE_MGRUSER --uid 51773 | true
useradd -m $ISC_PACKAGE_IRISUSER --uid 52773 | true

mkdir -p $kittemp
chmod og+rx $kittemp

# requird for non-root install
rm -fR $kittemp/$kit | true
tar -xvf $kit.tar.gz -C $kittemp
cp -fR manifest/ $kittemp/$kit
pushd $kittemp/$kit
./irisinstall_silent
popd
rm -fR $kittemp

# copy iris.key
if [ -e iris.key ]; then
  cp iris.key $ISC_PACKAGE_INSTALLDIR/mgr/
fi

# Apply config settings and license (if any) 
iris restart $ISC_PACKAGE_INSTANCENAME
