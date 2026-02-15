program server;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {MainForm},
  uDataBuffer in '..\LibNets\NetComponent\uDataBuffer.pas',
  uNetBaseSocket in '..\LibNets\NetComponent\uNetBaseSocket.pas',
  uPacketRegister in '..\LibNets\NetComponent\uPacketRegister.pas',
  uTCPDatatype in '..\LibNets\NetComponent\uTCPDatatype.pas',
  uTCPServer in '..\LibNets\NetComponent\uTCPServer.pas',
  UNetData in '..\Commons\UNetData.pas',
  uIniFilesProcs in '..\LibNets\uIniFilesProcs.pas',
  uLibSetting in '..\LibNets\uLibSetting.pas',
  uExecuter in '..\Commons\uExecuter.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
