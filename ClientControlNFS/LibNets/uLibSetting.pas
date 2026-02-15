unit uLibSetting;


interface

uses
  Graphics, Windows;

const
  // aplication.ini setting
  c_net = 'network';
  c_NET_PORT     = '1927';      // server tcp listen.
  c_NET_SVRIP = '192.168.1.10';
  c_NET_APPLICATION = 'GC';
  c_NET_APPLICATION2 = 'AOPRSimClient';
  c_NET_URL = '..\NAFS\';

type
  //------------------------------------------------------------------------------
  // load from main setting file.
  //------------------------------------------------------------------------------
  TNetSetting = record
    Port      : string;
    ServerIP  : string;
    AutoStart : Boolean;
    Application : string;
    Application2 : string;
    Nafsserver : string;
    Nafsbridge : string;
    Nsfsserver : string;
    Nsfsbridge : string;
    Nssfsserver : string;
    Nssfsbridge : string;
    InstNafs : string;
    InstNsfs : string;
    InstNssfs : string;
    ClientMode : string;
  end;

  function getFileSetting: string;
  function LoadFF_NetSetting(const fName: string; var nSet: TNetSetting): boolean;

var
  {global var}
  //loaded setting  FROM FILE

  vSettingFile: string;

  vNetSetting : TNetSetting;

  function GetConsoleIdentification : Boolean;

implementation

uses
  Classes, IniFiles, SysUtils, uIniFilesProcs, System.Win.Registry, WbemScripting_TLB, System.StrUtils, System.Variants;

const
   c_gdata = 'gamedata';

//==============================================================================
function getFileSetting: string;
begin
  result := ExtractFilePath(ParamStr(0)) + 'WorldController.ini';
end;
//==============================================================================

function LoadFF_NetSetting(const fName: string; var nSet: TNetSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  s := ExtractFilePath(ParamStr(0));
  IniF := TIniFile.Create(fName);

  with nSet do begin
    Port        := INIFReadString(inif, c_net, 'port',  c_NET_PORT);
    ServerIP    := INIFReadString(inif, c_net, 'serverip',  c_NET_SVRIP);
    AutoStart   := INIFReadBool(inif, c_net, 'autostart', true);
    Application := INIFReadString(inif, c_net, 'aplication',  c_NET_APPLICATION);
    Application2:= INIFReadString(inif, c_net, 'aplication2',  c_NET_APPLICATION2);
    Nafsserver  := INIFReadString(inif, c_net, 'nafsserver',  c_NET_URL);
    Nafsbridge  := INIFReadString(inif, c_net, 'nafsbridge',  c_NET_URL);
    Nsfsserver  := INIFReadString(inif, c_net, 'nafsserver',  c_NET_URL);
    Nsfsbridge  := INIFReadString(inif, c_net, 'nsfsbridge',  c_NET_URL);
    Nssfsserver := INIFReadString(inif, c_net, 'nafsserver',  c_NET_URL);
    Nssfsbridge := INIFReadString(inif, c_net, 'nssfsbridge',  c_NET_URL);
    InstNafs    := INIFReadString(inif, c_net, 'instNafs',  '192.168.1.1');
    InstNsfs    := INIFReadString(inif, c_net, 'instNsfs',  '192.168.1.1');
    InstNssfs   := INIFReadString(inif, c_net, 'instNssfs',  '192.168.1.1');
    ClientMode  := INIFReadString(inif, c_net, 'clientmode',  'NAFS');
  end;

  Inif.Free;

  result := true;
end;

function GetConsoleIdentification: Boolean;
var
  WMIServices : ISWbemServices;
  Root        : ISWbemObjectSet;
  Item        : Variant;
  snTemp      : string;
  regTemp     : string;
  Address     : string;
  dateTemp    : string;
  stop, start : TDateTime;
  selisih     : Double;
  Tahun, Bulan, Hari : Word;
  FReg              : TRegistry;
begin
  snTemp :=  '';
  regTemp := '';

  WMIServices := CoSWbemLocator.Create.ConnectServer('.', 'root\cimv2','', '', '', '', 0, nil);
  Root  := WMIServices.ExecQuery('Select SerialNumber From Win32_DiskDrive','WQL', 0, nil);
//  Item := Root.ItemIndex(0);
  snTemp:=VarToStr(Item.SerialNumber);

  snTemp := ReplaceStr(snTemp, '_', '');
  snTemp := ReplaceStr(snTemp, '.', '');
  snTemp := RightStr(snTemp,8);

  Address := 'Software\CmPack\CmLogin';
  try
    try
      FReg := Tregistry.Create;
      FReg.OpenKey(Address,False);
      regTemp := FReg.ReadString('LockID');
      dateTemp := FReg.ReadString('Date');
    except on ERegistryException do
    end;
  finally
    FReg.CloseKey;
  end;

  DecodeDate(Now, Tahun, Bulan, Hari);
  start := EncodeDate(Tahun, Bulan, Hari);

  if dateTemp = 'U' then
  begin
    Result := snTemp = regTemp;
  end
  else
  begin
    Stop := StrToFloat(dateTemp);
    selisih := Stop - start;

    if selisih < 0 then
      Result := False
    else
      Result := snTemp = regTemp;
  end;
end;

end.


