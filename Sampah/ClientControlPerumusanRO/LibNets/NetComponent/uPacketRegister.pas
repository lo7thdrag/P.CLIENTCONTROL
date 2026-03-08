unit uPacketRegister;

interface

uses
  Classes ;
//------------------------------------------------------------------------------
type

  TRegPacketHandlerProc = procedure(apRec: PAnsiChar; aSize: Word) of object;

  TRecRegisterPacket = record
    recSize: Word;
    recName: string[32];
    theProc: TRegPacketHandlerProc;
  end;

  TRegPacketArray = array of TRecRegisterPacket;

//------------------------------------------------------------------------------
  TRegisterPacket = class
  private
    function GetHandler(index: integer): TRecRegisterPacket;
    function GetHandlerCount: Integer;

  protected
    FRegProcs   : TRegPacketArray;
    FRegProcSize: Word;

  public
    constructor Create;
    destructor Destroy; override;

    function IsRegistered(const id: word): Boolean;
    function IsHandled(const id: word): Boolean;

    procedure UnregisterALL;

    procedure RegisterProcedure(const aType, aRecSize: word;
      aProcedure: TRegPacketHandlerProc; const aRecName: string='');

    procedure UnRegisterProcedure(const aType: word);

    property  Handler[index: integer]: TRecRegisterPacket read GetHandler; default;
    property  HandlerCount: Integer read GetHandlerCount;

  end;



implementation

uses
  SysUtils;
//------------------------------------------------------------------------------
{ TRegisterPacket }

constructor TRegisterPacket.Create;
begin
  FRegProcSize := 0;
  SetLength(FRegProcs, 0);

end;

destructor TRegisterPacket.Destroy;
begin
  UnregisterALL; //

  FRegProcSize := 0;
  SetLength(FRegProcs, 0);

end;
function TRegisterPacket.GetHandler(index: integer): TRecRegisterPacket;
begin
  if IsRegistered(index) then
    result := FRegProcs[index];
end;

function TRegisterPacket.GetHandlerCount: Integer;
begin
   result := FRegProcSize;
end;

//------------------------------------------------------------------------------
function TRegisterPacket.IsRegistered(const id: word): Boolean;
begin
  Result := (id < FRegProcSize) and (FRegProcs[id].recSize > 0);
end;

function TRegisterPacket.IsHandled(const id: word): Boolean;
begin
  Result := (id < FRegProcSize)  and Assigned( FRegProcs[id].theProc );
end;

procedure TRegisterPacket.UnregisterALL;
var i: Integer;
begin
  for i :=  FRegProcSize-1 downto 0 do  begin
    FRegProcs[i].recSize := 0;
    FRegProcs[i].theProc := nil;
    FRegProcs[i].recName := '';
  end;

  FRegProcSize := 0;
  SetLength(FRegProcs, 0);
end;

procedure TRegisterPacket.RegisterProcedure(const aType, aRecSize: word;
  aProcedure: TRegPacketHandlerProc; const aRecName: string='');
var i: integer;
begin
  if aType >= FRegProcSize then begin
    SetLength(FRegProcs, aType + 1);

    for i := FRegProcSize to aType-1 do begin
      FRegProcs[i].recSize := 0;
      FRegProcs[i].theProc := nil;
      FRegProcs[i].recName := '';
    end;
    FRegProcSize := aType + 1;

  end;
  FRegProcs[aType].recSize := aRecSize;
  FRegProcs[aType].theProc := aProcedure;

  if aRecName = '' then
    FRegProcs[aType].recName := 'REC'+ IntToStr(aType) +'_SIZE'+IntToStr(aRecSize) ;
end;

procedure TRegisterPacket.UnRegisterProcedure(const aType: word);
begin
  FRegProcs[aType].recSize := 0;
  FRegProcs[aType].theProc := nil;
  FRegProcs[aType].recName := '';
end;

end.
