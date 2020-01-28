Include CommonInc

Class MAKER.Service.HQ Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
	#; MAKER.Service.HQから実装をここに移動。
	
	Set %response.ContentType="application/json"
	Set %response.CharSet=%request.CharSet

	Set tSC=$$$OK

	Try {
		Set req={}.%FromJSON(%request.Content)

		Set st=$ZH
		Set sql="INSERT INTO Maker_Data.PurchaseOrder (DCコード,オーダ番号,オーダ日付,配送予定日付,商品コード,数量) VALUES (?,?,?,?,?,?)"
		Set stmt=##class(%SQL.Statement).%New()
		Set tSC=stmt.%Prepare(sql)
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		
		Set resultContainer={}
		Set resultContainer.Messages=[]
		Set resultContainer.Count=0
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set DCコード=req.WSDCName
		Set index=req.Count-1
		For i=0:1:index {
			Set order=req.Messages.%Get(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order.オーダ日付
			Set 配送予定日付=order.オーダ日付+5+$R(3) //最低5日 
			Set 商品コード=order.商品コード
			Set 数量=order.数量
			$$$SQLPREUPD(rs,stmt,$$$SQLARGS(DCコード,オーダ番号,オーダ日付,配送予定日付,商品コード,数量))

			#;WSHQ返信用の結果を作成
			Set result={}
			Set result.オーダ番号=オーダ番号
			Set result.配送予定日付=配送予定日付
			Do resultContainer.Messages.%Push(result)
			Set resultContainer.Count=resultContainer.Count+1
		}
		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		
		#;この後、納品書を作成して、倉庫に送信.
		#;発注書の受信後に直ちに行うのはおかしいので、タイムラグをおきたい。=>他のBSで実行する。ラグ確保のため、オーダの受信日時を新設。

		Set en=$ZH
		$$$LOGINFO("本部から発注オーダ受信:"_req.Count_"件 経過(秒):"_(en-st))
		
	}
	Catch e {
		$$$CATCH(e)
	}
	Set resultContainer.Status=tSC
	Do resultContainer.%ToJSON()

	Return $$$OK
}

}
