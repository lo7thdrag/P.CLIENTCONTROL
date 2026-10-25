unit uIniFilesProcs;
(*
  IniFile procedures
   Force Read
   Force Write
*)


interface

uses
  IniFiles;


  function INIFReadString(var ini: TIniFile;
    const sSect, sKey, sDefault: string): string;

  function INIFReadInteger(var ini: TIniFile;
    const sSect, sKey: string; iDefault: integer): integer;

  function INIFReadFloat(var ini: TIniFile;
    const sSect, sKey: string; iDefault: double): double;

  function INIFReadBool(var ini: TIniFile;
    const sSect, sKey: string; iDefault: boolean): Boolean;


implementation


function INIFReadString(var ini: TIniFile;
  const sSect, sKey, sDefault: string): string;
begin
  if not ini.ValueExists(sSect, sKey) then
    ini.WriteString(sSect, sKey, sDefault);

  result := ini.ReadString(sSect, sKey, '');
end;

function INIFReadInteger(var ini: TIniFile;
  const sSect, sKey: string; iDefault: integer): integer;
begin
  if not ini.ValueExists(sSect, sKey) then
    ini.WriteInteger(sSect, sKey, iDefault);

  result := ini.ReadInteger(sSect, sKey, 0);
end;

function INIFReadFloat(var ini: TIniFile;
  const sSect, sKey: string; iDefault: double): double;
begin
  if not ini.ValueExists(sSect, sKey) then
    ini.WriteFloat(sSect, sKey, iDefault);

  result := ini.ReadFloat(sSect, sKey, 0.0);
end;

function INIFReadBool(var ini: TIniFile;
  const sSect, sKey: string; iDefault: boolean): Boolean;
begin
  if not ini.ValueExists(sSect, sKey) then
    ini.WriteBool(sSect, sKey, iDefault);
  result := ini.ReadBool(sSect, sKey, iDefault);
end;


end.
