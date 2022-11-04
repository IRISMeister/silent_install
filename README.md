# silent_install
Silent installation example of InterSystems IRIS. Useful when you want to install InterSystems IRIS into a fresh VM instance.

## How to use

```bash
git clone https://github.com/IRISMeister/silent_install.git
cd silent_install
```
Now start installation.
```bash
$ sudo kit='IRIS-2021.1.2.338.0-lnxubuntux64' WRC_USERNAME='YourUserName' WRC_PASSWORD='YourPassWord' ./si.sh
```
If you don't have a valid WRC account, aquire a distribution kit separately and place it in current folder. And call si.sh without WRC_USERNAME variable.
```bash
$ sudo kit='IRIS-2021.1.2.338.0-lnxubuntux64' ./si.sh
```
You may have to explicitly specify platform name (when installing to Amazon Linux for example)
```bash
$ sudo kit='IRIS-2021.1.2.338.0-lnxrhx64' ISC_PACKAGE_PLATFORM='lnxrhx64' ./si.sh
```

If you omit parameters, it will install IRIS under /usr/irissys by the instance name 'iris'.  
Or sudo ./si.sh instanceName installdir to specify them.

```bash
$ sudo kit=... ./si.sh myiris /db/myiris
```

After installation,  you can start/stop IRIS by using irisowner (or root) O/S account.
```
$ sudo -u irisowner -i iris start iris
$ sudo -u irisowner -i iris stop iris
```
If you enable Operating-system–based authentication, you can bypass password authentication by using irisowner O/S account.
```
$ sudo -u irisowner -i iris session iris
```
If you want to completely delete iris installation, do something like this.
```
$ sudo iris stop iris quietly && sudo iris delete iris && sudo rm -fR /usr/iris
```
## Non root + Lockdown installation
Will install IRIS into /home/irisowner/iris. Registry will be located in /home/irisowner/irissys.
You have to create a linux account irisowner (which IRIS runs under) separately.
Assuming you've created and are logging in as irisowner [UID=51773] user.
```
$ sudo groupadd irisowner --gid 51773 | true
$ sudo useradd -m irisowner --uid 51773 --gid irisowner
$ sudo su - irisowner
```

```
$ whoami
irisowner
$ kit='IRIS-2021.1.2.338.0-lnxubuntux64' WRC_USERNAME='YourUserName' WRC_PASSWORD='YourPassWord' ./nonroot_lockdown.sh
$ kit='IRIS-2021.1.2.338.0-lnxubuntux64' WRC_USERNAME='YourUserName' WRC_PASSWORD='YourPassWord' ./nonroot_lockdown.sh iris2 $HOME/iris2
```

For non root installation, IRISSYS environment variable is required.  
https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=GCI_unix#GCI_unix_install_nonroot  
You always need IRISSYS env variable for all instance operations.  $HOME/bin need to be included in $PATH if it is not.  
Consider adding following lines to .bashrc
```
export IRISSYS=$HOME/irissys
```

If you want to completely delete iris installation, do something like this.
```
$ iris stop iris quietly && iris delete iris && chmod -R 777 /home/irisowner/irissys && rm -fR /home/irisowner/irissys && rm -f $HOME/bin/iris*
$ rm ~/IRISInstall*.log
```

## For Windows
See windows/readme-jp.txt 