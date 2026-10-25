unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uLibSetting, uExecuter, Winapi.TlHelp32,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  uTCPServer, ShellApi, Vcl.Imaging.jpeg, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, RzBmpBtn, Vcl.Imaging.pngimage, VrControls, VrLcd;

type
  TMainForm = class(TForm)
    GetPacketTimer: TTimer;
    ilClientStateColor: TImageList;
    pnlTop: TPanel;
    img1: TImage;
    pnlBottom: TPanel;
    img2: TImage;
    pnlListConsole: TPanel;
    pnlHeaderListConsole: TPanel;
    pnlFooterListConsole: TPanel;
    lbl1: TLabel;
    pnlMainListConsole: TPanel;
    lvSystem: TListView;
    pnlSystem: TPanel;
    lblPortLabel: TLabel;
    edtPortEdit: TEdit;
    btnStartButton: TButton;
    lblClearLog: TLabel;
    mmoLogMemo: TMemo;
    pnlMain: TPanel;
    imgIpConsole: TImage;
    imgSyncback: TImage;
    imgVnc: TImage;
    imgSeasionVoip: TImage;
    grpSystemServer: TGroupBox;
    btnRefreshSystemState: TButton;
    btnSystemShowLog: TButton;
    grpSystemSingleClient: TGroupBox;
    btnKillGC: TButton;
    btnRunGC: TButton;
    btnRestartSystem: TButton;
    btnShutdownSystem: TButton;
    grpSystemAllClient: TGroupBox;
    pnlSparatorFooter: TPanel;
    pnlSparatorLeft: TPanel;
    pnlSparatorHeader: TPanel;
    VrTime: TVrClock;
    pnlDay: TPanel;
    pnlDate: TPanel;
    btnShutdownAllSystem: TButton;
    btnRestartAllSystem: TButton;
    btnKillAllGC: TButton;
    btnRunAllGC: TButton;
    pnlSparatorRight: TPanel;
    imgBtnSeasionVoip: TImage;
    imgBtnSynback: TImage;
    imgBtnVnc: TImage;
    imgBtnIpConsole: TImage;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure btnStartButtonClick(Sender: TObject);

    procedure btnSingleSystemClick(Sender: TObject);
    procedure btnAllSystemClick(Sender: TObject);

    procedure GetPacketTimerTimer(Sender: TObject);
    procedure lblClearLogClick(Sender: TObject);

    procedure btnShowLogClick(Sender: TObject);
    procedure btnRefreshSystemStateClick(Sender: TObject);
    procedure cbbMenuChange(Sender: TObject);
    procedure Label3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgIpConsoleClick(Sender: TObject);
    procedure imgIpConsoleMouseEnter(Sender: TObject);
    procedure imgIpConsoleMouseLeave(Sender: TObject);
    procedure imgVncMouseEnter(Sender: TObject);
    procedure imgVncMouseLeave(Sender: TObject);
    procedure imgSeasionVoipMouseEnter(Sender: TObject);
    procedure imgSeasionVoipMouseLeave(Sender: TObject);
    procedure imgSyncbackMouseEnter(Sender: TObject);
    procedure imgSyncbackMouseLeave(Sender: TObject);

  private
    FTipeProject: Integer;

    vSettingFile: string;
    FAppGame : TAppExecute;
    server: TTCPServer;

    procedure Client_Connect(const S: string);
    procedure UpdateSystemClientState;
    procedure Client_Disconnect(const S: string);
    procedure Server_Log(const S: string);

    procedure NetRecv_CommandData(apRec: PAnsiChar; aSize: word);

  public

    function CekGameServer:Boolean;
    procedure RunApp;
    procedure KillApp(app: string);

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

  GetPacketTimer.Interval := 50;

  FTipeProject := 0;
//  cbbMenu.ItemIndex := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FAppGame.Free;

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

end;

{$ENDREGION}

{$REGION ' System Section '}

procedure TMainForm.btnRefreshSystemStateClick(Sender: TObject);
begin
  UpdateSystemClientState;
end;

procedure TMainForm.btnAllSystemClick(Sender: TObject);
var
  i: Integer;
  SelectedIndex: Integer;
  CommandData: RecCommandData;
  ipaddress: string;
  li : TListItem;

begin
  for i := 0 to lvSystem.Items.Count - 1 do
  begin
    li := lvSystem.Items[i];
    ipaddress := li.SubItems[0];

//    CommandData.projectType := cbbMenu.ItemIndex;
    CommandData.command := TButton(Sender).Tag;;
    server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);

    case TButton(Sender).Tag of
      0 : mmoLogMemo.Lines.Add('Shutdown ' + ipaddress);
      1 : mmoLogMemo.Lines.Add('Restart ' + ipaddress);
      2 : mmoLogMemo.Lines.Add('Run GC ' + ipaddress);
      3 : mmoLogMemo.Lines.Add('Run Simclient ' + ipaddress);
      4 : mmoLogMemo.Lines.Add('Kill GC ' + ipaddress);
      5 : mmoLogMemo.Lines.Add('Kill Simclient ' + ipaddress);
    end;
  end;
end;

procedure TMainForm.btnSingleSystemClick(Sender: TObject);
var
  li : TListItem;
  ipaddress: string;
  CommandData: RecCommandData;

begin
  if lvSystem.Selected <> nil then
  begin
    li := lvSystem.Items[lvSystem.Selected.Index];
    ipaddress := li.SubItems[0];

//    CommandData.projectType := cbbMenu.ItemIndex;
    CommandData.command := TButton(Sender).Tag;
    server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);

    case TButton(Sender).Tag of
      0 : mmoLogMemo.Lines.Add('Shutdown ' + ipaddress);
      1 : mmoLogMemo.Lines.Add('Restart ' + ipaddress);
      2 : mmoLogMemo.Lines.Add('Run GC ' + ipaddress);
      3 : mmoLogMemo.Lines.Add('Run Simclient ' + ipaddress);
      4 : mmoLogMemo.Lines.Add('Kill GC ' + ipaddress);
      5 : mmoLogMemo.Lines.Add('Kill Simclient ' + ipaddress);
    end;
  end;
end;

procedure TMainForm.UpdateSystemClientState;
var
  i : Integer;
  li : TListItem;

begin
  for i := 0 to lvSystem.Items.Count-1 do
  begin
    li := lvSystem.Items[i];

    if server.getClientState(li.SubItems[0]) then
    begin
      li.StateIndex := 1;
      li.SubItems[1] := 'Connected'
    end
    else
    begin
      li.StateIndex := 0;
      li.SubItems[1] := 'Disconnected'
    end;
  end;
end;

{$ENDREGION}

{$REGION ' Join Section '}

function TMainForm.CekGameServer: Boolean;
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

    if exe.szExeFile = 'AOPRSimServer.exe' then
    begin
      IDExe := exe.th32ProcessID;
      flag := True;
      Break
    end;

  end;

  if flag then
  begin
    ShowMessage('Tipe project tidak bisa diganti, Game Sedang berjalan ');
  end;

  Result := flag;
end;

procedure TMainForm.Client_Connect(const S: string);
var
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    server.GetConnectedList(ss);
    UpdateSystemClientState;
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
    UpdateSystemClientState;
  finally
    ss.Free;
  end;
end;

procedure TMainForm.GetPacketTimerTimer(Sender: TObject);
begin
  server.getPacket;
end;

procedure TMainForm.imgIpConsoleClick(Sender: TObject);
begin
  if pnlListConsole.Width = 340 then
  begin
    pnlListConsole.Width := 0;
    pnlSparatorLeft.Width := 400;
    pnlSparatorRight.Width := 0;
  end
  else if pnlListConsole.Width = 0 then
  begin
    pnlListConsole.Width := 340;
    pnlSparatorLeft.Width := 200;
    pnlSparatorRight.Width := 3;
  end;
end;

procedure TMainForm.imgIpConsoleMouseEnter(Sender: TObject);
begin
  imgIpConsole.Picture.LoadFromFile('image\ipconsole.png');
end;

procedure TMainForm.imgIpConsoleMouseLeave(Sender: TObject);
begin
  imgIpConsole.Picture.LoadFromFile('image\ipconsolelarge.png');
end;

procedure TMainForm.imgSeasionVoipMouseEnter(Sender: TObject);
begin
  imgSeasionVoip.Picture.LoadFromFile('image\seasonvoip.png');
end;

procedure TMainForm.imgSeasionVoipMouseLeave(Sender: TObject);
begin
//   imgSeasionVoip.Picture.LoadFromFile('image\seasonvoiplarge.png');
end;

procedure TMainForm.imgSyncbackMouseEnter(Sender: TObject);
begin
  imgSyncback.Picture.LoadFromFile('image\synback.png');
end;

procedure TMainForm.imgSyncbackMouseLeave(Sender: TObject);
begin
//  imgSeasionVoip.Picture.LoadFromFile('image\seasonvoiplarge.png');
end;

procedure TMainForm.imgVncMouseEnter(Sender: TObject);
begin
  imgVnc.Picture.LoadFromFile('image\vnc.png');
end;

procedure TMainForm.imgVncMouseLeave(Sender: TObject);
begin
  imgVnc.Picture.LoadFromFile('image\vnclarge.png');
end;

procedure TMainForm.KillApp(app: string);
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

    if exe.szExeFile = app then
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
      mmoLogMemo.Lines.Add('Kill ' + app);
    end
  end;
end;

procedure TMainForm.Label3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  CommandData: RecCommandData;
  ipaddress: string;
  li : TListItem;

begin
  case Button of
    mbRight :
    begin
      if (ssShift in Shift) then
      begin
        for i := 0 to lvSystem.Items.Count - 1 do
        begin
          li := lvSystem.Items[i];
          ipaddress := li.SubItems[0];

          CommandData.command := doKillLauncher;
          server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);

          mmoLogMemo.Lines.Add('Close launcher ' + ipaddress);
        end;
      end;
    end;

    mbLeft:
    begin
      if (ssShift in Shift) then
      begin
//        for i := 0 to lvVoip.Items.Count - 1 do
//        begin
//          li := lvVoip.Items[i];
//          ipaddress := li.SubItems[0];
//
//          CommandData.command := doKillLauncher;
//          server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);
//
//          LogMemo.Lines.Add('Close launcher ' + ipaddress);
//        end;
      end;
    end;
  end;
end;

procedure TMainForm.btnStartButtonClick(Sender: TObject);
begin
//  if StartButton.Caption = 'Start' then
//  begin
//    server.Listen(PortEdit.Text);
//    GetPacketTimer.Enabled := True;
//
//    StartButton.Caption := 'Stop';
//  end
//  else
//  begin
//    GetPacketTimer.Enabled := False;
//    server.Stop;
//
//    StartButton.Caption := 'Start';
//  end;
end;

procedure TMainForm.btnShowLogClick(Sender: TObject);
begin
  if Self.Width > 546 then
  begin
    Self.Width := 546;
    btnSystemShowLog.Caption := 'Show Log';
//    btnVoipShowLog.Caption := 'Show Log'
  end
  else
  begin
    Self.Width := 799;
    btnSystemShowLog.Caption := 'Hide Log';
//    btnVoipShowLog.Caption := 'Hide Log'
  end;

end;

procedure TMainForm.lblClearLogClick(Sender: TObject);
begin
  mmoLogMemo.Clear;
end;

procedure TMainForm.NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
begin
  //
end;

procedure TMainForm.pnlHeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbRight :
    begin
      if (ssShift in Shift) then
      begin
//        cbbMenu.Visible := not cbbMenu.Visible;
      end;
    end;
  end;
end;

procedure TMainForm.RunApp;
begin
  FAppGame.Executes;
end;

procedure TMainForm.Server_Log(const S: string);
begin
  mmoLogMemo.Lines.Add(S);
end;

procedure TMainForm.cbbMenuChange(Sender: TObject);
begin
  if CekGameServer then
  begin
//    cbbMenu.ItemIndex := FTipeProject;
    Exit
  end;

//  FTipeProject := cbbMenu.ItemIndex;

  btnAllSystemClick(btnKillAllGC);
  KillApp(vNetSetting.FileAmphibious + vNetSetting.Application);
  KillApp(vNetSetting.FileNaval + vNetSetting.Application);

  case FTipeProject of
    0: FAppGame.FExecFname := vNetSetting.FileAmphibious + vNetSetting.Application;
    1: FAppGame.FExecFname := vNetSetting.FileNaval + vNetSetting.Application;
  end;

  RunApp;

end;

{$ENDREGION}

end.
