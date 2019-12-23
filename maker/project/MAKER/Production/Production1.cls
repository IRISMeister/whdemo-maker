Class MAKER.Production.Production1 Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="MAKER.Production.Production1" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="AlertNotificationManager">Ens.Alerting.NotificationManager</Setting>
  <Setting Target="Adapter" Name="AlertNotificationRecipients">appuser</Setting>
  <Setting Target="Adapter" Name="AlertNotificationOperation">MAKER.Operation.DefaultAlert</Setting>
  <Item Name="InitiateSendDeliveryNote" Category="" ClassName="MAKER.Service.InitiateSendDeliveryNote" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="MAKER.Service.HQ" Category="" ClassName="MAKER.Service.HQ" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="WSDC1" Category="" ClassName="MAKER.Operation.WSDC" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL">http://MACBETH:52773/csp/wsdc/WSDC.Service.Maker.cls</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">WSDC.Maker.WSDC.MakerSoap</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=RD</Setting>
    <Setting Target="Adapter" Name="SOAPCredentials">default</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="WSDC2" Category="" ClassName="MAKER.Operation.WSDC" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL">http://MACBETH:52773/csp/wsdc2/WSDC.Service.Maker.cls</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">WSDC.Maker.WSDC.MakerSoap</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=RD</Setting>
    <Setting Target="Adapter" Name="SOAPCredentials">default</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="WSDCRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">MAKER.Production.WSDCRouterRoutingRule</Setting>
    <Setting Target="Host" Name="ForceSyncSend">1</Setting>
  </Item>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="StorageNamespace">MAKER</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="Alert" ClassName="Ens.Alerting.AlertManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="CreateManagedAlertRule">MAKER.Rule.ManagedAlert</Setting>
  </Item>
  <Item Name="Ens.Alerting.NotificationManager" Category="Alert" ClassName="Ens.Alerting.NotificationManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="NotificationTransform">MAKER.Transform.AlertNotify</Setting>
  </Item>
  <Item Name="MAKER.Operation.DefaultAlert" Category="Alert" ClassName="MAKER.Operation.DefaultAlert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.EMail.AlertOperation" Category="Alert" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Credentials">ensemble-email</Setting>
    <Setting Target="Host" Name="IncludeDetails">1</Setting>
    <Setting Target="Host" Name="IncludeNodeinSubject">1</Setting>
    <Setting Target="Adapter" Name="From">ensemble-production@localdomain.localhost</Setting>
    <Setting Target="Adapter" Name="Recipient">reciveall@localdomain.localhost</Setting>
    <Setting Target="Host" Name="IncludeManagedAlertHistory">2</Setting>
  </Item>
</Production>
}

}
