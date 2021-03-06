Include (CommonInc, Ensemble)

Class MAKER.Task Extends %SOAP.WebService
{

Parameter ADAPTER;

Parameter SERVICENAME = "MAKER";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

Method Test() As %String [ WebMethod ]
{
	Return $ZDATETIME($h)
}

Method ClearAll() As %Status [ WebMethod ]
{
	Do ##class(MAKER.Util).ClearAll()
	Do ##class(Ens.Purge).PurgeAll(.tDeletedCount,0,0,1)
	Do ##class(Ens.Director).CleanProduction()
	Return $$$OK
}

ClassMethod StartProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StartProduction("MAKER.Production.Production1")
}

ClassMethod StopProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StopProduction(,1)
}

}
