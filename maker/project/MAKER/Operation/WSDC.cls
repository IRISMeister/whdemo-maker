Include CommonInc

Class MAKER.Operation.WSDC Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Exec(pRequest As WSDC.Maker.DeliveryNoteContainer, Output pResponse As Ens.Response) As %Status
{
	Set tSC=$$$OK

	Try {
		$$$LOGINFO("納品書の送付を開始")
		Set tSC=..Adapter.InvokeMethod("ReceiveDeliveryNote",.WSResult,pRequest)
		If $$$ISERR(tSC) {
			#; throw
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		$$$LOGINFO(pRequest.Messages.Count()_"件送信")

	}
	 Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	 }
	 
	 Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSDC.Maker.DeliveryNoteContainer"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}
