Include CommonInc

Class MAKER.Service.InitiateSendDeliveryNote Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	Set tSC=$$$OK
	#;ToDo: 外部から取得するのが望ましい。wsdcはネームスペース名では無いので注意(一致させるのも良いかもしれない)
	For wsdc="WSDC1","WSDC2" {
		Set tSC=..Exec(wsdc) //ToDo: error check?
		If $$$ISERR(tSC) Quit
	}
	Return tSC
}

Method Exec(wsdc As %String) As %Status
{
	Set tSC=$$$OK

	Try {
		$$$LOGINFO("納品書の作成を開始:"_wsdc)
		Set sql2="UPDATE Maker_Data.PurchaseOrder Set 配送予定日付=?,IS配送遅延=1 WHERE ID=?"
		Set stmt2=##class(%SQL.Statement).%New()
		Set tSC=stmt2.%Prepare(sql2)
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }

		Set sql3="DELETE FROM Maker_Data.PurchaseOrder WHERE ID=?" 
		Set stmt3=##class(%SQL.Statement).%New()
		Set tSC=stmt3.%Prepare(sql3)
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }

		Set today=##class(Common.Util).GetToday() 
		Set sql="SELECT * FROM Maker_Data.PurchaseOrder WHERE 配送予定日付<=? AND DCコード=?"
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today,wsdc))
		If rs.%SQLCODE=100 {
			$$$LOGINFO("納品書の作成対象無し:"_wsdc)
			Quit
		}
		Set rs2=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION ISOLATION LEVEL READ COMMITTED")

		Set makerShippingNo=$SYSTEM.Util.CreateGUID()
		Set container=##class(WSDC.Maker.DeliveryNoteContainer).%New()
		Set container.DestWSDC=wsdc

		Kill RowSet
		Do {
			Set id=rs.ID

			#;いくつかを"遅配"にする。
			#;つまり"今日"発送する予定になっている(WSDCに入荷オーダ=WSDC.ReceivingOrderが届いている)が、メーカからの納品書に含まれない。
			#;その結果、これらのレコードはWSDC.ReceivingOrderに最後まで残る。
			If (rs.IS配送遅延=0)&($R(10)>8) {  //一回遅延したものはもう遅延させない
				Set newsenddate=rs."配送予定日付"+$R(3)+1
				$$$SQLPREUPD(rs2,stmt2,$$$SQLARGS(newsenddate,id))
				w rs.オーダ番号_" 出荷遅れ:"_$ZDATETIME(newsenddate),!
				Continue
			}

			w rs.オーダ番号,!
			Set order=##class(WSDC.Maker.DeliveryNote).%New()
			Set order."オーダ番号"=rs.オーダ番号
			Set order."オーダ日付"=rs."オーダ日付"
			Set order."配送予定日付"=rs."配送予定日付"
			Set order."配送日付"=today
			Set order."商品コード"=rs."商品コード"
			Set order."数量"=rs."数量"
			Set order.メーカ出荷番号=makerShippingNo
			Do container.Messages.Insert(order)
						
			Set RowSet(id)=""

		} While (rs.%Next()) 

		#;OpenTransactionがあるとSendRequest()時に強制的にcommitされる。
		#;(n open user transaction found; committing before EnQueue(xxx))
		#;つまりSendRequest()の成否によりトランザクションを制御できない。
		#;=>送信失敗データは原則必ず再送しないと送信元の状態と不一致になる。
		#;Operation側の応答アクションにE=RD設定することで、送信失敗時にはOperationを停止し、再送用データを保全。
		#;=>作成したメッセージを(Commit後)にSendRequestする直前にクラッシュするとデータロスト
		#;データロストよりも重複送信するべき。
		k rs
		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		$$$LOGINFO("納品書作成("_wsdc_") :"_container.Messages.Count()_"件")

		Set tSC=..SendRequestAsync("WSDCRouter",container)
		If $$$ISERR(tSC) {
			#; throw
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		#;ToDo: 処理済みの行を削除。ここでクラッシュすると、WSDCに同じ納品書が再送されることになる。WSDC側で重複時は無視するように対応が必要。
		Set id="" For {
			Set id=$O(RowSet(id)) Q:id=""
			$$$SQLPREUPD(rs3,stmt3,$$$SQLARGS(id))
		}
	}
	 Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	 }
	 k rs
	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	Return tSC
}

}
