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
  uLibSetting in '..\LibNets\uLibSetting.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
