unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uLibSetting, uExecuter, Winapi.TlHelp32,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  uTCPServer, ShellApi, Vcl.Imaging.jpeg, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Imaging.pngimage, AdvSmoothPanel, Vcl.Menus, uNetBaseSocket;

type
  TMainForm = class(TForm)
    GetPacketTimer: TTimer;
    tmrCekAplication: TTimer;
    pnlINS1: TPanel;
    pnlINS2: TPanel;
    pnlINS3: TPanel;
    pnlCub_01_01: TPanel;
    pnlCub_01_02: TPanel;
    pnlCub_01_03: TPanel;
    pnlCub_01_04: TPanel;
    pnlCub_01_05: TPanel;
    pnlCub_01_06: TPanel;
    pnlCub_02_01: TPanel;
    pnlCub_02_02: TPanel;
    pnlCub_02_03: TPanel;
    pnlCub_02_04: TPanel;
    pnlCub_02_05: TPanel;
    pnlCub_02_06: TPanel;
    pnlCub_03_01: TPanel;
    pnlCub_03_02: TPanel;
    pnlCub_03_03: TPanel;
    pnlCub_03_04: TPanel;
    pnlCub_03_05: TPanel;
    pnlCub_03_06: TPanel;
    pnlCub_04_01: TPanel;
    pnlCub_04_02: TPanel;
    pnlCub_04_03: TPanel;
    pnlCub_04_04: TPanel;
    pnlCub_04_05: TPanel;
    pnlCub_04_06: TPanel;
    pnlCub_05_01: TPanel;
    pnlCub_05_02: TPanel;
    pnlCub_05_03: TPanel;
    pnlCub_05_04: TPanel;
    pnlCub_05_05: TPanel;
    pnlCub_05_06: TPanel;
    pnlCub_06_01: TPanel;
    pnlCub_06_02: TPanel;
    pnlCub_06_03: TPanel;
    pnlCub_06_04: TPanel;
    pnlCub_06_05: TPanel;
    pnlCub_06_06: TPanel;
    pnlCub_07_01: TPanel;
    pnlCub_07_02: TPanel;
    pnlCub_07_03: TPanel;
    pnlCub_07_04: TPanel;
    pnlCub_07_05: TPanel;
    pnlCub_07_06: TPanel;
    pnlCub_08_01: TPanel;
    pnlCub_08_02: TPanel;
    pnlCub_08_03: TPanel;
    pnlCub_08_04: TPanel;
    pnlCub_08_05: TPanel;
    pnlCub_08_06: TPanel;
    pnlCub_09_01: TPanel;
    pnlCub_09_02: TPanel;
    pnlCub_09_03: TPanel;
    pnlCub_09_04: TPanel;
    pnlCub_09_05: TPanel;
    pnlCub_09_06: TPanel;
    pnlCub_10_01: TPanel;
    pnlCub_10_02: TPanel;
    pnlCub_10_03: TPanel;
    pnlCub_10_04: TPanel;
    pnlCub_10_05: TPanel;
    pnlCub_10_06: TPanel;
    pmPanel: TPopupMenu;
    btnShutdownAll: TImage;
    btnRestartAll: TImage;
    GC1: TMenuItem;
    Console1: TMenuItem;
    Run1: TMenuItem;
    Kill1: TMenuItem;
    Restart1: TMenuItem;
    Shutdown1: TMenuItem;
    imgBackground: TImage;
    pnlSessionServer: TPanel;
    img1: TImage;
    img2: TImage;
    SessionServer1: TMenuItem;
    Run2: TMenuItem;
    Kill2: TMenuItem;
    lbl1: TLabel;
    Maintenance1: TMenuItem;
    Update1: TMenuItem;
    UpdateAll1: TMenuItem;
    SyncMap1: TMenuItem;
    PingLauncher1: TMenuItem;
    Ping1: TMenuItem;
    Kill3: TMenuItem;
    KillAll1: TMenuItem;
    pnlBackground: TPanel;
    lblHeader: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure btnSingleSystemClick(Sender: TObject);
    procedure btnMultipleSystemClick(Sender: TObject);

    procedure GetPacketTimerTimer(Sender: TObject);

    procedure btnRunClick(Sender: TObject);
    procedure btnKillClick(Sender: TObject);
//    procedure btnRefreshSystemStateClick(Sender: TObject);
    procedure tmrCekAplicationTimer(Sender: TObject);
    
    procedure pnlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure imgBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    FpnlIP : string;
    vSettingFile: string;
    server: TTCPServer;

    FAppGame : TAppExecute;
    FAppGame2 : TAppExecute;

    function GetApp(appName : String): Boolean;

    procedure Client_Connect(const S: string);
    procedure Client_Disconnect(const S: string);

    procedure RefreshClient;

//    procedure UpdateSystemClientState;
    procedure UpdateConsoleState;
    procedure UpdateServerState;
//    procedure UpdateConnectState(const S: string);
//    procedure UpdateDisconnectState(const S: string);

//    procedure LoadConsoleList;

    procedure Server_Log(const S: string);

    procedure KillApp(appName : string);

    procedure NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
    procedure NetRecv_AppData(apRec: PAnsiChar; aSize: word);

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  UNetData;

{$REGION ' Form Section '}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAppGame    := TAppExecute.Create;
  FAppGame.OnStartExecute := nil;
  FAppGame.OnEndExecute   := nil;

  server := TTCPServer.Create;
  server.OnClient_Connect := Client_Connect;
  server.OnClient_DisConnect := Client_Disconnect;
  server.OnGetStatusLog := Server_Log;
  server.RegisterProcedure(CommandID, NetRecv_CommandData,SizeOf(RecCommandData));
  server.RegisterProcedure(CommandApp, NetRecv_AppData,SizeOf(RecAppData));

  GetPacketTimer.Interval := 50;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  server.UnregisterAllProcedure;
  server.Stop;
  server.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  vSettingFile := getFileSetting;
  LoadFF_NetSetting(vSettingFile, vNetSetting);

  if vNetSetting.AutoStart then
  begin
    server.Listen(vNetSetting.Port);
    GetPacketTimer.Enabled := True;
  end;

  UpdateConsoleState;
end;

{$ENDREGION}

{$REGION ' System Section '}

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  {$REGION ' Session Server '}
  if not GetApp(vNetSetting.Sessionapp) then
  begin
    FAppGame.FExecFname := vNetSetting.Sessionurl + vNetSetting.Sessionapp;
    FAppGame.Executes;
  end
  else
    ShowMessage('Can not Run, double load Session Server');
  {$ENDREGION}
end;

procedure TMainForm.btnSingleSystemClick(Sender: TObject);
var
  CommandData: RecCommandData;

begin

  if TMenuItem(Sender).Tag = 2 then
  begin
    if not GetApp(vNetSetting.sessionapp) then
    begin
      ShowMessage('Session Server is not running, run session server first');
      Exit;
    end
  end;

  CommandData.command := TMenuItem(Sender).Tag;
  server.SendDataToIPAddress(CommandID, @CommandData, FpnlIP);

  case TMenuItem(Sender).Tag of
    doShutdown : ShowMessage('Shutdown ' + FpnlIP);
    doRestart : ShowMessage('Restart ' + FpnlIP);
    doRunGC : ShowMessage('Run GC ' + FpnlIP);
    doKillGC : ShowMessage('Kill GC ' + FpnlIP);
    doKillLauncher : ShowMessage('Kill Launcher ' + FpnlIP);
    doRunUpdate : ShowMessage('Run Update ' + FpnlIP);
  end;
end;

procedure TMainForm.btnMultipleSystemClick(Sender: TObject);
var
  i : Integer;
  CommandData: RecCommandData;
  ipAddress : string;

begin
  if TImage(Sender).Tag = 2 then
  begin
    if not GetApp(vNetSetting.sessionapp) then
    begin
      ShowMessage('Session Server is not running, run session server first');
      Exit;
    end
  end;

  for i := 0 to ComponentCount-1 do
  begin
    if Components[i] is TPanel then
    begin
      if TPanel(Components[i]).Tag = 100 then
      begin
        ipAddress := TPanel(Components[i]).Hint;

        if Sender is TImage then
          CommandData.command := TImage(Sender).Tag
        else if Sender is TMenuItem then
          CommandData.command := TMenuItem(Sender).Tag;

        server.SendDataToIPAddress(CommandID, @CommandData, ipAddress);

      end;
    end;
  end;

  if Sender is TImage then
  begin
    case TImage(Sender).Tag of
      doShutdown : ShowMessage('Shutdown All PC');
      doRestart : ShowMessage('Restart All PC');
      doRunGC : ShowMessage('Run All GC ');
      doKillGC : ShowMessage('Kill All GC ');
    end;
  end
  else if Sender is TMenuItem then
  begin
    case TMenuItem(Sender).Tag of
      doShutdown : ShowMessage('Shutdown All PC');
      doRestart : ShowMessage('Restart All PC');
      doRunGC : ShowMessage('Run All GC ');
      doKillGC : ShowMessage('Kill All GC ');
      doRunUpdate : ShowMessage('Run Update All');
      doPing : ShowMessage('Ping All');
      doKillLauncher : ShowMessage('Kill Launcher All');
      doRunSyncMap : ShowMessage('Sync Map All');
    end;
  end;

end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  CommandData: RecCommandData;

begin
  CommandData.command := doRunUpdate;
  server.SendData(CommandID, @CommandData);
end;

procedure TMainForm.btnKillClick(Sender: TObject);
begin
  {$REGION ' Session Server '}
  KillApp(vNetSetting.Sessionapp);
  {$ENDREGION}
end;

procedure TMainForm.UpdateConsoleState;
var
  i : Integer;

begin
  for i := 0 to ComponentCount-1 do
  begin
    if Components[i] is TPanel then
    begin
      if TPanel(Components[i]).Tag = 100 then
      begin
        if server.getClientState(TPanel(Components[i]).Hint) then
        begin
          TPanel(Components[i]).Color := clYellow;
          TPanel(Components[i]).Font.Color := clBlack
        end
        else
        begin
          TPanel(Components[i]).Color := clRed;
          TPanel(Components[i]).Font.Color := clWhite
        end;
      end;
    end;
  end;
end;

procedure TMainForm.UpdateServerState;
begin
  if GetApp(vNetSetting.sessionapp) then
  begin
    if pnlSessionServer.Color <> clLime then
    begin
      pnlSessionServer.Color := clLime;
      pnlSessionServer.Font.Color := clBlack
    end;
  end
  else
  begin
    if pnlSessionServer.Color <> clYellow then
    begin
      pnlSessionServer.Color := clYellow;
      pnlSessionServer.Font.Color := clBlack
    end;
  end;
end;

{$ENDREGION}

{$REGION ' Join Section '}

procedure TMainForm.Client_Connect(const S: string);
var
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    server.GetConnectedList(ss);
    UpdateConsoleState;
    RefreshClient;
  finally
    ss.Free;
  end;
end;

procedure TMainForm.Client_Disconnect(const S: string);
var
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    server.GetConnectedList(ss);
    UpdateConsoleState;
    RefreshClient;
  finally
    ss.Free;
  end;
end;

function TMainForm.GetApp(appName: String): Boolean;
var
  connector, killer :THandle;
  stamped : LongBool;
  exe : TProcessEntry32;
  IDExe : Integer;
  flag : Boolean;

begin

  Result := False;

  connector := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  exe.dwSize := sizeOf(exe);
  stamped := Process32First(connector, exe);

  while stamped do
  begin
    stamped := Process32Next(connector, exe);

    if exe.szExeFile = appName then
    begin
      IDExe := exe.th32ProcessID;
      Result := True;
      Break
    end;

  end;
end;

procedure TMainForm.KillApp(appName : string);
var
  connector, killer :THandle;
  stamped : LongBool;
  exe : TProcessEntry32;
  IDExe : Integer;
  flag : Boolean;

begin

  connector := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  exe.dwSize := sizeOf(exe);
  stamped := Process32First(connector, exe);

  flag := False;
  while stamped do
  begin
    stamped := Process32Next(connector, exe);

    if exe.szExeFile = appName then
    begin
      IDExe := exe.th32ProcessID;
      flag := True;
      Break
    end;

  end;

  if flag then
  begin
    killer := OpenProcess(PROCESS_TERMINATE, False, IDExe );

    if TerminateProcess(killer, 0) then
    begin
      //LogMemo.Lines.Add('Kill ' + vNetSetting.Application2);
    end
  end;
end;

procedure TMainForm.tmrCekAplicationTimer(Sender: TObject);
begin
  UpdateServerState;
end;

procedure TMainForm.GetPacketTimerTimer(Sender: TObject);
begin
  server.getPacket;
end;

procedure TMainForm.imgBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ( Button = mbright )  and (ssShift in Shift) then
  begin
    Maintenance1.Visible := not Maintenance1.Visible
  end;
end;

procedure TMainForm.NetRecv_AppData(apRec: PAnsiChar; aSize: word);
var
  i : Integer;
  rec: ^RecAppData;

begin
  rec := @apRec^;

  if rec = nil then
    Exit;

  for i := 0 to ComponentCount-1 do
  begin
    if Components[i] is TPanel then
    begin
      if TPanel(Components[i]).Hint = LongIp_To_StrIp(rec.pid.ipSender) then
      begin
        if rec.state then
        begin
          TPanel(Components[i]).Color := clLime;
          TPanel(Components[i]).Font.Color := clBlack
        end
        else
        begin
          TPanel(Components[i]).Color := clYellow;
          TPanel(Components[i]).Font.Color := clBlack
        end;

      end;
    end;
  end;
end;

procedure TMainForm.NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
begin
  //
end;

procedure TMainForm.pnlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    p : TPoint;
begin
//  if ( Button = mbright ) then
//  begin
    if Sender is TLabel then
    begin
      GC1.Visible := False;
      Console1.Visible := False;
      SessionServer1.Visible := True;
    end
    else if Sender is TPanel then
    begin
      FpnlIP := TPanel(Sender).Hint;

      if TPanel(Sender).Tag = 100 then
      begin
        GC1.Visible := True;
        Console1.Visible := True;
        SessionServer1.Visible := False;
      end
      else
      begin
        GC1.Visible := False;
        Console1.Visible := False;
        SessionServer1.Visible := True;
      end;
    end;

    GetCursorPos(p);

    pmPanel.Popup(p.X, p.Y);
//  end;
end;

procedure TMainForm.RefreshClient;
var
  CommandData: RecCommandData;

begin
  CommandData.command := 10;
  server.SendData(CommandID, @CommandData);
end;

procedure TMainForm.Server_Log(const S: string);
begin
//  LogMemo.Lines.Add(S);
end;
{$ENDREGION}

end.
