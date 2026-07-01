unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uLibSetting,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uExecuter,
  uTCPClient, ShellApi, Vcl.Imaging.jpeg, Winapi.TlHelp32, Vcl.Imaging.pngimage,
  Vcl.Menus, AdvSmoothPanel;

const
  WM_ShellIcon = WM_USER + 1;

type
  TMainForm = class(TForm)

    GetPacketTimer: TTimer;
    LogMemo: TMemo;
    Timer1: TTimer;

    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    Hide1: TMenuItem;
    tmrCekApplication: TTimer;
    pnlBody: TAdvSmoothPanel;
    imgBackground: TImage;
    lblHeader: TLabel;
    btnClose: TImage;
    lblClearLog: TImage;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    procedure btnCloseClick(Sender: TObject);

    procedure GetPacketTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lblClearLogClick(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure Hide1Click(Sender: TObject);
    procedure tmrCekApplicationTimer(Sender: TObject);

  private
    vSettingFile: string;

    Client: TTCPClient;
    FAppGame : TAppExecute;
    AppState : Boolean;
    isFlag : Boolean;

    function GetApp: Boolean;

    procedure OnConnected(Sender: TObject);
    procedure OnDisconnected(Sender: TObject);
    procedure Client_Log(const S: string);
    procedure NetRecv_CommandData(apRec: PAnsiChar; aSize: word);

    procedure ShutdownWindows();
    procedure RestartWindows();
    procedure RunClientApp();
    procedure KillClientApp();
    procedure RunUpdateClient();
    procedure RunSyncMap();
    procedure PingClientApp();

    procedure O_nsShellIcon( var Msg : TMessage ); message WM_ShellIcon;
    procedure O_nsMinimize( var Msg : TWMSysCommand ); message WM_SYSCOMMAND;

  public
    procedure BeginApplication;

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  UNetData;

{$REGION ' Form Handle '}

procedure TMainForm.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAppGame    := TAppExecute.Create;
  FAppGame.OnStartExecute := nil;
  FAppGame.OnEndExecute   := nil;

  Client := TTCPClient.Create;

  Client.OnConnected := OnConnected;
  Client.OnDisconnected := OnDisconnected;

  Client.OnGetStatusLog := Client_Log;

  Client.RegisterProcedure(CommandID, NetRecv_CommandData, SizeOf(RecCommandData));
  Client.RegisterProcedure(CommandApp, nil, SizeOf(RecAppData));

  GetPacketTimer.Interval := 50;
  AppState := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Client.Disconnect;
  Client.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Show;
  SetForegroundWindow( Handle );
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TMainForm.BeginApplication;
begin
  vSettingFile := getFileSetting;
  LoadFF_NetSetting(vSettingFile, vNetSetting);

  if vNetSetting.AutoStart then
  begin
    Client.Connect(vNetSetting.ServerIP, vNetSetting.Port);
  end;
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  Client.Disconnect;
  Close;
end;

procedure TMainForm.lblClearLogClick(Sender: TObject);
begin
  LogMemo.Clear;
end;

{$ENDREGION}

{$REGION ' Additional Handle '}

procedure TMainForm.Client_Log(const S: string);
begin
  LogMemo.Lines.Add(S);
end;

procedure TMainForm.NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
var
  r: ^RecCommandData;
begin
  r := @apRec^;
  case r.command of
    doShutdown:
    begin
      ShutdownWindows;
    end;
    doRestart:
    begin
      RestartWindows;
    end;
    doRunGC:
    begin
      RunClientApp;
    end;
    doRunUpdate:
    begin
      RunUpdateClient;
    end;
    doKillGC:
    begin
      KillClientApp
    end;
    doKillLauncher:
    begin
      Close;
    end;
    doRunSyncMap :
    begin
      RunSyncMap;
    end;
    doPing:
    begin
      PingClientApp;
    end;
  end;
end;

procedure TMainForm.OnConnected(Sender: TObject);
begin
  GetPacketTimer.Enabled := True;
end;

procedure TMainForm.OnDisconnected(Sender: TObject);
begin
  GetPacketTimer.Enabled := False;
end;

procedure TMainForm.O_nsMinimize(var Msg: TWMSysCommand);
begin
  if( Msg.CmdType = SC_MINIMIZE ) then
    Hide
  else
    inherited;
end;

procedure TMainForm.O_nsShellIcon(var Msg: TMessage);
var
  O_ns : TPoint;
begin
  case Msg.LParam of
    WM_LBUTTONDBLCLK :
    begin
      Show;
      SetForegroundWindow( Handle );
    end;
    WM_RBUTTONUP :
    begin
      SetForegroundWindow( Handle );
      GetCursorPos( O_ns );
      PopupMenu1.Popup( O_ns.x, O_ns.y );
      PostMessage( Handle, WM_USER, 0, 0 );
    end;
  end;
end;

procedure TMainForm.PingClientApp;
var
  AppData: RecAppData;

begin

  AppState := GetApp;

  AppData.state := AppState;
  Client.SendData(CommandApp, @AppData);

end;

procedure TMainForm.KillClientApp;
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

    if exe.szExeFile = vNetSetting.Clientapp then
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
      LogMemo.Lines.Add('Kill ' + vNetSetting.Clientapp);
    end
  end;
end;

procedure TMainForm.RunClientApp;
begin
  if not GetApp then
  begin
    FAppGame.FExecFname := vNetSetting.Clientapp;
    FAppGame.Executes;
    LogMemo.Lines.Add('Run ' + vNetSetting.Clientapp);
  end
  else
    LogMemo.Lines.Add('Can not Run, double load ' + vNetSetting.Clientapp);

end;

procedure TMainForm.RunSyncMap;
begin
  FAppGame.FExecFname := vNetSetting.SyncMap;
  FAppGame.Executes;
  LogMemo.Lines.Add('Run ' + vNetSetting.SyncMap);
end;

procedure TMainForm.RunUpdateClient;
begin
  FAppGame.FExecFname := vNetSetting.ClientUpdate;
  FAppGame.Executes;
  LogMemo.Lines.Add('Run ' + vNetSetting.ClientUpdate);
end;

procedure TMainForm.RestartWindows;
begin
  LogMemo.Lines.Add('Restart');
  ShellExecute(handle, 'open', PChar('cmd.exe'), PChar('/C shutdown /r /t 2'), nil, SW_HIDE);
end;

procedure TMainForm.ShutdownWindows;
begin
  LogMemo.Lines.Add('Shutdown');
  ShellExecute(handle, 'open', PChar('cmd.exe'), PChar('/C shutdown /s /t 2'), nil, SW_HIDE);
end;

function TMainForm.GetApp: Boolean;
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

    if exe.szExeFile = vNetSetting.Clientapp then
    begin
      IDExe := exe.th32ProcessID;
      Result := True;
      Break
    end;

  end;
end;

procedure TMainForm.GetPacketTimerTimer(Sender: TObject);
begin
  Client.GetPacket;
end;

procedure TMainForm.Show1Click(Sender: TObject);
begin
  Show;
  SetForegroundWindow( Handle );
end;

procedure TMainForm.Hide1Click(Sender: TObject);
begin
  Hide;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if Assigned(Client) then
  begin
    if Client.Connected = False then
    begin
      if vNetSetting.AutoStart then
      begin
        Client.Connect(vNetSetting.ServerIP, vNetSetting.Port);
      end;

      Show;
      isFlag := False;
    end
    else
    begin
      if not isFlag then
      begin
        isFlag := True;
        Hide
      end;

    end;
  end;
end;

procedure TMainForm.tmrCekApplicationTimer(Sender: TObject);
var
  value : Boolean;
  AppData: RecAppData;

begin

  value := GetApp;

  if AppState = value then
    Exit;

  AppState := value;

  AppData.state := AppState;
  Client.SendData(CommandApp, @AppData);

end;

{$ENDREGION}

end.
