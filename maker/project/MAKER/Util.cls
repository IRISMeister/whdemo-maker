Class MAKER.Util Extends %RegisteredObject
{

ClassMethod ClearAll()
{
	Do ##class(MAKER.Data.PurchaseOrder).%KillExtent()
	//下記は実験的にW/S送信用のデータを%Persistentで生成したもの
	Do ##class(WSDC.Maker.DeliveryNote).%KillExtent()
	Do ##class(WSDC.Maker.DeliveryNoteContainer).%KillExtent()

	Do ##class(Ens.Purge).PurgeAll(.tDeletedCount,0,0,1)
	Do ##class(Ens.Director).CleanProduction()
}

}
