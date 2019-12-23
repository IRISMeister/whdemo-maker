Class MAKER.Data.PurchaseOrder Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property オーダ受信日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Property IS配送遅延 As %Boolean [ InitialExpression = 0 ];

Property DCコード As %String;

Index idxオーダ番号 On オーダ番号;

Index pkey On (DCコード, オーダ番号) [ PrimaryKey, Unique ];

Index idx配送予定日付 On 配送予定日付;

Storage Default
{
<Data name="PurchaseOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>オーダ日付</Value>
</Value>
<Value name="4">
<Value>配送予定日付</Value>
</Value>
<Value name="5">
<Value>商品コード</Value>
</Value>
<Value name="6">
<Value>数量</Value>
</Value>
<Value name="7">
<Value>オーダ受信日時</Value>
</Value>
<Value name="8">
<Value>IS配送遅延</Value>
</Value>
<Value name="9">
<Value>DCコード</Value>
</Value>
</Data>
<DataLocation>^MAKER.Data.PurchaseOrderD</DataLocation>
<DefaultData>PurchaseOrderDefaultData</DefaultData>
<IdLocation>^MAKER.Data.PurchaseOrderD</IdLocation>
<IndexLocation>^MAKER.Data.PurchaseOrderI</IndexLocation>
<StreamLocation>^MAKER.Data.PurchaseOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
