unit uLibSetting;


interface

uses
  Graphics, Windows;

const
  // aplication.ini setting
  c_net = 'network';
  c_NET_PORT     = '1927';      // server tcp listen.
  c_NET_SVRIP = '192.168.1.10';
  c_NET_APPLICATION = 'cmd';

type
  //------------------------------------------------------------------------------
  // load from main setting file.
  //------------------------------------------------------------------------------
  TNetSetting = record
    Port      : string;
    ServerIP  : string;
    AutoStart : Boolean;
    Application : string;
  end;

  function getFileSetting: string;
  function LoadFF_NetSetting(const fName: string; var nSet: TNetSetting): boolean;

var
  {global var}
  //loaded setting  FROM FILE

  vSettingFile: string;

  vNetSetting : TNetSetting;

implementation

uses
  Classes, IniFiles, SysUtils, uIniFilesProcs;

const
   c_gdata = 'gamedata';

//==============================================================================
function getFileSetting: string;
begin
//  result := ChangeFileExt(ParamStr(0), '.ini');
  result := ExtractFilePath(ParamStr(0)) + 'RemoteSetting.ini';
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
  end;

  Inif.Free;

  result := true;
end;

end.


