#!/bin/bash -e

# ++ edit here for optimal settings ++
password=sys12345
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
else
  instance=iris
fi

installdir=$HOME/$instance

export IRISSYS=$HOME/IRISSYS
export ISC_PACKAGE_INSTANCENAME=$instance
export ISC_PACKAGE_INSTALLDIR=$installdir

export ISC_PACKAGE_UNICODE=Y
export ISC_PACKAGE_INITIAL_SECURITY="Locked Down"
export ISC_PACKAGE_USER_PASSWORD=$password
export ISC_PACKAGE_CSPSYSTEM_PASSWORD=$password
export ISC_PACKAGE_CLIENT_COMPONENTS=
export ISC_PACKAGE_SUPERSERVER_PORT=$ssport
export ISC_PACKAGE_WEBSERVER_PORT=$webport
export ISC_INSTALLER_MANIFEST=$kittemp/$kit/manifest/Installer.cls
export ISC_INSTALLER_LOGFILE=installer_log
export ISC_INSTALLER_LOGLEVEL=3
export ISC_INSTALLER_PARAMETERS=routines=$routines,locksiz=$locksiz,globals8k=$globals8k,gmheap=$gmheap


if [ ! -d $IRISSYS ]; then
  mkdir $IRISSYS
fi
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
~/bin/iris restart $ISC_PACKAGE_INSTANCENAME
