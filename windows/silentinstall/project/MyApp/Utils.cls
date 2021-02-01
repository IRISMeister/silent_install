Class MyApp.Utils [ Abstract ]
{

/// App level initialization if any
ClassMethod Init() As %Status
{
	#; Do something to populate initial data
	Set ^ImageBuildDate=$ZDATETIME($H)
	For i=1:1:100 { Set ^mydata(i)=i }
	Quit $$$OK
}

}
