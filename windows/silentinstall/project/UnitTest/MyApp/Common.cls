Class UnitTest.MyApp.Common
{
ClassMethod GetRESTClient() As %Net.HttpRequest
{
#DEFINE USEPROXY 0
#DEFINE PROXYHOST "127.0.0.1"
#DEFINE PROXYPORT 8888
#DEFINE HTTPSERVER "127.0.0.1"
#DEFINE HTTPPORT 52773
#DEFINE HTTPUSER "appuser"
#DEFINE HTTPPASSWORD "sys"

	set httprequest = ##class(%Net.HttpRequest).%New()
	set httprequest.Server = $$$HTTPSERVER
	set httprequest.Port = $$$HTTPPORT
	do httprequest.SetHeader("Accept","application/json")
	do httprequest.SetHeader("ContentType","application/json")
	set httprequest.Username = $$$HTTPUSER
	set httprequest.Password = $$$HTTPPASSWORD

	#;for debugging
#if $$$USEPROXY=1
	Set ..wsc.HttpProxyServer=$$$PROXYHOST
	Set ..wsc.HttpProxyPort=$$$PROXYPORT
#endif
		
	Quit httprequest
}

}
