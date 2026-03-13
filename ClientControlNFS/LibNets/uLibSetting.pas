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
    Nafsserverapp : string;
    Nafsbridgeapp : string;
    Nsfsserverapp : string;
    Nsfsbridgeapp : string;
    Nssfsserverapp : string;
    Nssfsbridgeapp : string;
    Sessionvoipapp : string;

    Nafsserver : string;
    Nafsbridge : string;
    Nsfsserver : string;
    Nsfsbridge : string;
    Nssfsserver : string;
    Nssfsbridge : string;
    Sessionvoip : string;

    InstNafs : string;
    InstNsfs : string;
    InstNssfs : string;

    ClientMode : string;

    instruktur_nsfs : string;
    mk3_2h_nsfs     : string;
    mk4_nsfs        : string;
    c802            :string;
    tds             :string;
    c705            :string;
    yakhont         :string;
    fc57mm_digital  :string;
    mr_35           :string;
    fc57mm_manual   :string;
    mm_103          :string;
    display3d_nsfs  :string;
    instruktur_nafs :string;
    mk3_2h_nafs     :string;
    mk4_nafs        :string;
    ciws_730        :string;
    eo_tracker_730  :string;
    ak_230          :string;
    mr_203          :string;
    display3d_nafs  :string;
    instruktur_nssfs:string;
    mk3_2h_nssfs    :string;
    sps_mk3         :string;
    mk4_nssfs       :string;
    sps_mk4         :string;
    sut_black_shark :string;
    rbu_digital     :string;
    rbu_manual      :string;
    display3d_nssfs :string;
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
    Port            := INIFReadString(inif, c_net, 'port',  c_NET_PORT);
    ServerIP        := INIFReadString(inif, c_net, 'serverip',  c_NET_SVRIP);
    AutoStart       := INIFReadBool(inif, c_net, 'autostart', true);

    clientapp       := INIFReadString(inif, c_app, 'clientapp', c_APP_NAME);
    nafsserverapp   := INIFReadString(inif, c_app, 'nafsserverapp', c_APP_NAME);
    nafsbridgeapp   := INIFReadString(inif, c_app, 'nafsbridgeapp', c_APP_NAME);
    nsfsserverapp   := INIFReadString(inif, c_app, 'nsfsserverapp', c_APP_NAME);
    nsfsbridgeapp   := INIFReadString(inif, c_app, 'nsfsbridgeapp', c_APP_NAME);
    nssfsserverapp  := INIFReadString(inif, c_app, 'nssfsserverapp', c_APP_NAME);
    nssfsbridgeapp  := INIFReadString(inif, c_app, 'nssfsbridgeapp', c_APP_NAME);
    sessionvoipapp  := INIFReadString(inif, c_app, 'sessionvoipapp', c_APP_NAME);

    Nafsserver      := INIFReadString(inif, c_url, 'nafsserver', c_URL_APP);
    Nafsbridge      := INIFReadString(inif, c_url, 'nafsbridge', c_URL_APP);
    Nsfsserver      := INIFReadString(inif, c_url, 'nsfsserver', c_URL_APP);
    Nsfsbridge      := INIFReadString(inif, c_url, 'nsfsbridge', c_URL_APP);
    Nssfsserver     := INIFReadString(inif, c_url, 'nssfsserver', c_URL_APP);
    Nssfsbridge     := INIFReadString(inif, c_url, 'nssfsbridge',c_URL_APP);
    Sessionvoip     := INIFReadString(inif, c_url, 'sessionvoip',c_URL_APP);

    InstNafs        := INIFReadString(inif, c_url, 'instNafs',  '192.168.1.1');
    InstNsfs        := INIFReadString(inif, c_url, 'instNsfs',  '192.168.1.1');
    InstNssfs       := INIFReadString(inif, c_url, 'instNssfs',  '192.168.1.1');

    ClientMode      := INIFReadString(inif, c_intworld, 'clientmode',  'NAFS');

    instruktur_nsfs := INIFReadString(inif, c_ipconsole, 'instruktur nsfs', '');
    mk3_2h_nsfs     := INIFReadString(inif, c_ipconsole, 'mk3 2h nsfs', '');
    mk4_nsfs        := INIFReadString(inif, c_ipconsole, 'mk4 nsfs', '');
    c802            := INIFReadString(inif, c_ipconsole, 'c802', '');
    tds             := INIFReadString(inif, c_ipconsole, 'tds', '');
    c705            := INIFReadString(inif, c_ipconsole, 'c705', '');
    yakhont         := INIFReadString(inif, c_ipconsole, 'yakhont', '');
    fc57mm_digital  := INIFReadString(inif, c_ipconsole, '57mm digital', '');
    mr_35           := INIFReadString(inif, c_ipconsole, 'mr 35', '');
    fc57mm_manual   := INIFReadString(inif, c_ipconsole, '57mm manual', '');
    mm_103          := INIFReadString(inif, c_ipconsole, 'mm 103', '');
    display3d_nsfs  := INIFReadString(inif, c_ipconsole, '3d nsfs', '');
    instruktur_nafs := INIFReadString(inif, c_ipconsole, 'instruktur nafs', '');
    mk3_2h_nafs     := INIFReadString(inif, c_ipconsole, 'mk3 2h nafs', '');
    mk4_nafs        := INIFReadString(inif, c_ipconsole, 'mk4 nafs', '');
    ciws_730        := INIFReadString(inif, c_ipconsole, 'ciws 730', '');
    eo_tracker_730  := INIFReadString(inif, c_ipconsole, 'eo tracker 730', '');
    ak_230          := INIFReadString(inif, c_ipconsole, 'ak 230', '');
    mr_203          := INIFReadString(inif, c_ipconsole, 'mr 203', '');
    display3d_nafs  := INIFReadString(inif, c_ipconsole, '3d nafs', '');
    instruktur_nssfs:= INIFReadString(inif, c_ipconsole, 'instruktur nssfs', '');
    mk3_2h_nssfs    := INIFReadString(inif, c_ipconsole, 'mk3 2h nssfs', '');
    sps_mk3         := INIFReadString(inif, c_ipconsole, 'sps mk3', '');
    mk4_nssfs       := INIFReadString(inif, c_ipconsole, 'mk4 nssfs', '');
    sps_mk4         := INIFReadString(inif, c_ipconsole, 'sps mk4', '');
    sut_black_shark := INIFReadString(inif, c_ipconsole, 'sut black shark', '');
    rbu_digital     := INIFReadString(inif, c_ipconsole, 'rbu digital', '');
    rbu_manual      := INIFReadString(inif, c_ipconsole, 'rbu manual', '');
    display3d_nssfs := INIFReadString(inif, c_ipconsole, '3d nssfs', '');
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


