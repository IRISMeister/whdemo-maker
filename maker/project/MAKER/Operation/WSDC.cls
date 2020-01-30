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
		Set tSC=..Adapter.InvokeMethod("ReceiveDeliveryNote",.WSResult,pRequest)
		If $$$ISERR(tSC) {
			#; throw
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		$$$LOGINFO("納品書送信:"_pRequest.Messages.Count()_"件")

	}
	 Catch e {
		 $$$CATCH(e,tSC)
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
