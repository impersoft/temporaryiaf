unit UCommonTypes;

interface

uses
  KRK.Lib.Rtl.Common.Classes;

type
  { TSessionData precisa ser do tipo TObjectFile de forma a poder usar o m�todo
  LoadFromTextualRepresentation para carregar uma sess�o a partir da lista de
  sess�es em UAuthenticatorImpl.pas no servidor }
  TSessionData = class(TObjectFile)
  private
    Fsm_usuarios_id: SmallInt;
    Fva_nome: String;
    Fva_login: String;
    Fch_senha: String;
    Fva_email: String;
    Fbo_superusuario: Boolean;
  published
    property sm_usuarios_id: SmallInt read Fsm_usuarios_id write Fsm_usuarios_id;
    property va_nome: String read Fva_nome write Fva_nome;
    property va_login: String read Fva_login write Fva_login;
    property ch_senha: String read Fch_senha write Fch_senha;
    property va_email: String read Fva_email write Fva_email;
    property bo_superusuario: Boolean read Fbo_superusuario write Fbo_superusuario;
  end;

  { Usado apenas no cliente, esta classe, guarda os dados da sess�o do usu�rio
  atualmente logado}
  TCurrentSession = class
  private
    FID: String;
    FData: TSessionData;
  public
    constructor Create;
    destructor Destroy; override;
    property Data: TSessionData read FData;
    property ID: String read FID write FID;
  end;

implementation

{ TCurrentSession }

constructor TCurrentSession.Create;
begin
  FData := TSessionData.Create(nil);
end;

destructor TCurrentSession.Destroy;
begin
  FData.Free;
  inherited;
end;

end.
