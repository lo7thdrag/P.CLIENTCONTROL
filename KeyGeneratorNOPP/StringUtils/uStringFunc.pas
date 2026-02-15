unit uStringFunc;

interface

uses
  Classes;

  function ConvFloatToStr(const flt: double):string;
  function ConvStrToFloat(const str: string): double;

  function SeparateString(const s: string; del: char; var s1, s2: string): boolean;
  procedure SplitString(const s: string; const del: Char;  var ss: TStringList);

  function ConvertStringToFloat(const s: string): double;
  function ConvertStringToInt(const s: string): integer;

  function LimitStr(const sNew: string; const sz: Byte=16): string;
  function MakeValidIdent(var Ident: string): Boolean;

  procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);

  function RightStr(Const Str: String; Size: Word): String;

  function MidStr(Const Str: String; From, Size: Word): String;

  function LeftStr(Const Str: String; Size: Word): String;

  procedure Slice(const aStr : string;const low, high : integer; var aStr2 : string);

  procedure StringListCompare(const aStrs1, aStrs2 :TStrings;
        var aStrsEqual, aStrsIn_1_Only, aStrsIn_2_Only: TStrings;
        const aSort: boolean= false);

  function DeleteAmpersand(Value: string): string;


implementation

uses
  SysUtils;

function ConvFloatToStr(const flt: double):string;
var fs :TFormatSettings;
begin
  fs.ThousandSeparator := ',';
  fs.DecimalSeparator := '.';
  result := FloatToStr(flt, fs);
end;

function ConvStrToFloat(const str: string): double;
var fs :TFormatSettings;
begin
  result := 0;

  if not TryStrToFloat(str, result) then begin
    fs.ThousandSeparator := ',';
    fs.DecimalSeparator := '.';

    TryStrToFloat(str, Result, fs);
  end;

end;


//==============================================================================
function SeparateString(const s: string; del: char; var s1, s2: string): boolean;
  // left and right part must exist.
var
  i, l: integer;
begin
  result := false;
  l := Length(s);
  i := Pos(del, s);
  if (l < 2) or (i < 1) then exit;

  s1 := Copy(s, 1, i - 1);
  s2 := Copy(s, i + 1, l - i);

  s1 := Trim(s1);
  s2 := Trim(s2);
  result := (s1 <> '') and (s2 <> '');

end;

//==============================================================================
procedure SplitString(const s: string; const del: Char;  var ss: TStringList);
begin
  if not Assigned(ss) then
    ss := TStringList.Create;

  ss.Delimiter := del;
  ss.DelimitedText := s;
end;

{
procedure SplitStr(const s:string; const ach: Char;  var ss:TStrings);
var i: integer;
    st:string;
begin
  i:=1; st:='';
  while i<=length(s) do begin
    if s[i]= ach then  begin
      ss.Add(st);
      st:='';
    end
    else
      st:=st+s[i];
    inc(i)
  end;
  if st <> '' then
     ss.Add(st);
end;
}
{function IsValidFloat(const s: string): boolean;
const CNum = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      CSign = ['+', '-'];
var l, dotCount: Integer;

begin
  result := false;
  l := Length(s);

  if l = 0 then Exit;

  if l = 1 then begin
     Result := s[1] in CNum;
  end
  else
  if l = 2 then begin
     Result := ( s[2] in CNum) and ((s[1] in CSign) or (s[2] in CNum))
  end;
  if l > 2 then begin

  end;
end;
}

//==============================================================================
function ConvertStringToFloat(const s: string): double;
var
  numChar, SignChar: set of Char;
  numPoint: integer;
  i, max: integer;
  str: string;
  valid: boolean;
  fs: TFormatSettings;
begin
  result := 0.0;
  str := trim(s);
  max := Length(str);
  if max < 1 then exit;

  numChar := ['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  SignChar := ['-', '+'];

  if str[1] in SignChar then begin
    valid := max > 1;
    i := 2;
  end
  else begin
    valid := TRUE;
    i := 1;
  end;
  numPoint := 0;
  while valid and (i <= max) do begin
    valid := valid and (str[i] in numChar);
    if str[i] = '.' then inc(numPoint);
    inc(i);
  end;
  if valid and (numPoint < 2) then begin
    fs.DecimalSeparator := '.';
    result := StrToFloat(str, fs);
  end;
end;

//==============================================================================
function ConvertStringToInt(const s: string): integer;
var
  numChar, SignChar: set of Char;
  i, max: integer;
  str: string;
  valid: boolean;
begin
  result := 0;
  str := trim(s);
  max := Length(str);
  if max < 1 then exit;

  numChar := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  SignChar := ['-', '+'];

  if str[1] in SignChar then begin
    valid := max > 1;
    i := 2;
  end
  else begin
    valid := TRUE;
    i := 1;
  end;

  while valid and (i <= max) do begin
    valid := valid and (str[i] in numChar);
    inc(i);
  end;

  if valid then
    result := StrToInt(str);
end;

//==============================================================================
function LimitStr(const sNew: string; const sz: Byte=16): string;
begin
  if Length(sNew) >= sz then
    result  := Copy(sNew, 1, sz)
  else
    Result  := sNew;
end;

//==============================================================================
function MakeValidIdent(var Ident: string): Boolean;
const
  Alpha = ['A'..'Z', 'a'..'z', '_'];
  AlphaNumeric = Alpha + ['0'..'9'];
var
  I: Integer;
begin
  Result := False;
  if (Length(Ident) = 0) or not (Ident[1] in Alpha) then Exit;
  for I := 2 to Length(Ident) do
   if not (Ident[I] in AlphaNumeric) then Ident[I] := '_';

  Result := True;
end;

//==============================================================================
procedure StringListCompare(const aStrs1, aStrs2 :TStrings;
      var aStrsEqual, aStrsIn_1_Only, aStrsIn_2_Only: TStrings;
      const aSort: boolean= false);

var i, j : integer;
    strI, strJ : string;
    same : boolean;

begin
  aStrsIn_1_Only.Clear;
  aStrsIn_1_Only.AddStrings(aStrs1);
  (aStrsIn_1_Only as TStringList).Sorted := aSort;

  aStrsIn_2_Only.Clear;
  aStrsIn_2_Only.AddStrings(aStrs2);
  (aStrsIn_2_Only as TStringList).Sorted := aSort;

  for i := aStrsIn_1_Only.Count-1 downto 0 do begin
    strI := aStrsIn_1_Only[i];

    j := 0;
    same := false;
    while not same and (j < aStrsIn_2_Only.Count) do begin
      strJ := aStrsIn_2_Only[j];
      same :=  CompareStr(strI,  strJ) = 0;
      inc(j);
    end;

    if same then begin
      aStrsEqual.Insert(0,strI);
      aStrsIn_1_Only.Delete(i);
      aStrsIn_2_Only.Delete(j-1);
    end;
  end;
end;

procedure Split(const Delimiter: Char;Input: string;const Strings: TStrings) ;
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;


function RightStr(Const Str: String; Size: Word): String;
begin
  if Size > Length(Str) then Size := Length(Str) ;
  RightStr := Copy(Str, Length(Str)-Size+1, Size)
end;

function MidStr(Const Str: String; From, Size: Word): String;
begin
  MidStr := Copy(Str, From, Size)
end;

function LeftStr(Const Str: String; Size: Word): String;
begin
  LeftStr := Copy(Str, 1, Size)
end;

procedure Slice(const aStr : string;const low, high : integer; var aStr2 : string);
var
  dLength : integer;
begin
  dLength := high - low;
  aStr2 := Copy(aStr, low + 1, dLength);
end;

function DeleteAmpersand(Value: string): string;
var
  i: integer;
  found: Boolean;
begin
  i := -1;
  found := false;

  for i := 0 to Length(Value) - 1 do  begin
    if Value[i] = '&' then
    begin
      found := true;
      break;
    end;
  end;

  if found then
    Delete(Value, i, 1);
  result := Value;
end;

end.
