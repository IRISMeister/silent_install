/// very simple api<br/>
/// Business logic class defined by OpenAPI in myapp.spec<br/>
/// Created Nov 15, 2019 15:55:52
Class MyApp.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// 情報を取得する
ClassMethod Get() As %Stream.Object
{
    Do ..%SetHeader("Content-Type","application/json")
    set imageBuilt=$G(^ImageBuildDate)
	Set ret={"HostName":($SYSTEM.INetInfo.LocalHostName()),"UserName":($USERNAME),"Status":"OK","TimeStamp":($ZDATETIME($H)),"ImageBuilt":(imageBuilt)}
	Set ^log($INCREMENT(^log))=ret.TimeStamp
    Quit ret
}

/// 履歴を取得する
ClassMethod History() As %Stream.Object
{
    Do ..%SetHeader("Content-Type","application/json")
    
	Set ret=[]
	Set c="" For {
		Set c=$O(^log(c)) q:c=""
		Do ret.%Push({"TimeStamp":(^log(c))})
	}
    Quit ret
}

}
