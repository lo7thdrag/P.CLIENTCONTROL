unit uPacketBuffer;

interface

uses
  Classes, SysUtils, uTCPDatatype;

type

  TPacketBuffer = class
  private
    function GetCount: integer;
  protected
    pLocBuff : PAnsiChar;
    FBuff    : TThreadList;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure PutPacket(p: PAnsiChar; const aSize: Word);
    function GetPacket(var p: PAnsiChar; var aSize: Word): boolean;

    function PeekPacket(const i: integer; var p: PAnsiChar; var aSize: Word): boolean;

    property BuffCount: integer read GetCount;

  end;

implementation

uses
   Windows;


{ TPacketBuffer }
constructor TPacketBuffer.Create;
begin
  FBuff := TThreadList.Create;
end;

destructor TPacketBuffer.Destroy;
begin
  Clear;

  FBuff.Free;
  inherited;
end;

procedure TPacketBuffer.Clear;
var i: integer;
begin
  with FBuff.LockList do
  for i := Count-1 downto 0  do begin
    FreeMem(Items[i]);
    Delete(i);
  end;
  FBuff.UnlockList;
end;

function TPacketBuffer.GetCount: integer;
begin
  Result := FBuff.LockList.Count;
  FBuff.UnlockList;
end;

procedure TPacketBuffer.PutPacket(p: PAnsiChar; const aSize: Word);
var pid: ^TPacketID;
    l : TList;
begin // cause we want to make 'put' faster, we put new quee at the end of list.
  if aSize < SizeOf(TPacketID) then Exit;


  l := FBuff.LockList;
  try
    GetMem(pLocBuff, aSize);
    CopyMemory(pLocBuff, p,  aSize);

    pid := @pLocBuff^;
    pid^.recSize := aSize;

    l.Add(pLocBuff);
  finally
    FBuff.UnlockList;
  end;
end;

function TPacketBuffer.GetPacket(var p: PAnsiChar; var aSize: Word): boolean;
var pid: ^TPacketID;
begin
  with FBuff.LockList do begin
    result := Count > 0;
    if result then begin
      pLocBuff  := Items[0];
      pid       := Items[0];

      aSize     := pid^.recSize;
      GetMem(p, aSize);
      CopyMemory(p, pLocBuff, aSize);
      FreeMem(pLocBuff);
      Delete(0);
    end;
  end;
  FBuff.UnlockList;
end;

function TPacketBuffer.PeekPacket(const i: integer; var p: PAnsiChar; var aSize: Word): boolean;
var pid: ^TPacketID;
begin
  with FBuff.LockList do begin
    result := (i >=0) and (i < Count);

    if result then begin
      p  	:= Items[i];
      pid   := Items[i];
      aSize := pid^.recSize;
    end;
  end;
  FBuff.UnlockList;

end;

end.
