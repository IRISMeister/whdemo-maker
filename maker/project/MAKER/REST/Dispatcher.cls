Include (CommonInc, Ensemble)

Class MAKER.REST.Dispatcher Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/ReceivePurchaseOrder" Method="POST" Call="ReceivePurchaseOrder"/>
</Routes>
}

ClassMethod ReceivePurchaseOrder() As %Status
{
	Set tSC=##class(Ens.Director).CreateBusinessService("HQ",.tService)
	Set tSC = tService.ProcessInput(,.output)
	Return tSC
}

ClassMethod test() As %Status
{
	Set request={}.%FromJSON(%request.Content)
	s ^iwa=request.WSDCName
	
	Set container={}
	Set container.Count=3
	Set container.Status=1
	Set container.TimeStamp=$ZDATETIME($H)
	Set container.Messages=[]
	For i=1:1:3 {
		Set order={}
		Set order.オーダ番号=12345
		Set order.配送予定日付=+$H
		Do container.Messages.%Push(order)
	}
	
	Set ^log($INCREMENT(^log))=container.TimeStamp
	Do container.%ToJSON()
	
	Return $$$OK
}

}
