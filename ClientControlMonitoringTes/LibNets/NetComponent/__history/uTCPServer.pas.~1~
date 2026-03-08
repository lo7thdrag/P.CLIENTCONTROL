unit uTCPServer;

interface

uses
  Classes, SysUtils, OverbyteIcsWSocket, OverbyteIcsWSocketS,
  uNetBaseSocket, uTCPDataType, uDataBuffer;

type

//==============================================================================
  TClientConnected = class(TWSocketClient)
  private
    FBuffer   : PAnsiChar;
    FBufferNow: LongWord;
  public
    ConnectedIP: string;
    ConnectTime: TDateTime;
  end;
//==============================================================================

  TTCPServer = class(TNetBaseSocket)
  private
    FOnClient_Connect   : TGetStrProc;
    FOnClient_DisConnect: TGetStrProc;
    FOnSvrChangeState: TChangeState;

//    FLongXAddress: Longword;

    {*tambahan farid 28052013 untuk buffer data yang diterima dari jaringan.
    sebelum data diproses oleh server,data dibuffer dulu untuk menghindari
     penumpukan data didalam buffernya ics*}
    FDataBuffer : TDataBuffer;
    FLongXAddress: Longword;
    FLogData: TGetStrProc; //tambahan dari farid

    function getClientCount: Integer;
    function getClientConnected(i: Integer): TClientConnected;
    procedure SetData(const Value: TGetStrProc);
  protected
    FIPIndex    : TStringList;
    WSockServer : TWSocketServer;

    function GetChangeState: TChangeState; override;
    procedure SetChangeState(const Value: TChangeState);override;

    procedure WSockServer_OnChangeState(Sender: TObject;
              OldState, NewState : TSocketState);
    procedure WSockServer_OnClientConnect(Sender: TObject; Client: TWSocketClient; Error: Word);
    procedure WSockServer_OnClientDisconnect(Sender: TObject; Client: TWSocketClient; Error: Word);

    procedure Client_OnDataAvailable(Sender: TObject; Error: Word);
    procedure Client_OnBGException(Sender: TObject; E: Exception; var CanClose: Boolean);

    function PrepareSendData(const aID: word; aBuffer: PAnsiChar): Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Listen(aPort: string);
    procedure Stop;

    procedure SendData(const aID: word; aBuffer: PAnsiChar); override;
    procedure SendDataExceptThis(const aID: word; aBuffer: PAnsiChar; const ipExcept: string);
    procedure SendDataToIPAddress(const aID: word; aBuffer: PAnsiChar; const ipAdd: string);

    procedure FlushSendData; override;
    procedure GetConnectedList(var ss: TStringList);

    procedure getPacket;

    property OnClient_Connect: TGetStrProc read FOnClient_Connect
      write FOnClient_Connect;
    property OnClient_DisConnect: TGetStrProc read FOnClient_DisConnect
      write FOnClient_DisConnect;

    property OnStateChange;
    property ClientCount: Integer read getClientCount;
    property Clients[i: Integer]: TClientConnected read getClientConnected;
    property LongIP: Longword read FLongXAddress;

    property OnlogRecv: TGetStrProc read FLogData write SetData;
  end;

implementation

{ TTCPServer }

uses
  Windows, Messages;
{
procedure CopyMemory(Destination: Pointer; Source: Pointer; Length: LongWord);
begin
  Move(Source^, Destination^, Length);
end;
}
constructor TTCPServer.Create;
begin
  inherited;

  WSockServer := TWSocketServer.Create(nil);
  WSocket     := WSockServer;


//  WSockServer.MultiThreaded := True;
  WSockServer.MultiThreaded := False;
  WSockServer.OnChangeState := WSockServer_OnChangeState;


  FIPIndex := TStringList.Create;
  FIPIndex.Sorted := True;
  FIPIndex.Duplicates  := dupAccept;

  //tambahan farid 28052013
  FDataBuffer := TDataBuffer.Create;
  FDataBuffer.RegProcs := FRegProcs;
end;

destructor TTCPServer.Destroy;
begin
  FIPIndex.Clear;
  FIPIndex.Free;

  WSocket := nil;
  WSockServer.Free;
  WSockServer := nil;

  //tambahan farid 28052013
  FDataBuffer.Free;
  inherited;
end;

procedure TTCPServer.SetChangeState(const Value: TChangeState);
begin
//  WSockServer.OnChangeState := Value;
  FOnSvrChangeState := Value;
end;

procedure TTCPServer.SetData(const Value: TGetStrProc);
begin
  FLogData := Value;
  FDataBuffer.LogRecv := Value;
end;

function TTCPServer.GetChangeState: TChangeState;
begin
 // Result := WSockServer.OnChangeState;
  result := FOnSvrChangeState;
end;

procedure TTCPServer.WSockServer_OnChangeState(Sender: TObject;
                                 OldState, NewState : TSocketState);
begin
{  if NewState = wsListening then begin
    FLongXAddress := StrIp_To_LongIp(WSockServer.LocalAddr);

  end;
}
  if Assigned(FOnSvrChangeState) then
    FOnSvrChangeState(sender,  OldState, NewState);

end;

procedure TTCPServer.Listen(aPort: string);
begin
  if WSockServer.State = wsClosed then begin
    WSockServer.OnClientConnect     := WSockServer_OnClientConnect;
    WSockServer.OnClientDisconnect  := WSockServer_OnClientDisconnect;

    WSockServer.Proto := CSOCK_DEF_PROTO;
    WSockServer.Port := aPort;
    WSockServer.Addr := '0.0.0.0';

    WSockServer.LineMode := False;
    WSockServer.LineEdit := False;
    WSockServer.LineEcho := False;

    WSockServer.ClientClass := TClientConnected;
    WSockServer.Banner := '';
    WSockServer.Listen;

    FLongXAddress := StrIp_To_LongIp(WSockServer.LocalAddr);


    FLogStat(DateStr + ': ' + 'Server Listening at port ' + aPort);
    FLogStat('addr : ' + WSockServer.Addr);
    FLogStat('local :' + WSockServer.LocalAddr);
    FLogStat('x addr' + WSockServer.GetXAddr);
  end;
end;

procedure TTCPServer.Stop;
var i: Integer;
    cClient: TWSocketClient;
begin
  for i := 0 to WSockServer.ClientCount - 1 do begin
    cClient := WSockServer.Client[i];
    if cClient.State <> wsClosed then
      cClient.Close;
  end;
  WSockServer.Close;

  WSockServer.OnClientConnect     := nil;
  WSockServer.OnClientDisconnect  := nil;

  FDataBuffer.Clear;

  FLogStat(DateStr + ': ' + 'Server stopped');
end;

function TTCPServer.PrepareSendData(const aID: word; aBuffer: PAnsiChar): Boolean;
begin
  result :=  inherited PrepareSendData(aID, aBuffer);

end;

procedure TTCPServer.SendData(const aID: word; aBuffer: PAnsiChar);
var pSize: word;
    i: integer;
    cCon: TClientConnected;
    strTemp: string;
begin
  if WSockServer.ClientCount <= 0 then Exit;

  if not PrepareSendData(aID, aBuffer) then begin
    FLogSend(TimeStr + ': Unregistered Packet ID ' + inttostr(aID));
    Exit;
  end;

  pSize := FRegProcs[aID].recSize;
  strTemp := 'Send ALL: ID ' + IntToStr(aID) + IntToStr(psize) + ' byte ';

  for i := WSockServer.ClientCount - 1 downto 0 do begin
    cCon := TClientConnected(WSockServer.Client[i]);

    if (cCon <> nil) and (cCon.State = wsConnected) then begin

//      if not cCon.AllSent then
//        cCon.Flush;

      FLogSend(TimeStr + ': ' + strTemp + ', to: ' + cCon.ConnectedIP);
      try
        cCon.Send(aBuffer, pSize);
      except
        on e: exception do HandleException(e, cCon);
      end; //end exception
    end;
  end;
end;

procedure TTCPServer.SendDataExceptThis(const aID: word; aBuffer: PAnsiChar;
  const ipExcept: string);
var pSize: word;
    i: integer;
    cCon: TClientConnected;
    strTemp: string;
begin
  if WSockServer.ClientCount <= 0 then exit;

  if not PrepareSendData(aID, aBuffer) then begin
    FLogSend(TimeStr + ': Unregistered Packet ID ' + inttostr(aID));
    Exit;
  end;

  pSize := FRegProcs[aID].recSize;

  strTemp := 'Send: ID ' + inttostr(aID) + ' EXCEPT ' + ipExcept;

  for i := 0 to WSockServer.ClientCount - 1 do begin
    cCon := TClientConnected(WSockServer.Client[i]);

    if (cCon <> nil) and
      (cCon.ConnectedIP <> ipExcept) and
      (cCon.State = wsConnected) then begin

      if not cCon.AllSent then
        cCon.Flush;

      FLogSend(TimeStr + ': ' + strTemp + ', to: ' + cCon.ConnectedIP);
      try
        cCon.Send(aBuffer, psize);
      except
        on e: exception do HandleException(e, cCon);
      end; //end exception
    end;
  end;
end;

procedure TTCPServer.SendDataToIPAddress(const aID: word; aBuffer: PAnsiChar;
  const ipAdd: string);
var psize: word;
    i: integer;
    cCon: TClientConnected;
begin
  // gimana klo ada multiple connection dari ip address yg sama?
  // kirim ke semua..

  if not PrepareSendData(aID, aBuffer) then begin
    FLogSend(TimeStr + ': Unregistered Packet ID ' + inttostr(aID));
    Exit;
  end;
  pSize := FRegProcs[aID].recSize;

  if not FIPIndex.Find(ipAdd, i) then begin
    FLogSend(TimeStr + ': ' + ipAdd + ' not connected');
    Exit;
  end;

  for i := 0 to FIPIndex.Count - 1 do begin
    cCon := TClientConnected(FIPIndex.Objects[i]);
//    if (cCon = nil) then continue; delete ?
    if (cCon.PeerAddr = ipAdd) and (cCon.State = wsConnected) then begin
      FLogSend(TimeStr + ':ID ' + IntToStr(aID) + ' to: ' + cCon.ConnectedIP);
      try
        cCon.Send(aBuffer, pSize);
      except
        on e: exception do HandleException(e, cCon);
      end; //end exception

    end;
  end;

end;

procedure TTCPServer.WSockServer_OnClientConnect(Sender: TObject; Client: TWSocketClient;
  Error: Word);
var cCon: TClientConnected;
  ipAdd: string;
begin
  cCon := TClientConnected(Client);
  GetMem(cCon.FBuffer, CSOCK_BUFFER_SIZE);

  with cCon do begin
    FBufferNow := 0;

    LineMode        := False;
    LineEdit        := False;
    LineEcho        := False;
    OnDataAvailable := Client_OnDataAvailable;
    OnBgException   := Client_OnBgException;
    ConnectTime     := Now;
  end;

  ipAdd             := cCon.PeerAddr;
  cCon.ConnectedIP  := ipAdd;

  FIPIndex.AddObject(ipAdd, cCon);

  if Assigned(FOnClient_Connect) then
    FOnClient_Connect(ipAdd);

  FLogStat(TimeStr + ': ' + 'Connection from ' + ipAdd + ':' + cCon.PeerPort);
end;

procedure TTCPServer.WSockServer_OnClientDisconnect(Sender: TObject;
  Client: TWSocketClient; Error: Word);
var cCon: TClientConnected;
  ipAdd: string;
  i: Integer;
begin
  cCon := TClientConnected(Client);

  ipAdd := cCon.PeerAddr;

  i := FIPIndex.IndexOfObject(cCon);
  if i >= 0 then
    FIPIndex.Delete(i);

  if Assigned(FOnClient_DisConnect) then
    FOnClient_DisConnect(ipAdd);

  FreeMem(cCon.FBuffer);
  FLogStat(TimeStr + ': ' + 'Disconnecting ' + ipAdd + ':' + cCon.PeerPort +
    ', duration: ' + FormatDateTime('hh:nn:ss', Now - cCon.ConnectTime));

end;

procedure TTCPServer.Client_OnBGException(Sender: TObject; E: Exception;
  var CanClose: Boolean);
begin
  FLogStat(TimeStr + ': ' + 'Client exception occured: ' + E.ClassName + ': ' + E.Message);
  CanClose := True;
end;

procedure TTCPServer.Client_OnDataAvailable(Sender: TObject; Error: Word);
var
  lbuffer: PAnsiChar;
  receivedByte, readByte: integer;
  p: pointer;
  findRec: boolean;
  pSize : ^Word;
  recSize: Integer;
  ipSend : string;
  bCount: Integer;
  cCon: TClientConnected;
begin
  if Assigned(FLogData) then
    FLogData('Error Code : ' + IntToStr(Error));

  if Error <> 0 then Exit;  //tambahan dari farid

  cCon := TClientConnected(Sender);
  ipSend := cCon.PeerAddr;

  receivedByte := cCon.RcvdCount;
//  Number of characters in receive buffer but not read yet.

  if receivedByte < 1 then exit;
  FLogRecv(TimeStr + ': ' + inttostr(receivedByte));

  GetMem(lbuffer, receivedByte + 1);
  readByte := TWSocket(Sender).Receive(lbuffer, receivedByte);

  if readByte < 1 then exit;

  p := cCon.FBuffer + cCon.FBufferNow;
  CopyMemory(PAnsiChar(p), lbuffer, readByte);
  Inc(cCon.FBufferNow, readByte);

  p := cCon.FBuffer;
  bCount   := cCon.FBufferNow;
  findRec  := true;
  while findRec and (bCount >= CMAX_PACKET_BYTESIZE) do begin
    pSize   := p;
    recSize := pSize^;
    findRec := bCount >= recSize;
    if (findRec) then begin
//      PacketRecognizer(p, recSize, cCon.ConnectedIP); // ambil 1 record, lempar.

      FDataBuffer.PutPacket(p, recSize, cCon.ConnectedIP); // ambil 1 record, lempar.
      bCount := bCount - recSize;
      p := pByte(Integer(p) + recSize);
    end;
  end;

  if bCount > 0  then  begin
    CopyMemory(cCon.FBuffer, p, bCount); // geser data ke awal FBuffer
  end;
  cCon.FBufferNow := bCount;

  FreeMem(lbuffer);
end;


function TTCPServer.getClientConnected(i: Integer): TClientConnected;
begin
  if i < WSockServer.ClientCount then
    Result := WSockServer.Client[i] as TClientConnected
  else
    Result := nil;
end;

function TTCPServer.getClientCount: Integer;
begin
// kalo pakai WSockServer.ClientCount, waktu event client onDisconnect
// client yg sedang OnDisconnect masih dihitung.
// Result := WSockServer.ClientCount;

  Result := FIPIndex.Count;
end;



procedure TTCPServer.FlushSendData;
var i: integer;
    cCon: TClientConnected;
begin

  for i := 0 to WSockServer.ClientCount - 1 do begin
    cCon := TClientConnected(WSockServer.Client[i]);

    if (cCon <> nil) and (cCon.State = wsConnected) then begin

      if not cCon.AllSent then begin
        FLogSend(TimeStr + ': flush  ' + cCon.ConnectedIP);
        cCon.Flush;
      end;
    end;
  end;
end;

procedure TTCPServer.GetConnectedList(var ss: TStringList);
var i: integer;
    cCon: TClientConnected;
begin
  if not Assigned(ss) then
    ss := TStringList.Create;

  ss.Clear;

//  ss.AddStrings(FIPIndex);
  for i := 0 to WSockServer.ClientCount - 1 do begin
    cCon := TClientConnected(WSockServer.Client[i]);

    if (cCon <> nil) and (cCon.State = wsConnected) then begin
      ss.Add(cCon.PeerAddr);
    end;
  end;
end;

procedure TTCPServer.getPacket;
begin
  FDataBuffer.GetPacket;
end;

end.

