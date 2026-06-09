unit uDataBuffer;
{ Ini gabungan uPacketBuffer dan uPacketRegister.
  Di NetBaseSocket sudah ada TRegisterPacket, packetBuffer ditambahkan di
  kelas turunan TCPServer (buffer per client), TCPClient, atau UDPNode, karena
  kebutuhannya berbeda di tiap turunan.
  JUSTRU karena akan diakses thread lain, PacketRecognizer mestinya dipisah
  dari PacketBuffer. Ide nya, PutPacket dari thread socket,
  PacketRecognize dari thread game, bisa satu atau lebih.
  Digabung di sini selain redundan, juga akan mempersulit akses dari level
  sim manager.
}
interface

uses
  Classes, uTCPDatatype, uPacketRegister;

type
  TOnFinishBuffer = procedure(const b : Boolean) of object;
  {*
    28052013 Dibuat class TDataBuffer oleh farid
    data buffer berfungsi untuk menampung data dari jaringan,yang kemudian akan
    diakses oleh thread lain untuk memproses data yang ada didalam buffer.
  *}
  TDataBuffer = class
  private
    FOnFinishBuffer: TOnFinishBuffer;
    procedure SetOnFinish(const Value: TOnFinishBuffer);
  protected
    pLocBuff : PAnsiChar;
    FBuff    : TThreadList;
    FRegProcs   : TRegisterPacket;
    FLogRecv: TGetStrProc;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure PutPacket(aP: PAnsiChar;
      const aSize: integer; const ipSender: string);

    procedure PacketRecognizer(aP: PAnsiChar;
      const aSize: integer; const ipSender: string);

    function GetPacket(): boolean;

    property RegProcs : TRegisterPacket read FRegProcs write FRegProcs;
    property LogRecv: TGetStrProc read FLogRecv write FLogRecv;
    property OnFinishBuffer: TOnFinishBuffer read FOnFinishBuffer write SetOnFinish;
  end;

implementation

uses
  Windows, SysUtils;
  // uGameData_TTT;   //< GAK BOLEH!, ini base class socket wrapper. networking.
  // debug paket TTT di libTTT, bukan di sini.
  // belajarlah berpikir buat library untuk multi project.

{ TDataBuffer }

procedure TDataBuffer.Clear;
var i: integer;
begin
  with FBuff.LockList do
  for i := Count-1 downto 0  do begin
    FreeMem(Items[i]);
    Delete(i);
  end;
  FBuff.UnlockList;
end;

constructor TDataBuffer.Create;
begin
  FBuff := TThreadList.Create;
end;

destructor TDataBuffer.Destroy;
begin
  Clear;

  FBuff.Free;
  inherited;
end;

function TDataBuffer.GetPacket():Boolean;
var pid: ^TPacketID;
    p: PAnsiChar;
    aSize: Word;
    IPSender : string;
begin
  with FBuff.LockList do begin
//    for i := Count-1 downto 0  do begin
      if Count > 0 then
      begin
        if Assigned(FLogRecv) then
           FLogRecv(TimeStr + ' : Get Count Buffer = ' + IntToStr(Count));

        if Assigned(FOnFinishBuffer) then
          FOnFinishBuffer(Count<=1);
      end;

      Result := Count > 0;
      if Result then
      begin
        pLocBuff  := Items[0];
        pid       := Items[0];

        aSize     := pid^.recSize;
        GetMem(p, aSize);
        CopyMemory(p, pLocBuff, aSize);
        IPSender := LongIp_To_StrIp(pid^.ipSender);
        PacketRecognizer(p, aSize, IPSender); // ambil 1 record, lempar

        FreeMem(pLocBuff);
        Delete(0);
      end;
//    end;
  end;
  FBuff.UnlockList;
end;

procedure TDataBuffer.PacketRecognizer(aP: PAnsiChar; const aSize: integer;
  const ipSender: string);
var pid : ^TPacketID;
    recID: Word;
begin
  pid   := @aP^;
  recID := pid^.recID;

  if FRegProcs.IsHandled(recID) then begin
    if Assigned(FLogRecv) then
       FLogRecv(TimeStr + ': Data ' + FRegProcs[recID].recName);

    //FLogRecv(TimeStr + ': Data ' + getPacketIDname(recID)); // spesific TTT

    FRegProcs[recID].theProc(aP, FRegProcs[recID].recSize);
  end
  else begin
    if Assigned(FLogRecv) then
      FLogRecv(TimeStr + ': ' + 'UnRegistered ID ' + inttostr(recID) );
  end;
end;

procedure TDataBuffer.PutPacket(aP: PAnsiChar;
      const aSize: integer; const ipSender: string);
var pid: ^TPacketID;
    l : TList;
begin
  if aSize < SizeOf(TPacketID) then Exit;

  l := FBuff.LockList;
  try
    GetMem(pLocBuff, aSize);
    CopyMemory(pLocBuff, aP,  aSize);

    pid := @pLocBuff^;
    pid^.recSize := aSize;

    l.Add(pLocBuff);
  finally
    FBuff.UnlockList;
  end;

  if FBuff.LockList.Count > 0 then
  begin
    if Assigned(FLogRecv) then
      FLogRecv(TimeStr + ' : Count Put Buffer = ' + IntToStr(FBuff.LockList.Count));
  end;
end;

procedure TDataBuffer.SetOnFinish(const Value: TOnFinishBuffer);
begin
  FOnFinishBuffer := Value;
end;

end.
