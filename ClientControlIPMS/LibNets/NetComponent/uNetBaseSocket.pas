unit uNetBaseSocket;

interface

uses

  Classes, SysUtils,  Winsock, OverbyteIcsWSocket, uPacketRegister;

//------------------------------------------------------------------------------

type

//==============================================================================

  TRecIP = record
  case Integer of
    0: (b3, b2, b1, b0: byte);
    1: (longIP: LongWord);
  end;

//==============================================================================
{  TPacketID = record            // 16 byte header
    recSize     : Word;         //    2  size of packet.
    recID       : Word;         //    2  record ID.
    ipSender    : LongWord;     //    4  original sender,
    ipReceiver  : LongWord;     //    4  message destination
    recTime     : LongWord;     //    4  time, recording
  end;
}

//------------------------------------------------------------------------------
  TNetBaseSocket = class
  private
    function getMyHostName: string;
  protected
    WSocket: TWSocket;
    FLogStat,
    FLogSend,
    FLogRecv    : TGetStrProc;
    FRegProcs   : TRegisterPacket;

    FLongXAddress: LongWord;
    FHostName : string;
    FIPLists  : TStrings;

    procedure DefStrLog(const s: string);
    procedure SetStrLog(const index: integer; const Value: TGetStrProc);
    function GetChangeState: TChangeState;  virtual; abstract;
    procedure SetChangeState(const Value: TChangeState); virtual; abstract;
    procedure HandleException(AE: exception; AClient: TWSocket);
    function PrepareSendData(const aID: word; aBuffer: PAnsiChar): Boolean; virtual;
    procedure PacketRecognizer(aP: PAnsiChar;
      const aSize: integer; const ipSender: string); virtual;
    procedure FlushSendData; virtual; abstract;
    property OnStateChange: TChangeState read GetChangeState write SetChangeState;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Thread_Detach; virtual;
    procedure Thread_Attach; virtual;
    procedure ProcessMessages; virtual;
    procedure CloseSocket; virtual;
    procedure RegisterProcedure(const aType: word; aProcedure: TRegPacketHandlerProc;
      const aRecSize: word);
    procedure UnRegisterProcedure(const aType: word);
    procedure UnregisterAllProcedure;
    procedure SendData(const aID: word; aBuffer: PAnsiChar); virtual; abstract;
    property OnGetStatusLog : TGetStrProc index 1 read FLogStat write SetStrLog;
    property OnGetSendLog   : TGetStrProc index 2 read FLogSend write SetStrLog;
    property OnGetRecvLog   : TGetStrProc index 3 read FLogRecv write SetStrLog;
    property MyHostName: string read getMyHostName;
  end;

const

  CSOCK_BUFFER_SIZE = 1024 * 1024;
    CSOCK_DEF_PROTO = 'tcp';

  CSOCK_DEF_PORT = '1809';
  CMAX_PACKET_BYTESIZE = 2;      // 2 byte = 64KB

  HC_RECID_STRING: word = 0;


  function TimeStr: string;
  function DateStr: string;

  function GetHostandIPList(var aHostName: string; ss: TStrings): Boolean;

  function LongIp_To_StrIp(const lIP: LongWord): string;
  function StrIp_To_LongIp(const s: string): LongWord;


  function SockStateToString(const st: TSocketState): string;


implementation

uses
  Windows, Messages, uTCPDataType;
  // uGameData_TTT;   //< GAK BOLEH!, ini base class socket wrapper. networking.
  // debug paket TTT di libTTT, bukan di sini.

//------------------------------------------------------------------------------

{const
  C_SockStatStr :
  array [TSocketState] of string =
   ('InvalidState',
    'Opened' ,
    'Bound',
    'Connecting',
    'SocksConnected',
    'Connected',
    'Accepting',
    'Listening',
    'Closed');
}

function TimeStr: string;
begin
  Result := FormatDateTime('hh:nn:ss.zzz ', now);
end;

function DateStr: string;
begin
  Result := FormatDateTime('dd-mm-yyyy hh:nn:ss ', now);
end;

function LongIp_To_StrIp(const lIP: LongWord): string;
var r: TRecIP;
begin
  r.LongIP := lIp;
  Result := Format('%d.%d.%d.%d', [r.b3, r.b2, r.b1, r.b0]);
end;

function StrIp_To_LongIp(const s: string): LongWord;
//const
//    digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var
  digits : set of AnsiChar;
  i, j, l: integer;
  b: array[0..3] of Byte;
  c: byte;
  cp : string;
begin
  FillChar(result, 4, 0);
  digits := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  l := Length(s);
  i := 1;
  c := 0;
  cp := '';

  while i <= l do
  begin
    if s[i] <> '.' then
    begin
      if CharInSet(s[i], digits) then //s[i] in digits then
        cp := cp + s[i]
      else
        Exit;
    end
    else
    begin //get .
      j := StrToInt(cp);
      if j > 255 then
        exit;
      if j < 0 then
        exit;

      b[c] := j;
      cp := '';
      Inc(c);
    end;

    Inc(i);
  end;
  if (cp <> '') then
  begin
    j := StrToInt(cp);
    if j > 255 then
      exit;
    if j < 0 then
      exit;

    b[c] := StrToInt(cp)
  end
  else exit;

  Move(b, Result, 4);
end;

//------------------------------------------------------------------------------

function GetHostandIPList(var aHostName: string; ss: TStrings): Boolean;
type
  TArrayPInAddr = array[0..10] of PInAddr;
  PArrayPInAddr = ^TArrayPInAddr;
var i: integer;
  pHe: PHostEnt;
  ptrPA: PArrayPInAddr;
  pBuffer : PAnsiChar;
  WSAData: TWSAData;
  ipAddr: string;
begin
  result := false;

  if WSAStartup($0002, WSAData) <> 0 then
    exit;

  GetMem(pBuffer, 64);

  GetHostName(pBuffer, 64);
  pHe := GetHostByName(pBuffer);

  if pHe = nil then
    exit;

  aHostName := string(pBuffer);
  ss.Clear;

  PtrPA := PArrayPInAddr(PHe^.h_addr_list);
  i := 0;
  while PtrPA^[i] <> nil do begin
    iPaddr := string(inet_ntoa(ptrPA^[i]^));
    ss.Add(ipAddr);
    inc(i);
  end;
  result := True;
  WSACleanup;
end;

function SockStateToString(const st: TSocketState): string;
begin
  Result :=  C_SockStatStr[st];
end;

//==============================================================================
{ TTCP_Socket }

constructor TNetBaseSocket.Create;
begin
  FLogStat  := DefStrLog;
  FLogSend  := DefStrLog;
  FLogRecv  := DefStrLog;

  FRegProcs := TRegisterPacket.Create;

  FIPLists := TStringList.Create;
  GetHostandIPList(FHostName, FIPLists );

end;

destructor TNetBaseSocket.Destroy;
begin
  FRegProcs.Free;
  FIPLists.Free;

  inherited;
end;

function TNetBaseSocket.getMyHostName: string;
var i: integer;
begin
  i := Length(FHostName);
  if i > 32 then
    result := Copy(FHostName, 1, 32)
  else
    result := FHostName;
end;

procedure TNetBaseSocket.DefStrLog(const s: string);
begin
// do nothing
//  LogFile_net(s);
end;

procedure TNetBaseSocket.HandleException(AE: exception; AClient: TWSocket);
begin
  if (AE is ESocketException) then begin
    FLogStat(TimeStr + '  Error : ' + AClient.Addr +  AE.Message);
    AClient.Close;
  end
  else begin
    FLogStat(TimeStr + ': Unhandled exception raised!');
  end;
end;

procedure TNetBaseSocket.SetStrLog(const index: Integer; const Value: TGetStrProc);
var x: TGetStrProc;
begin
  if not Assigned(Value) then
    x := DefStrLog
  else
    x := Value;
  case index of
    1: FLogStat   := x;
    2: FLogSend   := x;
    3: FLogRecv   := x;
  end;
end;

procedure TNetBaseSocket.RegisterProcedure(const aType: word;
  aProcedure: TRegPacketHandlerProc; const aRecSize: word);
begin
  FRegProcs.RegisterProcedure(aType, aRecSize, aProcedure);
end;

procedure TNetBaseSocket.UnRegisterProcedure(const aType: word);
begin
  FRegProcs.UnRegisterProcedure(aType);
end;

procedure TNetBaseSocket.UnregisterAllProcedure;
begin
  FRegProcs.UnregisterALL;
end;

function TNetBaseSocket.PrepareSendData(const aID: word;
  aBuffer: PAnsiChar): Boolean;
var pid: ^TPacketID;
begin
  result := FRegProcs.IsRegistered(aID);
  if Result then  begin
    pid   := @aBuffer^;
    pid^.recSize   := FRegProcs[aID].recSize;
    pid^.recID     := aID;
  end;
end;

procedure TNetBaseSocket.Thread_Attach;
begin
  WSocket.ThreadAttach;
end;

procedure TNetBaseSocket.Thread_Detach;
begin
  WSocket.ThreadDetach;
end;

procedure TNetBaseSocket.ProcessMessages;
begin
  Wsocket.ProcessMessages;
end;

procedure TNetBaseSocket.CloseSocket;
begin
  PostMessage(WSocket.Handle, WM_QUIT, 0, 0);
end;

procedure TNetBaseSocket.PacketRecognizer(aP: PAnsiChar; const aSize: integer;
  const ipSender: string);
var pid : ^TPacketID;
    recID: Word;
begin
  pid   := @aP^;
  recID := pid^.recID;

  if FRegProcs.IsHandled(recID) then begin
    FLogRecv(TimeStr + ': Data ' + FRegProcs[recID].recName);
//    FLogRecv(TimeStr + ': Data ' + getPacketIDname(recID));
    FRegProcs[recID].theProc(aP, FRegProcs[recID].recSize);
  end
  else
    FLogRecv(TimeStr + ': ' + 'UnRegistered ID ' + inttostr(recID) );
end;

end.

