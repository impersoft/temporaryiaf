unit UKRDMBasico;

{ Anak Krakatoa DataModule. Copyright 2011 / 2012 Zetta-�mnis Solu��es Tecnol�gicas Ltda. }

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms
   , KRK.Wizards.DataModule, ActnList, ImgList, DBClient, UReconcileErrorDialog
   , DB, KRK.Components.DataControls.ValidationChecks
   , KRK.Components.AdditionalControls.BalloonHint, ActnMenus
   , ActnMan, KRK.Lib.Rtl.Common.Classes.Interposer;

type
  TClientDataSet = class (DBClient.TClientDataSet)
  private
    FKRKValidationChecks: TKRKValidationChecks;
    function GetMyParams: String;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property KRKValidationChecks: TKRKValidationChecks read FKRKValidationChecks;
    property MyParams: String read GetMyParams;
  protected
    procedure DoBeforeApplyUpdates(var OwnerData: OleVariant); override;
    procedure DoBeforeGetParams(var OwnerData: OleVariant); override;
    procedure DoBeforeGetRecords(var OwnerData: OleVariant); override;
    procedure DoBeforeRowRequest(var OwnerData: OleVariant); override;
    procedure DoBeforeExecute(var OwnerData: OleVariant); override;
    procedure DoBeforePost; override;
    procedure DoBeforeDelete; override;
    procedure DoOnNewRecord; override;
    function DoApplyUpdates(Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer): OleVariant; override;
    function DoGetRecords(Count: Integer; out RecsOut: Integer; Options: Integer; const CommandText: WideString; Params: OleVariant): OleVariant; override;
  end;

  TActionList = class(ActnList.TActionList)
  public
    procedure SyncActionsWithPermissions;
  end;

  TAction = class(ActnList.TAction)
  private
    FPermitida: Boolean;
    procedure SetPermitida(const Value: Boolean);
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
  public
    constructor Create(aOwner: TComponent); override;
    property Permitida: Boolean read FPermitida write SetPermitida default True;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  TKRDMBasico = class(TKRKDataModule)
    ACLI: TActionList;
    IMLI: TImageList;
    KRBH: TKRKBalloonHint;
    procedure KRKDataModuleBeforeCreateMyForm(const aMyFormClass: string);
  private
    { Declara��es privadas }
    FActionManager: TActionManager;
    procedure DoReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  protected
    { Declara��es protegidas }
    procedure ApplyPermissions; virtual;
    procedure ConfigureErrorHint(aTitle, aText: String; aWinControl: TWinControl; aShowHint: Boolean); virtual;
  public
    { Declara��es p�blicas }
    constructor Create(aOwner: TComponent); override;
    property ActionManager: TActionManager read FActionManager;
  end;

implementation

{$R *.dfm}

uses UDAMOPrincipal, UExtraMethods, KRK.Lib.Rtl.Common.FileUtils
   , KRK.Lib.Db.Utils, UConfiguracoes, KRK.Lib.Rtl.Common.VariantUtils;

{ TClientDataSetHelper }

constructor TClientDataSet.Create(aOwner: TComponent);
begin
  inherited;
  FKRKValidationChecks := TKRKValidationChecks.Create(Self);
end;

destructor TClientDataSet.Destroy;
begin
  FKRKValidationChecks.Free;
  inherited;
end;

procedure TClientDataSet.DoBeforeApplyUpdates(var OwnerData: OleVariant);
begin
  OwnerData := DAMOPrincipal.CurrentSession.ID;
  inherited;
end;

function TClientDataSet.DoApplyUpdates(Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer): OleVariant;
begin
  if Configuracoes.UsarCompressao then
    OleVariantByteArrayUCLCompress(Delta);

  Result := inherited;

  if Configuracoes.UsarCompressao then
    OleVariantByteArrayUCLDecompress(Result);
end;

function TClientDataSet.DoGetRecords(Count: Integer; out RecsOut: Integer; Options: Integer; const CommandText: WideString; Params: OleVariant): OleVariant;
begin
  Result := inherited;

  SaveTextFile(OleVariantByteArrayToString(Result),'c:\_testes\reset.txt');

  if Configuracoes.UsarCompressao then
    OleVariantByteArrayUCLDecompress(Result);
end;

procedure TClientDataSet.DoBeforeDelete;
begin
  { Atualmente esta valida��o n�o faz nada! }
  FKRKValidationChecks.ValidateBeforeDelete;
  inherited;
end;

procedure TClientDataSet.DoBeforePost;
begin
  inherited;
  try
    if Assigned(FKRKValidationChecks.DataSet) then
      FKRKValidationChecks.ValidateBeforePost;
  except
    on EIFV: EInvalidFieldValue do
    begin
      TKRDMBasico(Owner).ConfigureErrorHint('Campo incorreto'
                                           ,EIFV.Message
                                           ,TKRDMBasico(Owner).MyForm.ActiveControl
                                           ,True);
      Abort;
    end;
  end;
end;

procedure TClientDataSet.DoBeforeExecute(var OwnerData: OleVariant);
begin
  OwnerData := DAMOPrincipal.CurrentSession.ID;
  inherited;
end;

procedure TClientDataSet.DoBeforeGetParams(var OwnerData: OleVariant);
begin
  OwnerData := DAMOPrincipal.CurrentSession.ID;
  inherited;
end;

procedure TClientDataSet.DoBeforeGetRecords(var OwnerData: OleVariant);
begin
  OwnerData := DAMOPrincipal.CurrentSession.ID;
  inherited;
end;

procedure TClientDataSet.DoBeforeRowRequest(var OwnerData: OleVariant);
begin
  OwnerData := DAMOPrincipal.CurrentSession.ID;
  inherited;
end;

procedure TClientDataSet.DoOnNewRecord;
var
  i: Byte;
begin
  inherited;
  for i := 0 to Pred(Fields.Count) do
    if pfInKey in Fields[i].ProviderFlags then
      Break;

  if i < Fields.Count then
  begin
    Tag := Tag - 1;
    Fields[i].AsInteger := Tag;
  end;
end;

function TClientDataSet.GetMyParams: String;
begin
  Result := ClientDataSetParams(Self);
end;

constructor TKRDMBasico.Create(aOwner: TComponent);
{ ---------------------------------------------------------------------------- }
procedure GetProviderName(var aProviderName: String; const aDataSetField: TDataSetField);
begin
  if (aProviderName = '') and Assigned(aDataSetField) then
  begin
    { � seguro fazer este Cast aqui, visto que, no cliente, deve haver apenas
    CLDS, logo, todo DataSet no cliente deve ser um CLDS }
    aProviderName := TClientDataSet(aDataSetField.DataSet).ProviderName;
    { No momento em que ProviderName for diferente de vazio a recursividade p�ra.
    No pior dos casos aProviderName vai terminar vazio o que significa que o
    CLDS sendo testado � 100% local }
    GetProviderName(aProviderName,TClientDataSet(aDataSetField.DataSet).DataSetField);
  end;
end;
{ ---------------------------------------------------------------------------- }
var
  CI: TCollectionItem;
  KRKValidationChecks, ProviderName: String;
  DataSetField: TDataSetField;
begin
  inherited;

  for CI in DataSets do
    if TDataSetItem(CI).DataSet.ClassNameIs('TClientDataset') then
    begin
      ProviderName := TClientDataset(TDataSetItem(CI).DataSet).ProviderName;
      DataSetField := TClientDataset(TDataSetItem(CI).DataSet).DataSetField;

      { Ao passar deste ponto, a vari�vel ProviderName vai conter o nome do
      Provider do CLDS atual ou do primeiro CLDS mestre com um ProviderName
      definido. Caso ele esteja vazio ao final significa que � um CLDS 100%
      local e nada precisa ser feito aqui }
      GetProviderName(ProviderName,DataSetField);

      { Se houver um ProviderName, podemos tentar obter seus constraints }
      if ProviderName <> '' then
      begin
        { Todo CLDS que tem um ProviderName definido ou est� em um
        relacionamento mestre/detalhe com um mestre que cont�m um ProviderName
        definido precisa manipular o evento OnReconcileError }
        TClientDataset(TDataSetItem(CI).DataSet).OnReconcileError := DoReconcileError;

        KRKValidationChecks := GetConstraintsFor(ProviderName,TDataSetItem(CI).DataSet.Name,DAMOPrincipal.CurrentSession.ID);

        if KRKValidationChecks <> '' then
        begin
          TClientDataset(TDataSetItem(CI).DataSet).KRKValidationChecks.FromString(KRKValidationChecks);
          TClientDataset(TDataSetItem(CI).DataSet).KRKValidationChecks.DataSet := TDataSetItem(CI).DataSet;
        end;
      end;
    end;
end;

procedure TKRDMBasico.DoReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  Action := HandleReconcileError(DataSet,UpdateKind,E);
end;

procedure TKRDMBasico.KRKDataModuleBeforeCreateMyForm(const aMyFormClass: string);
var
  i: Word;
begin
  FActionManager := nil;

  { Buscando o TActionManager. Apenas o primeiro encontrado � considerado, pois
  n�o � permitido ou necess�rio mais que um TActionManager por tela }
  for i := 0 to Pred(ComponentCount) do
    if Components[i] is TActionManager then
    begin
      FActionManager := TActionManager(Components[i]);
      Break;
    end;

  if not TDAMOPrincipal(Owner).CurrentSession.Data.bo_superusuario then
    ApplyPermissions;
end;

procedure TKRDMBasico.ApplyPermissions;
var
  i: Word;
begin
  { Oculta todas as a��es dispon�veis em um poss�vel TActionManager. Isso n�o
  oculta as categorias de a��es, apenas as a��es propriamente ditas }
  if Assigned(FActionManager) then
    for i := 0 to Pred(FActionManager.ActionCount) do
      TAction(FActionManager.Actions[i]).Visible := False;

  { Instrui todas as a��es dispon�veis em ACLI a serem n�o permitidas }
  for i := 0 to Pred(ACLI.ActionCount) do
    TAction(ACLI.Actions[i]).Permitida := False;

  { Torna vis�veis ou habilitadas apenas as a��es que forem permitidas }
  TDAMOPrincipal(Owner).CLDSPermissoes.First;
  while not TDAMOPrincipal(Owner).CLDSPermissoes.Eof do
  begin
    { Primeiramente aplicamos a seguran�a em um poss�vel menu principal da janela
    associada. Como para os menus principais � necess�rio um Action Manager,
    verificamos apenas a presen�a deste �ltimo }
    if Assigned(FActionManager) then
      if (TDAMOPrincipal(Owner).CLDSPermissoes.Fields[1].AsInteger = 1) and (Pos(Self.Name + '.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString) = 1) then
        for i := 0 to Pred(FActionManager.ActionCount) do
          if Copy(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString,Succ(Pos('.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)),Length(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)) = FActionManager.Actions[i].Name then
          begin
            TAction(FActionManager.Actions[i]).Visible := TDAMOPrincipal(Owner).CLDSPermissoes.Fields[2].AsBoolean;
            Break;
          end;

    { Em seguida aplicamos as permiss�es ao componente ACLI (TActionList) }
    if (TDAMOPrincipal(Owner).CLDSPermissoes.Fields[1].AsInteger = 1) and (Pos(Self.Name + '.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString) = 1) then
      for i := 0 to Pred(ACLI.ActionCount) do
        if Copy(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString,Succ(Pos('.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)),Length(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)) = ACLI.Actions[i].Name then
        begin
          TAction(ACLI.Actions[i]).Permitida := TDAMOPrincipal(Owner).CLDSPermissoes.Fields[2].AsBoolean;
          Break;
        end;

    TDAMOPrincipal(Owner).CLDSPermissoes.Next;
  end;

  { Ao final fazemos uma esp�cie de sincroniza��o entre as propriedades
  "Permitida" e "Enabled" de ACLI de forma que fiquem desabilitadas apenas as
  a��es n�o permitidas }
  ACLI.SyncActionsWithPermissions;



//  { Primeiramente aplicamos a seguran�a em um poss�vel menu principal da janela
//  associada. Como para os menus principais � necess�rio um Action Manager,
//  verificamos apenas a presen�a deste �ltimo }
//  if Assigned(FActionManager) then
//  begin
//    { Oculta todas as a��es dispon�veis. Isso n�o oculta as categorias de a��es,
//    apenas as a��es propriamente ditas }
//    for i := 0 to Pred(FActionManager.ActionCount) do
//      TAction(FActionManager.Actions[i]).Visible := False;
//
//    { Torna vis�veis apenas as a��es que forem permitidas }
//    TDAMOPrincipal(Owner).CLDSPermissoes.First;
//    while not TDAMOPrincipal(Owner).CLDSPermissoes.Eof do
//    begin
//      if (TDAMOPrincipal(Owner).CLDSPermissoes.Fields[1].AsInteger = 1) and (Pos(Self.Name + '.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString) = 1) then
//        for i := 0 to Pred(FActionManager.ActionCount) do
//          if Copy(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString,Succ(Pos('.',TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)),Length(TDAMOPrincipal(Owner).CLDSPermissoes.Fields[0].AsString)) = FActionManager.Actions[i].Name then
//          begin
//            TAction(FActionManager.Actions[i]).Visible := TDAMOPrincipal(Owner).CLDSPermissoes.Fields[2].AsBoolean;
//            Break;
//          end;
//
//      TDAMOPrincipal(Owner).CLDSPermissoes.Next;
//    end;
//  end;
  { Em seguida aplicamos as permiss�es ao componente ACLI (TActionList) }
end;

procedure TKRDMBasico.ConfigureErrorHint(aTitle, aText: String; aWinControl: TWinControl; aShowHint: Boolean);
begin
  with KRBH do
  begin
    AssociatedWinControl := aWinControl;
    TipTitle := aTitle;
    TipText :=  aText;
    MaxWidth := 320;
    TipIcon := tiError;

    if aShowHint then
      Show;
  end;
end;

{ TAction }

constructor TAction.Create(aOwner: TComponent);
begin
  inherited;
  FPermitida := True;
end;

function TAction.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

procedure TAction.SetEnabled(const Value: Boolean);
begin
  inherited Enabled := FPermitida and Value;
end;

procedure TAction.SetPermitida(const Value: Boolean);
begin
  FPermitida := Value;
end;

{ TActionList }

procedure TActionList.SyncActionsWithPermissions;
var
  i: Word;
begin
  for i := 0 to Pred(ActionCount) do
    TAction(Actions[i]).Enabled := TAction(Actions[i]).Enabled;
end;

end.
