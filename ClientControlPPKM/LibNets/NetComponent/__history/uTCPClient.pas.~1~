unit uTCPClient;

interface

uses
  OverbyteIcsWSocket, Classes, SysUtils,
  uNetBaseSocket, uTCPDataType, uDataBuffer;

type
  TOnFinishBuffer = procedure(const b : Boolean) of object;

//==============================================================================
  TTCPClient = class(TNetBaseSocket)
  private
    {*tambahan farid 28052013 untuk buffer data yang diterima dari jaringan.
    sebelum data diproses oleh client,data dibuffer dulu untuk menghindari
     penumpukan data didalam buffernya ics*}
    FDataBuffer : TDataBuffer;
    FLongXAddress: LongWord;
    FLogData: TGetStrProc;
    FOnFinishBuffer: TOnFinishBuffer;
    function getConnected: boolean;
    procedure SetLogData(const Value: TGetStrProc);
    procedure SetOnFinish(const Value: TOnFinishBuffer);

  protected
    FBuffer   : PAnsiChar;
    FBufferNow: LongWord;

    FOnConnected    : TNotifyEvent;
    FOnDisConnected : TNotifyEvent;

    function GetChangeState: TChangeState; override;
    procedure SetChangeState(const Value: TChangeState);override;

    function getState: TSocketState;

    procedure WSocket_OnDataAvailable(Sender: TObject; Error: Word);
    procedure WSocket_OnSessionConnected(Sender: TObject; Error: Word);
    procedure WSocket_OnSessionClosed(Sender: TObject; Error: Word);
    procedure WSocket_OnSessionAvailable(Sender: TObject; Error: Word);


    procedure WSocket_OnDataSent(Sender: TObject; Error: word);

    function PrepareSendData(const aID: word; aBuffer: PAnsiChar): Boolean; override;
  public

    constructor Create;
    destructor Destroy; override;

    procedure Connect(aAddr, aPort: string);
    procedure Disconnect;

    procedure SendData(const aID: word; aBuffer: PAnsiChar); override;
    procedure FlushSendData; override;

  public
    procedure GetPacket();

    property Connected: boolean read getConnected;
    property State: TSocketState read getState;

    property OnStateChange;
    property MyLongIP: LongWord read FLongXAddress;

    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisConnected: TNotifyEvent read FOnDisConnected write FOnDisConnected;

    property OnlogRecv: TGetStrProc read FLogData write SetLogData;
    property OnFinishBuffer: TOnFinishBuffer read FOnFinishBuffer write SetOnFinish;

  end;

implementation

uses
  Windows, Messages, uGameData_TTT;
{
procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: LongWord);
begin
  Move(Source^, Destination^, Length);
end;
}
{ TTCPClient }

constructor TTCPClient.Create;
begin
  inherited;

  GetMem(FBuffer, CSOCK_BUFFER_SIZE);

  WSocket := TWSocket.Create(nil);
{  WSocket.MultiThreaded := true;
  WSocket.ThreadDetach;
}
  WSocket.OnDataSent          := WSocket_OnDataSent;
  WSocket.OnSessionConnected  := WSocket_OnSessionConnected;
  WSocket.OnSessionClosed     := WSocket_OnSessionClosed;

  //tambahan farid
  FDataBuffer := TDataBuffer.Create;
  FDataBuffer.RegProcs := FRegProcs;
end;

destructor TTCPClient.Destroy;
begin
  WSocket.OnDataSent := nil;
  CloseSocket;
  WSocket.Free;
  WSocket := nil;

  FreeMem(FBuffer);

  FDataBuffer.Clear;
//  FDataBuffer.Free;

  inherited;
end;

procedure TTCPClient.Connect(aAddr, aPort: string);
begin
  if (WSocket.State <> wsConnected) and (WSocket.State <> wsConnecting) then begin
    FBufferNow  := 0;

    WSocket.OnDataAvailable := WSocket_OnDataAvailable;
    WSocket.Proto := CSOCK_DEF_PROTO;

    WSocket.LineMode  := False;
    WSocket.LineEdit  := False;
    WSocket.LineEcho  := False;
    WSocket.Port      := aPort;
    WSocket.Addr      := aAddr;

    FLogStat(DateStr + ': ' + 'Connecting to ' + aAddr + ' port ' + aPort);

    WSocket.Connect;
  end;
end;

procedure TTCPClient.Disconnect;
begin
  FLogStat(DateStr + ': ' + 'Disconnecting ...');
  WSocket.OnDataAvailable := nil;

  WSocket.Close;
end;

procedure TTCPClient.sendData(const aID: word; aBuffer: PAnsiChar);
var pSize: word;
    pid : ^TPacketID;
begin
  if not PrepareSendData(aID, aBuffer) then begin
    FLogSend(TimeStr + ': Unregistered Packet ID ' + inttostr(aID));
    Exit;
  end;
  pid := @aBuffer^;
  pid.ipSender := FLongXAddress;

  if WSocket.State = wsConnected then begin
    if not WSocket.AllSent then begin
      FLogSend(TimeStr + ': flush!');
      WSocket.Flush;

    end;

    pSize :=  FRegProcs[aID].recSize;

    FLogSend(TimeStr + ': Send id ' + IntToStr(aID) + ' -  ' + IntToStr(pSize)  + ' byte' );
    try
      WSocket.Send(aBuffer, pSize);
    except
      on e: exception do HandleException(e, WSocket);
    end; //end exception

  end;
end;

procedure TTCPClient.WSocket_OnSessionConnected(Sender: TObject; Error: Word);
var s: string;
begin
  if WSocket.State = wsConnected then begin
     try
       s := WSocket.PeerAddr;
     except
       on ESocketException do begin
         exit;
       end;
     end;

       // connect temenan rek..

    s := WSocket.GetXAddr;
    FLongXAddress := StrIp_To_LongIp(s);

    if Assigned(FOnConnected) then
      FOnConnected(self);

    FLogStat(TimeStr + ': ' + 'Connected to ' + s);
  end;
end;

procedure TTCPClient.WSocket_OnSessionClosed(Sender: TObject; Error: Word);
var s: string;
begin
  s := TimeStr + ': ' + 'DisConnected from ' +LongIp_To_StrIp(FLongXAddress);

  FLongXAddress := 0;

  if Assigned(FOnDisConnected) then
    FOnDisConnected(self);

  FLogStat(s);
end;

procedure TTCPClient.WSocket_OnSessionAvailable(Sender: TObject; Error: Word);
var s: string;
begin
  if WSocket.State = wsConnected then begin
    s := WSocket.GetXAddr;
    FLongXAddress := StrIp_To_LongIp(s);

    FLogStat(TimeStr + ': ' + 'available ' + s);
  end;

end;

procedure TTCPClient.WSocket_OnDataAvailable(Sender: TObject; Error: Word);
var
  lbuffer: PAnsiChar;
  receivedByte, readByte: integer;
  p: pointer;
  findRec: boolean;
  pSize : ^Word;
  bCount,
  recSize: Integer;
  svrIP : string;

begin
  if Error <> 0 then Exit;

  receivedByte := TWSocket(Sender).RcvdCount;
//  Number of characters in receive buffer but not read yet.

  if receivedByte < 1 then exit;
  FLogRecv(TimeStr + ': ' + inttostr(receivedByte));

  GetMem(lbuffer, receivedByte + 1);
  readByte := TWSocket(Sender).Receive(lbuffer, receivedByte);

  if readByte < 1 then exit;
  svrIP := TWSocket(Sender).Addr;

  p := FBuffer + FBufferNow;
  CopyMemory(PAnsiChar(p), lbuffer, readByte);
  inc(FBufferNow, readByte);

  p := FBuffer;
  bCount   := FBufferNow;
  findRec  := true;

  while findRec and (bCount >= CMAX_PACKET_BYTESIZE) do begin
    pSize   := p;
    recSize := pSize^;
    findRec := bCount >= recSize;
    if (findRec) then begin
//      PacketRecognizer(p, recSize, svrIP);

      FDataBuffer.PutPacket(p, recSize, svrIP); // ambil 1 record, lempar.
      bCount := bCount - recSize;
      p := pByte( Integer(p) + recSize);
    end;
  end;

  if bCount > 0  then  begin
    CopyMemory(FBuffer, p, bCount);
  end;
  FBufferNow := bCount;

  FreeMem(lbuffer);
end;

function TTCPClient.getState: TSocketState;
begin
  result := WSocket.State;
end;

procedure TTCPClient.WSocket_OnDataSent(Sender: TObject; Error: word);
begin
  if Error = 0 then
    FLogSend('Data sent: ')
  else
    FLogSend('Data sent Error : ' + inttostr(Error));
end;

function TTCPClient.getConnected: boolean;
begin
  Result := WSocket.State = wsConnected;
end;

procedure TTCPClient.GetPacket;
begin
  FDataBuffer.GetPacket;
end;

function TTCPClient.GetChangeState: TChangeState;
begin
  Result :=  WSocket.OnChangeState;
end;

procedure TTCPClient.SetChangeState(const Value: TChangeState);
begin
  WSocket.OnChangeState := Value;
end;

procedure TTCPClient.SetLogData(const Value: TGetStrProc);
begin
  FLogData := Value;
  FDataBuffer.LogRecv := Value;
end;

procedure TTCPClient.SetOnFinish(const Value: TOnFinishBuffer);
begin
  FOnFinishBuffer := Value;
  FDataBuffer.OnFinishBuffer := Value;
end;

procedure TTCPClient.FlushSendData;
begin
  if (WSocket.State = wsConnected) and not  WSocket.AllSent then begin
    WSocket.Flush;
  end;
end;

function TTCPClient.PrepareSendData(const aID: word; aBuffer: PAnsiChar): Boolean;
var pid: ^TPacketID;
begin

  Result := inherited PrepareSendData(aID, aBuffer);
  if Result then begin
    pid   := @aBuffer^;
    pid.ipSender := MyLongIP;
  end;
end;

end.

