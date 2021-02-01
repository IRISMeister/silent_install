Class MyApp.Command Extends (%Persistent, %XML.Adaptor)
{

Property SendingFacility As %String;

Property SendingDate As %String;

Property RequestName As %String;

Property Parameters As list Of %String;

Storage Default
{
<Data name="CommandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SendingFacility</Value>
</Value>
<Value name="3">
<Value>SendingDate</Value>
</Value>
<Value name="4">
<Value>RequestName</Value>
</Value>
<Value name="5">
<Value>Parameters</Value>
</Value>
</Data>
<DataLocation>^MyApp.CommandD</DataLocation>
<DefaultData>CommandDefaultData</DefaultData>
<IdLocation>^MyApp.CommandD</IdLocation>
<IndexLocation>^MyApp.CommandI</IndexLocation>
<StreamLocation>^MyApp.CommandS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
