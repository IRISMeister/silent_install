Class Silent.Installer
{

XData setup [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Var Name="Namespace" Value="myapp"/>
  <Var Name="Import" Value="0"/>

  <If Condition='+"${routines}">0'>
    <SystemSetting 
      Name="Config.config.routines"
      Value="${routines}"/>
  </If>
  <If Condition='+"${globals8k}">0'>
    <SystemSetting 
      Name="Config.config.globals8kb"
      Value="${globals8k}"/>
  </If>
  <If Condition='+"${locksiz}">0'>
    <SystemSetting 
      Name="Config.config.locksiz"
      Value="${locksiz}"/>
  </If>
  <If Condition='+"${gmheap}">0'>
    <SystemSetting
      Name="Config.config.gmheap"
      Value="${gmheap}"/>
  </If>

<If Condition='(##class(Config.Namespaces).Exists("${Namespace}")=0)'>
  <Log Text="Creating namespace ${Namespace}" Level="0"/>
  <Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="0" Data="${Namespace}">
    <Configuration>
      <Database Name="${Namespace}"
        Dir="${MGRDIR}${Namespace}"
        Create="overwrite"
        Resource="%DB_${Namespace}"
        PublicPermissions="RW"
        MountAtStartup="true"/>
    </Configuration>
  </Namespace>
  <Log Text="End Creating namespace ${Namespace}" Level="0"/>
</If>

<Namespace Name="${Namespace}" Create="no">
  <CSPApplication Url="/csp/${Namespace}" Directory="${CSPDIR}${Namespace}" Resource=""/>
</Namespace>

<Namespace Name="${Namespace}" Create="no">
  <CSPApplication Url="/csp/${Namespace}" Directory="${CSPDIR}${Namespace}" Resource=""/>
</Namespace>

<Namespace Name="%SYS" Create="no">
  <Invoke Class="Silent.Installer" Method="setupExt" CheckStatus="1"/>
</Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod setupExt() As %Status
{
  Set tSC='$$$OK
  Try {
    Set tSC=##class(Security.System).Get(,.params)
    $$$ThrowOnError(tSC)
    Set params("AutheEnabled")=$ZHEX("7FF") ; Ebable O/S auth
    Set tSC=##class(Security.System).Modify(,.params)
    $$$ThrowOnError(tSC)
  } Catch(e) {
	  Set tSC=e.AsStatus()
  }
  Return tSC
}
}