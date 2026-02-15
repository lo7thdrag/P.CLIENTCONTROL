program Client;

uses
  Vcl.Forms, Controls, Dialogs, ShellApi, Windows,
  Umain in 'Umain.pas' {MainForm},
  uDataBuffer in '..\LibNets\NetComponent\uDataBuffer.pas',
  uNetBaseSocket in '..\LibNets\NetComponent\uNetBaseSocket.pas',
  uPacketRegister in '..\LibNets\NetComponent\uPacketRegister.pas',
  uTCPClient in '..\LibNets\NetComponent\uTCPClient.pas',
  uTCPDatatype in '..\LibNets\NetComponent\uTCPDatatype.pas',
  UNetData in '..\Commons\UNetData.pas',
  uLibSetting in '..\LibNets\uLibSetting.pas',
  uIniFilesProcs in '..\LibNets\uIniFilesProcs.pas',
  uExecuter in '..\Commons\uExecuter.pas';

{$R *.res}

var
  NotifyIconData : TNotifyIconData;

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TMainForm, MainForm);
  NotifyIconData.cbSize := SizeOf( NotifyIconData );
  NotifyIconData.Wnd    := MainForm.Handle;
  NotifyIconData.uCallbackMessage := WM_ShellIcon;
  NotifyIconData.hIcon  := Application.Icon.Handle;
  NotifyIconData.uFlags := NIF_TIP + NIF_MESSAGE + NIF_ICON;

  MainForm.BeginApplication;
  try
    Shell_NotifyIcon( NIM_ADD, @NotifyIconData );
    ShowWindow(Application.Handle, SW_HIDE);
    Application.Run;
  finally
    Shell_NotifyIcon( NIM_DELETE, @NotifyIconData );
  end;
end.
