Class MyApps.Installer
{

XData setup [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Var Name="DATADB" Value="${Namespace}-DATA"/>
  <Var Name="CODEDB" Value="${Namespace}-CODE"/>
  <IfNotDef Var="DBDIR">
    <Var Name="DBDIR" Value="${MGRDIR}"/>
  </IfNotDef>

  <User Username="appuser" PasswordVar="appuserpwd" Roles="" Namespace="" Routine="" ExpirationDate="" Enabled="1" Comment="appilication user"/>

  <Log Text="Creating namespace ${Namespace}" Level="0"/>
  <Namespace Name="${Namespace}" Create="yes" Code="${CODEDB}" Ensemble="0" Data="${DATADB}">
    <Configuration>
      <Database Name="${CODEDB}" Dir="${DBDIR}${CODEDB}" Create="yes" Resource="%DB_${CODEDB}"/>
      <Database Name="${DATADB}" Dir="${DBDIR}${DATADB}" Create="yes" Resource="%DB_${DATADB}"/>
    </Configuration>

    <CSPApplication Url="/csp/${Namespace}" Directory="${CSPDIR}${Namespace}" Resource=""/>
    <Import File="${SRCDIR}" Flags="ck" Recurse="true"/>
    <Invoke Class="MyApp.Utils" Method="Init" CheckStatus="1" Return="RetVal">
    </Invoke>
  </Namespace>

  <Log Text="End Creating namespace ${Namespace}" Level="0"/>

</Manifest>
}

XData externaldb
{
<Manifest>
  <Default Name="Namespace" Value="MYAPPEXT"/>
  <Default Name="DBDIR" Value="/vol-data" />

  <If Condition='(##class(Config.Namespaces).Exists("${Namespace}")=0)'>
    <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="no">
      <Configuration>
        <Database Name="${Namespace}" Dir="${DBDIR}/${Namespace}" Create="yes" Resource="%DB_${Namespace}"/>
      </Configuration>
    </Namespace>
  </If>
</Manifest>
}

ClassMethod setupMethod(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod setup(ByRef tVars,pLogLevel As %Integer = 3, pInstaller As %Installer.Installer="", pLogger As %Installer.AbstractLogger="") As %Status
{
  Set tSC='$$$OK
  Try {
    Set Namespace="MYAPP"
    Set webapp="/csp/"_Namespace

    If '$D(tVars("Namespace")) { Set tVars("Namespace")=Namespace }
    If '$D(tVars("appuserpwd")) { Set tVars("appuserpwd")="sys" }
    If '$D(tVars("SRCDIR")) { Set tVars("SRCDIR")="C:\temp\silentinstall\project\" }

    #; specify database dir
    #; Use <IfNotDef> tag instead.
    #;If '$D(tVars("DBDIR")) { Set tVars("DBDIR")="C:\InterSystems\IRIS2\MGR\" }

    Set tSC=..setupMethod(.tVars,pLogLevel, pInstaller, pLogger)
    $$$ThrowOnError(tSC)

    Set oldns=$NAMESPACE
    New $NAMESPACE
    Set $NAMESPACE="%SYS"

    Set tSC = ##Class(Security.Applications).Get(webapp,.props)
    $$$ThrowOnError(tSC)
    Set props("DispatchClass")="MyApp.disp"
    Set props("Resource")=""
    Set props("DeepSeeEnabled")=1
    Set props("MatchRoles")=":%All"
    Set props("NameSpace")=Namespace
    Kill props("Type")
    Set tSC = ##Class(Security.Applications).Modify(webapp,.props)
    $$$ThrowOnError(tSC)

    Set $NAMESPACE=oldns

  } Catch(e) {
	  Set tSC=e.AsStatus()
  }
  Return tSC
}

}
