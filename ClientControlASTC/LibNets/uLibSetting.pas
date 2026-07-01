unit uLibSetting;


interface

uses
  Graphics, Windows;

const
  // aplication.ini setting
  c_net = 'network';
  c_app = 'application';
  c_url = 'url';
  c_intworld = 'instruktur world';
  c_ipconsole = 'ip console';

  c_NET_PORT     = '1927';      // server tcp listen.
  c_NET_SVRIP = '192.168.1.10';
  c_APP_NAME = 'SystemServer.exe';
  c_URL_APP = '..\NAFS\';

type
  //------------------------------------------------------------------------------
  // load from main setting file.
  //------------------------------------------------------------------------------

  TNetSetting = record
    Port      : string;
    ServerIP  : string;
    AutoStart : Boolean;

    Clientapp : string;
    ClientUpdate : string;
    SyncMap : string;
    Sessionapp : string;
    sessionurl : string;

    INS_01 : string;
    INS_02 : string;
    INS_03 : string;

    CUB_01_01 : string;
    CUB_01_02 : string;
    CUB_01_03 : string;
    CUB_01_04 : string;
    CUB_01_05 : string;
    CUB_01_06 : string;

    CUB_02_01 : string;
    CUB_02_02 : string;
    CUB_02_03 : string;
    CUB_02_04 : string;
    CUB_02_05 : string;
    CUB_02_06 : string;

    CUB_03_01 : string;
    CUB_03_02 : string;
    CUB_03_03 : string;
    CUB_03_04 : string;
    CUB_03_05 : string;
    CUB_03_06 : string;

    CUB_04_01 : string;
    CUB_04_02 : string;
    CUB_04_03 : string;
    CUB_04_04 : string;
    CUB_04_05 : string;
    CUB_04_06 : string;

    CUB_05_01 : string;
    CUB_05_02 : string;
    CUB_05_03 : string;
    CUB_05_04 : string;
    CUB_05_05 : string;
    CUB_05_06 : string;

    CUB_06_01 : string;
    CUB_06_02 : string;
    CUB_06_03 : string;
    CUB_06_04 : string;
    CUB_06_05 : string;
    CUB_06_06 : string;

    CUB_07_01 : string;
    CUB_07_02 : string;
    CUB_07_03 : string;
    CUB_07_04 : string;
    CUB_07_05 : string;
    CUB_07_06 : string;

    CUB_08_01 : string;
    CUB_08_02 : string;
    CUB_08_03 : string;
    CUB_08_04 : string;
    CUB_08_05 : string;
    CUB_08_06 : string;

    CUB_09_01 : string;
    CUB_09_02 : string;
    CUB_09_03 : string;
    CUB_09_04 : string;
    CUB_09_05 : string;
    CUB_09_06 : string;

    CUB_10_01 : string;
    CUB_10_02 : string;
    CUB_10_03 : string;
    CUB_10_04 : string;
    CUB_10_05 : string;
    CUB_10_06 : string;
  end;

  function getFileSetting: string;
  function LoadFF_NetSetting(const fName: string; var nSet: TNetSetting): boolean;

var
  {global var}
  //loaded setting  FROM FILE

  vSettingFile: string;

  vNetSetting : TNetSetting;

  function GetConsoleIdentification(var idError: Integer) : Boolean;

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
    Port            := INIFReadString(inif, c_net, 'port',  c_NET_PORT);
    ServerIP        := INIFReadString(inif, c_net, 'serverip',  c_NET_SVRIP);
    AutoStart       := INIFReadBool(inif, c_net, 'autostart', true);

    clientapp       := INIFReadString(inif, c_app, 'clientapp', c_APP_NAME);
    ClientUpdate    := INIFReadString(inif, c_app, 'clientupdate', c_APP_NAME);
    SyncMap         := INIFReadString(inif, c_app, 'syncmap', c_APP_NAME);
    sessionapp      := INIFReadString(inif, c_app, 'sessionapp', c_APP_NAME);
    sessionurl      := INIFReadString(inif, c_url, 'sessionurl', c_URL_APP);

    INS_01          := INIFReadString(inif, c_ipconsole, 'INS_01', '');
    INS_02          := INIFReadString(inif, c_ipconsole, 'INS_02', '');
    INS_03          := INIFReadString(inif, c_ipconsole, 'INS_03', '');

    CUB_01_01       := INIFReadString(inif, c_ipconsole, 'CUB_01_01', '');
    CUB_01_02       := INIFReadString(inif, c_ipconsole, 'CUB_01_02', '');
    CUB_01_03       := INIFReadString(inif, c_ipconsole, 'CUB_01_03', '');
    CUB_01_04       := INIFReadString(inif, c_ipconsole, 'CUB_01_04', '');
    CUB_01_05       := INIFReadString(inif, c_ipconsole, 'CUB_01_05', '');
    CUB_01_06       := INIFReadString(inif, c_ipconsole, 'CUB_01_06', '');

    CUB_02_01       := INIFReadString(inif, c_ipconsole, 'CUB_02_01', '');
    CUB_02_02       := INIFReadString(inif, c_ipconsole, 'CUB_02_02', '');
    CUB_02_03       := INIFReadString(inif, c_ipconsole, 'CUB_02_03', '');
    CUB_02_04       := INIFReadString(inif, c_ipconsole, 'CUB_02_04', '');
    CUB_02_05       := INIFReadString(inif, c_ipconsole, 'CUB_02_05', '');
    CUB_02_06       := INIFReadString(inif, c_ipconsole, 'CUB_02_06', '');

    CUB_03_01       := INIFReadString(inif, c_ipconsole, 'CUB_03_01', '');
    CUB_03_02       := INIFReadString(inif, c_ipconsole, 'CUB_03_02', '');
    CUB_03_03       := INIFReadString(inif, c_ipconsole, 'CUB_03_03', '');
    CUB_03_04       := INIFReadString(inif, c_ipconsole, 'CUB_03_04', '');
    CUB_03_05       := INIFReadString(inif, c_ipconsole, 'CUB_03_05', '');
    CUB_03_06       := INIFReadString(inif, c_ipconsole, 'CUB_03_06', '');

    CUB_04_01       := INIFReadString(inif, c_ipconsole, 'CUB_04_01', '');
    CUB_04_02       := INIFReadString(inif, c_ipconsole, 'CUB_04_02', '');
    CUB_04_03       := INIFReadString(inif, c_ipconsole, 'CUB_04_03', '');
    CUB_04_04       := INIFReadString(inif, c_ipconsole, 'CUB_04_04', '');
    CUB_04_05       := INIFReadString(inif, c_ipconsole, 'CUB_04_05', '');
    CUB_04_06       := INIFReadString(inif, c_ipconsole, 'CUB_04_06', '');

    CUB_05_01       := INIFReadString(inif, c_ipconsole, 'CUB_05_01', '');
    CUB_05_02       := INIFReadString(inif, c_ipconsole, 'CUB_05_02', '');
    CUB_05_03       := INIFReadString(inif, c_ipconsole, 'CUB_05_03', '');
    CUB_05_04       := INIFReadString(inif, c_ipconsole, 'CUB_05_04', '');
    CUB_05_05       := INIFReadString(inif, c_ipconsole, 'CUB_05_05', '');
    CUB_05_06       := INIFReadString(inif, c_ipconsole, 'CUB_05_06', '');

    CUB_06_01       := INIFReadString(inif, c_ipconsole, 'CUB_06_01', '');
    CUB_06_02       := INIFReadString(inif, c_ipconsole, 'CUB_06_02', '');
    CUB_06_03       := INIFReadString(inif, c_ipconsole, 'CUB_06_03', '');
    CUB_06_04       := INIFReadString(inif, c_ipconsole, 'CUB_06_04', '');
    CUB_06_05       := INIFReadString(inif, c_ipconsole, 'CUB_06_05', '');
    CUB_06_06       := INIFReadString(inif, c_ipconsole, 'CUB_06_06', '');

    CUB_07_01       := INIFReadString(inif, c_ipconsole, 'CUB_07_01', '');
    CUB_07_02       := INIFReadString(inif, c_ipconsole, 'CUB_07_02', '');
    CUB_07_03       := INIFReadString(inif, c_ipconsole, 'CUB_07_03', '');
    CUB_07_04       := INIFReadString(inif, c_ipconsole, 'CUB_07_04', '');
    CUB_07_05       := INIFReadString(inif, c_ipconsole, 'CUB_07_05', '');
    CUB_07_06       := INIFReadString(inif, c_ipconsole, 'CUB_07_06', '');

    CUB_08_01       := INIFReadString(inif, c_ipconsole, 'CUB_08_01', '');
    CUB_08_02       := INIFReadString(inif, c_ipconsole, 'CUB_08_02', '');
    CUB_08_03       := INIFReadString(inif, c_ipconsole, 'CUB_08_03', '');
    CUB_08_04       := INIFReadString(inif, c_ipconsole, 'CUB_08_04', '');
    CUB_08_05       := INIFReadString(inif, c_ipconsole, 'CUB_08_05', '');
    CUB_08_06       := INIFReadString(inif, c_ipconsole, 'CUB_08_06', '');

    CUB_09_01       := INIFReadString(inif, c_ipconsole, 'CUB_09_01', '');
    CUB_09_02       := INIFReadString(inif, c_ipconsole, 'CUB_09_02', '');
    CUB_09_03       := INIFReadString(inif, c_ipconsole, 'CUB_09_03', '');
    CUB_09_04       := INIFReadString(inif, c_ipconsole, 'CUB_09_04', '');
    CUB_09_05       := INIFReadString(inif, c_ipconsole, 'CUB_09_05', '');
    CUB_09_06       := INIFReadString(inif, c_ipconsole, 'CUB_09_06', '');

    CUB_10_01       := INIFReadString(inif, c_ipconsole, 'CUB_10_01', '');
    CUB_10_02       := INIFReadString(inif, c_ipconsole, 'CUB_10_02', '');
    CUB_10_03       := INIFReadString(inif, c_ipconsole, 'CUB_10_03', '');
    CUB_10_04       := INIFReadString(inif, c_ipconsole, 'CUB_10_04', '');
    CUB_10_05       := INIFReadString(inif, c_ipconsole, 'CUB_10_05', '');
    CUB_10_06       := INIFReadString(inif, c_ipconsole, 'CUB_10_06', '');
  end;

  Inif.Free;

  result := true;
end;

function GetConsoleIdentification(var idError: Integer): Boolean;
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
  Item := Root.ItemIndex(0);
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
  else if dateTemp = '' then
  begin
    idError := 0;
    Result := False;
  end
  else
  begin
    Stop := StrToFloat(dateTemp);
    selisih := Stop - start;

    if selisih < 0 then
    begin
      idError := 1;
      Result := False
    end
    else
    begin
      Result := snTemp = regTemp;
    end;
  end;
end;

end.


