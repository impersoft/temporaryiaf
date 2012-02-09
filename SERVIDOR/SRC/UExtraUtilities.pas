unit UExtraUtilities;

interface

uses Classes
   , UKRDMBasico
   , ZConnection;

function CreateDataModule(const aProviderName: WideString; const aOwner: TComponent = nil): TKRDMBasico;
function CheckSessions: Boolean;
function UseCompression: Boolean;
function SessionExists(const aSessionID: String): Boolean;
procedure ConfigureConnection(const aZConnection: TZConnection);
procedure HideInterfaces(var aContent: String; aInterfaces: array of string);
procedure AddDefaultFooter(var aContent: String);

implementation

uses SysUtils
   , UServerConfiguration
   , USessionsManager
   , UKRDMUsuarios
   , UKRDMEntidadesDoSistema
   , UKRDMGrupos;

procedure HideInterfaces(var aContent: String; aInterfaces: array of string);
var
  Intf: String;
  i: Integer;
begin
  if Length(aInterfaces) = 0 then
    Exit;

  with TStringList.Create do
    try
      { Remove todos os enters }
      aContent := StringReplace(aContent,#13#10,' ',[rfreplaceAll]);

      { Separa tudo baseando-se nos TR }
      Text := StringReplace(aContent,'<tr>',#13#10'<tr>'#13#10,[rfreplaceAll,rfIgnoreCase]);
      Text := StringReplace(Text,'</tr>',#13#10'</tr>'#13#10,[rfreplaceAll,rfIgnoreCase]);

      { Neste ponto, cada linha do StringList cont�m ou <TR>, ou </TR>, ou o que
      houver entre os dois, ent�o circulamos por cada interface que precisa ser
      ocultada }
      for Intf in aInterfaces do
      begin
        for i := 0 to Pred(Count) do
          if Pos(LowerCase(Intf),LowerCase(Strings[i])) > 0 then
            Break;

        { Se achou a interface, oculta a linha inteira de tabela, removendo do
        StringList i, i-1 e i+1 }
        if i < Count then
        begin
          Delete(i+1);
          Delete(i);
          Delete(i-1);
        end;
      end;

      aContent := Text;
    finally
      Free;
    end;
end;

procedure AddDefaultFooter(var aContent: String);
const
  FOOTER =
#13#10 +
'  <table class="MainBkgnd" border=0 cellpadding=0 cellspacing=0 width="100%">'#13#10 +
'    <tr><td class="h1Style" align="right">Copyright 2012 R&C Desenvolvedores&nbsp;</td></tr>'#13#10 +
'  </table></body>';
begin
  aContent := StringReplace(aContent,'</body>',FOOTER,[rfIgnoreCase]);
end;


function CreateDataModule(const aProviderName: WideString; const aOwner: TComponent = nil): TKRDMBasico;
begin
  { N�o � necess�rio usar free para destruir, visto que usamos este datamodule
  como dono dos datamodules criados }
  if aProviderName = 'DSPRUsuarios' then
    Result := TKRDMUsuarios.Create(aOwner)
  else if aProviderName = 'DSPREntidadesDoSistema' then
    Result := TKRDMEntidadesDoSistema.Create(aOwner)
  else if aProviderName = 'DSPRGrupos' then
    Result := TKRDMGrupos.Create(aOwner)
  else
    raise Exception.Create('N�o h� nenhum m�dulo de dados remoto para o provedor "' + aProviderName + '"');
end;

function CheckSessions: Boolean;
begin
  CS.Enter;
  try
    Result := ServerConfiguration.CheckSessions;
  finally
    CS.Leave;
  end;
end;

function UseCompression: Boolean;
begin
  CS.Enter;
  try
    Result := ServerConfiguration.UseCompression;
  finally
    CS.Leave;
  end;
end;

function SessionExists(const aSessionID: String): Boolean;
begin
  CS.Enter;
  try
    Result := Assigned(SessionsFile.Sessions[aSessionID]);
  finally
    CS.Leave;
  end;
end;

procedure ConfigureConnection(const aZConnection: TZConnection);
begin
  with aZConnection do
  begin
    CS.Enter;
    try
      HostName               := ServerConfiguration.DBHostName;
      Port                   := ServerConfiguration.DBPortNumb;
      Database               := ServerConfiguration.DBDatabase;
      User                   := ServerConfiguration.DBUserName;
      Password               := ServerConfiguration.DBPassword;
      Protocol               := ServerConfiguration.DBProtocol;
      TransactIsolationLevel := ServerConfiguration.DBTransactIsolationLevel;
    finally
      CS.Leave;
    end;

    Properties.Add('codepage=UTF8');
    Properties.Add('client_encoding=UTF8');
  end;
end;

end.
