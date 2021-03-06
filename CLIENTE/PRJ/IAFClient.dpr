program IAFClient;

uses
  FastMM4 in '..\..\COMUM\SRC\FastMM4.pas',
  FastMM4Messages in '..\..\COMUM\SRC\FastMM4Messages.pas',
  Forms,
  KRK.Lib.Db.Midas.MidasLib,
  UFORMPrincipal in '..\SRC\UFORMPrincipal.pas' {FORMPrincipal},
  UDAMOPrincipal in '..\SRC\UDAMOPrincipal.pas' {DAMOPrincipal: TDataModule},
  UFORMLogin in '..\SRC\UFORMLogin.pas' {FORMLogin},
  UFORMSplash in '..\SRC\UFORMSplash.pas' {FORMSplash},
  UReconcileErrorDialog in '..\SRC\UReconcileErrorDialog.pas' {ReconcileErrorForm},
  UAuthenticator in '..\SRC\UAuthenticator.pas',
  UCommonTypes in '..\..\COMUM\SRC\UCommonTypes.pas',
  UServerManager in '..\SRC\UServerManager.pas',
  UKRDMSegurancaEPermissoes in '..\SRC\UKRDMSegurancaEPermissoes.pas' {KRDMSegurancaEPermissoes: TKRKDataModule},
  UKRFMDBAwareBasico in '..\SRC\UKRFMDBAwareBasico.pas' {KRFMDBAwareBasico: TKRKForm},
  UKRFMSegurancaEPermissoes in '..\SRC\UKRFMSegurancaEPermissoes.pas' {KRFMSegurancaEPermissoes: TKRKForm},
  UKRDMBasico in '..\SRC\UKRDMBasico.pas' {KRDMBasico: TKRKDataModule},
  UConfiguracoes in '..\SRC\UConfiguracoes.pas',
  UExtraMethods in '..\SRC\UExtraMethods.pas',
  UFORMTrocarSenha in '..\SRC\UFORMTrocarSenha.pas' {FORMTrocarSenha},
  UKRFMConfiguracoes in '..\SRC\UKRFMConfiguracoes.pas' {KRFMConfiguracoes: TKRKForm},
  UKRDMConfiguracoes in '..\SRC\UKRDMConfiguracoes.pas' {KRDMConfiguracoes: TKRKDataModule},
  UKRDMRelatorio in '..\SRC\UKRDMRelatorio.pas' {KRDMRelatorio: TKRKDataModule},
  UKRFMRelatorio in '..\SRC\UKRFMRelatorio.pas' {KRFMRelatorio: TKRKForm},
  UKRFMDialogBasico in '..\SRC\UKRFMDialogBasico.pas' {KRFMDialogBasico: TKRKForm},
  UKRFMDialogSelecao in '..\SRC\UKRFMDialogSelecao.pas' {KRFMDialogSelecao: TKRKForm},
  UKRFMSelecionarGrupo in '..\SRC\UKRFMSelecionarGrupo.pas' {KRFMSelecionarGrupo: TKRKForm},
  UKRDMAvaliadosGerenciar in '..\SRC\UKRDMAvaliadosGerenciar.pas' {KRDMAvaliadosGerenciar: TKRKDataModule},
  UKRFMAvaliadosGerenciar in '..\SRC\UKRFMAvaliadosGerenciar.pas' {KRFMAvaliadosGerenciar: TKRKForm},
  UKRFMSelecionarCBO in '..\SRC\UKRFMSelecionarCBO.pas' {KRFMSelecionarCBO: TKRKForm},
  Interposer.TAction in '..\SRC\INT\Interposer.TAction.pas',
  Interposer.TActionList in '..\SRC\INT\Interposer.TActionList.pas',
  Interposer.TClientDataSet in '..\SRC\INT\Interposer.TClientDataSet.pas',
  Interposer.TDBNavigator in '..\SRC\INT\Interposer.TDBNavigator.pas',
  Interposer.TDBRadioGroup in '..\SRC\INT\Interposer.TDBRadioGroup.pas',
  Interposer.TGroupBox in '..\SRC\INT\Interposer.TGroupBox.pas',
  Interposer.TTabSheet in '..\SRC\INT\Interposer.TTabSheet.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.Title := 'IAF - Indicadores de Aptid�o F�sica';
  Application.CreateForm(TDAMOPrincipal, DAMOPrincipal);
  Application.Run;
end.
