Class UnitTest.MyApp.Dispatcher Extends %UnitTest.TestCase
{

Property restclient As %Net.HttpRequest;

Method Test1() As %Status
{
	Set tSC=$$$OK
	; requires a valid license to run 
	If $SYSTEM.License.KeyEnforcedUnits()=1 { 
		Do $$$LogMessage("Warning !!! Valid License Requird.")
		Return tSC 
	}
	Try {
		Set tSC=..restclient.Get("/csp/myapp/get")
		Set result=##class(%DynamicAbstractObject).%FromJSON(..restclient.HttpResponse.Data)
		Do $$$AssertEquals(result.Status,"OK", "Status=OK")

	} Catch (e) { 
		Set tSC=e.AsStatus()
		do $system.OBJ.DisplayError(tSC)
		Do $$$AssertStatusOK(tSC)
		If $ISOBJECT(..restclient.HttpResponse) { zw ..restclient.HttpResponse }
	}
	Return tSC
}

Method OnBeforeAllTests() As %Status
{
	Set ..restclient=##class(UnitTest.MyApp.Common).GetRESTClient()
	Quit $$$OK
}

}
