Class UnitTest.MyApp.Command Extends %UnitTest.TestCase
{

Method Test1() As %Status
{
	Set tSC=$$$OK
	Try {
		Set p=##class(MyApp.Command).%New()
		Set p.SendingFacility="SubSystem1"
		Set p.SendingDate="2018-01-01 12:30:56"
		Set p.RequestName="Req1"
		Do p.Parameters.Insert("100")
		Do p.Parameters.Insert("20")
		Do p.Parameters.Insert("XYZ")
		Do p.XMLExportToString(.xml)
		
		Do $$$AssertEquals(xml,"<Command><SendingFacility>SubSystem1</SendingFacility><SendingDate>2018-01-01 12:30:56</SendingDate><RequestName>Req1</RequestName><Parameters><ParametersItem>100</ParametersItem><ParametersItem>20</ParametersItem><ParametersItem>XYZ</ParametersItem></Parameters></Command>")

	} Catch (e) { 
		Set tSC=e.AsStatus()
		do $system.OBJ.DisplayError(tSC) 
		Do $$$AssertStatusOK(tSC)
	}
	Return tSC
}

}
