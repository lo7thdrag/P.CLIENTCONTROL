unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uLibSetting,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  uTCPServer, ShellApi, Vcl.Imaging.jpeg;

type
  TMainForm = class(TForm)
    GetPacketTimer: TTimer;
    pnlHeader: TPanel;
    imgHeaderBackground: TImage;
    PortLabel: TLabel;
    PortEdit: TEdit;
    StartButton: TButton;
    pnlBody: TPanel;
    ClientConnectedListBox: TListBox;
    GroupBox2: TGroupBox;
    KillAllButton: TButton;
    RestartAllButton: TButton;
    RunAllButton: TButton;
    ShutdownAllbutton: TButton;
    ShutdownButton: TButton;
    RestartButton: TButton;
    RunButton: TButton;
    KillButton: TButton;
    Image1: TImage;
    imgBackground: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LogMemo: TMemo;
    Image2: TImage;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure StartButtonClick(Sender: TObject);

    procedure SingleButtonClick(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);

    procedure GetPacketTimerTimer(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);

  private
    vSettingFile: string;

    server: TTCPServer;

    procedure Client_Connect(const S: string);
    procedure Client_Disconnect(const S: string);
    procedure Server_Log(const S: string);

    procedure NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
    procedure NetRecv_CommandTes(apRec: PAnsiChar; aSize: word);

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  UNetData;

procedure TMainForm.Client_Connect(const S: string);
var
  ss: TStringList;
begin
  ss := TStringList.Create;
  try
    LogMemo.Lines.Add(S);
    ClientConnectedListBox.Clear;
    server.GetConnectedList(ss);
    ClientConnectedListBox.Items.Assign(ss);
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
    LogMemo.Lines.Add(S);
    ClientConnectedListBox.Clear;
    server.GetConnectedList(ss);
    ClientConnectedListBox.Items.Assign(ss);
  finally
    ss.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  server := TTCPServer.Create;
  server.OnClient_Connect := Client_Connect;
  server.OnClient_DisConnect := Client_Disconnect;
  server.OnGetStatusLog := Server_Log;
  server.RegisterProcedure(CommandID, NetRecv_CommandData,SizeOf(RecCommandData));
  server.RegisterProcedure(CommandTes, NetRecv_CommandTes, SizeOf(RecCommandTes));

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
end;

procedure TMainForm.GetPacketTimerTimer(Sender: TObject);
begin
  server.getPacket;
end;

procedure TMainForm.Image2Click(Sender: TObject);
begin
  PortLabel.Visible := not PortLabel.Visible;
  PortEdit.Visible := not PortEdit.Visible;
  StartButton.Visible := not StartButton.Visible;
end;

procedure TMainForm.Label2Click(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TMainForm.NetRecv_CommandData(apRec: PAnsiChar; aSize: word);
begin
  //
end;

procedure TMainForm.NetRecv_CommandTes(apRec: PAnsiChar; aSize: word);
var
  r: ^RecCommandTes;
begin
  r := @apRec^;
  ShowMessage('Tes');
end;

procedure TMainForm.Server_Log(const S: string);
begin
  LogMemo.Lines.Add(S);
end;

procedure TMainForm.AllButtonClick(Sender: TObject);
var
  i: Integer;
  SelectedIndex: Integer;
  CommandData: RecCommandData;
  ipaddress: string;

begin
  for i := 0 to ClientConnectedListBox.Items.Count - 1 do
  begin
    SelectedIndex := i;

    if SelectedIndex > -1 then
    begin
      ipaddress := server.Clients[SelectedIndex].ConnectedIP;
      CommandData.command := TButton(Sender).Tag;;
      server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);
    end;
  end;
end;

procedure TMainForm.SingleButtonClick(Sender: TObject);
var
  SelectedIndex: Integer;
  ipaddress: string;
  CommandData: RecCommandData;

begin
  SelectedIndex := ClientConnectedListBox.ItemIndex;

  if SelectedIndex > -1 then
  begin
    ipaddress := server.Clients[SelectedIndex].ConnectedIP;
    CommandData.command := TButton(Sender).Tag;
    server.SendDataToIPAddress(CommandID, @CommandData, ipaddress);
  end;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  if StartButton.Caption = 'Start' then
  begin
    server.Listen(PortEdit.Text);
    GetPacketTimer.Enabled := True;

    StartButton.Caption := 'Stop';
  end
  else
  begin
    GetPacketTimer.Enabled := False;
    server.Stop;

    StartButton.Caption := 'Start';
  end;
end;

end.
