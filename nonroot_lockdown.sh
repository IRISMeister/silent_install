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
ISC_PACKAGE_INSTANCENAME=iris
# -- edit here for optimal settings --
if [ -n "$WRC_USERNAME" ]; then
  if [ ! -e $kit.tar.gz ]; then
    wget -qO /dev/null --keep-session-cookies --save-cookies cookie --post-data="UserName=$WRC_USERNAME&Password=$WRC_PASSWORD" 'https://login.intersystems.com/login/SSO.UI.Login.cls?referrer=https%253A//wrc.intersystems.com/wrc/login.csp' 
    wget --secure-protocol=TLSv1_2 -O $kit.tar.gz --load-cookies cookie "https://wrc.intersystems.com/wrc/WRC.StreamServer.cls?FILE=/wrc/Live/ServerKits/$kit.tar.gz"
    rm -f cookie
  fi
fi

if [ $# -eq 2 ]; then
  ISC_PACKAGE_INSTANCENAME=$1
else
  ISC_PACKAGE_INSTANCENAME=iris
fi
ISC_PACKAGE_INSTALLDIR=$HOME/$ISC_PACKAGE_INSTANCENAME




if [ ! -d $IRISSYS ]; then
  mkdir $IRISSYS
fi
mkdir -p $kittemp
chmod og+rx $kittemp

# requird for non-root install
rm -fR $kittemp/$kit | true
tar -xvf $kit.tar.gz -C $kittemp
cp -f Installer.cls $kittemp/$kit; chmod 777 $kittemp/$kit/Installer.cls
pushd $kittemp/$kit
sudo IRISSYS=$HOME/IRISSYS
ISC_PACKAGE_INSTANCENAME=$ISC_PACKAGE_INSTANCENAME \
ISC_PACKAGE_INSTALLDIR=$ISC_PACKAGE_INSTALLDIR \
ISC_PACKAGE_UNICODE=Y \
ISC_PACKAGE_INITIAL_SECURITY="Locked Down" \
ISC_PACKAGE_USER_PASSWORD=$password \
ISC_PACKAGE_CSPSYSTEM_PASSWORD=$password \
ISC_PACKAGE_CLIENT_COMPONENTS= \
ISC_PACKAGE_SUPERSERVER_PORT=$ssport \
ISC_PACKAGE_WEBSERVER_PORT=$webport \
ISC_INSTALLER_MANIFEST=$kittemp/$kit/Installer.cls \
ISC_INSTALLER_LOGFILE=installer_log \
ISC_INSTALLER_LOGLEVEL=3 \
ISC_INSTALLER_PARAMETERS=routines=$routines,locksiz=$locksiz,globals8k=$globals8k,gmheap=$gmheap \
./irisinstall_silent
popd
rm -fR $kittemp

# stop iris to apply config settings and license (if any) 
iris stop $ISC_PACKAGE_INSTANCENAME quietly

# copy iris.key
if [ -e iris.key ]; then
  cp iris.key $ISC_PACKAGE_INSTALLDIR/mgr/
fi

~/bin/iris start $ISC_PACKAGE_INSTANCENAME quietly
