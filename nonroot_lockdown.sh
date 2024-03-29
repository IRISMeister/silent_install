#!/bin/bash -e

# let it fail if it's not exist
id irisowner

# ++ edit here for optimal settings ++
password=sys12345
ssport=51773
webport=52773
kittemp=/tmp/iriskit
ISC_PACKAGE_INSTANCENAME=iris
ISC_PACKAGE_INSTALLDIR=/home/irisowner/iris
ISC_PACKAGE_IRISGROUP=irisowner
ISC_PACKAGE_IRISUSER=irisowner
ISC_PACKAGE_MGRGROUP=irisowner
ISC_PACKAGE_MGRUSER=irisowner
IRISSYS=/home/irisowner/irissys
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
  ISC_PACKAGE_INSTALLDIR=$2
  IRISSYS=/home/irisowner/irissys
fi

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
IRISSYS=$IRISSYS \
ISC_PACKAGE_INSTANCENAME=$ISC_PACKAGE_INSTANCENAME \
ISC_PACKAGE_IRISGROUP=$ISC_PACKAGE_IRISGROUP \
ISC_PACKAGE_IRISUSER=$ISC_PACKAGE_IRISUSER \
ISC_PACKAGE_MGRGROUP=$ISC_PACKAGE_MGRGROUP \
ISC_PACKAGE_MGRUSER=$ISC_PACKAGE_MGRUSER \
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
./irisinstall_silent
popd
rm -fR $kittemp

# copy iris.key
if [ -e iris.key ]; then
  cp iris.key $ISC_PACKAGE_INSTALLDIR/mgr/
fi

PATH=$PATH:$HOME/bin
# need | true to continue. why?
IRISSYS=$IRISSYS ISC_PACKAGE_INSTALLDIR=$ISC_PACKAGE_INSTALLDIR $HOME/bin/iris merge iris $(pwd)/merge.cpf | true

# stop iris to apply config settings and license (if any) 
IRISSYS=$IRISSYS $HOME/bin/iris restart $ISC_PACKAGE_INSTANCENAME quietly

# Just for convenience
echo export IRISSYS=$IRISSYS >> .bashrc
