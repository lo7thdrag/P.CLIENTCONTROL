unit uTCPDatatype;

{ editlog

  2022 / 07/ 22 andy:
    - upgrade ICS ke versi 8.58

}

interface

uses

  Classes, SysUtils,  Winsock, OverbyteIcsWSocket;

//------------------------------------------------------------------------------

type


//==============================================================================
  TPacketID = record            // 16 byte header
    recSize     : Word;         //    2  size of packet.
    recID       : Word;         //    2  record ID.
    ipSender    : LongWord;     //    4  original sender,
    ipReceiver  : LongWord;     //    4  message destination
    recTime     : LongWord;     //    4  time, recording
  end;

{  TPacketAddr  = record
    ipSender    : LongWord;     //    4  original sender,
    ipReceiver  : LongWord;     //    4  message destination
    recTime     : LongWord;     //    4  time, recording
  end;
}


//------------------------------------------------------------------------------

const

  CSOCK_BUFFER_SIZE = 1024 * 1024;
    CSOCK_DEF_PROTO = 'tcp';

  CSOCK_DEF_PORT = '1809';
  CMAX_PACKET_BYTESIZE = 2;      // 2 byte = 64KB
  HC_RECID_STRING: word = 0;

  C_SockStatStr :
  array [TSocketState] of shortstring =
   ('InvalidState',
    'Opened' ,
    'Bound',
    'Connecting',
    'SocksConnected',
    'Connected',
    'Accepting',
    'Listening',
    'Closed',
    'DNS Lookup'); { V8.48 added DnsLookup }



  function TimeStr: string;
  function DateStr: string;

  function GetHostandIPList(var aHostName: string; ss: TStrings): Boolean;

  function LongIp_To_StrIp(const lIP: LongWord): string;
  function StrIp_To_LongIp(const s: string): LongWord;

  function SockStateToString(const st: TSocketState): string;


implementation

uses
  Windows, Messages;

//------------------------------------------------------------------------------
type

  TRecIP = record
  case Integer of
    0: (b3, b2, b1, b0: byte);
    1: (longIP: LongWord);
  end;

//const


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
  try
    Result := Format('%d.%d.%d.%d', [r.b3, r.b2, r.b1, r.b0]);
  except
    Result := '0.0.0.0';
  end;
end;

function StrIp_To_LongIp(const s: string): LongWord;
//const
//    digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var
  digits : set of AnsiChar;
  i, j, l : integer;
  b : array[0..3] of Byte;
  c : byte;
  cp : string;
begin
  digits := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  FillChar(result, 4, 0);

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
    else begin //get .
      j := StrToInt(cp);
      if j > 255 then exit;
      if j < 0 then exit;

      b[c] := j;
      cp := '';
      Inc(c);
    end;

    Inc(i);
  end;
  if (cp <> '') then
  begin
    j := StrToInt(cp);
    if j > 255 then exit;
    if j < 0 then exit;

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

end.

