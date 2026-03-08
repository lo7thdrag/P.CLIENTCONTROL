unit uLibSettingTTT;


interface

uses
  Graphics, uDataTypes, Windows;

const
  // aplication.ini setting
  c_net = 'network';
//    c_NET_PORT  = 32000;
    c_NET_SESSIONPORT     = 32001;      // session server tcp listen. GC connect to.
    c_NET_DBEDITPORT      = 32002;
    c_NET_GAMEPORT        = 32003;      // udp broadcasst port.
    c_NET_COMMANDPORT     = 32004;      // game server tcp listen. game client connect.

    c_NET_VOIP_CTRL_PORT  = 32005;
    c_NET_VoipCtrlAddress = '192.168.1.11';

    c_NET_MAPSTUBPORT     = 32006;      // mapstub
    c_NET_MAPSTUBGCPORT   = 32008;      // GC mapstub
    c_NET_MAPSTUBADDR     = '192.168.1.11';

    c_NET_VBSPORT         = 32009;      // game server VBS tcp listen. game client VBS connect.

  c_NET_BC_ADDRESS = '192.168.1.255';

  c_NET_SVRIP = '192.168.1.11';

  c_map = 'map';
    C_MaxZoomIndex = 12;
    C_MinZoomIndex = 0;

 c_dBase = 'database';
  c_defaultDBUser      = 'sa';
  c_defaultDBpassword  = 'sa';
  c_defaultDBProto     = 'mssql';

 c_symbol = 'symbol';
 c_vbs = 'vbs';

    APP_REMOTE_BAT    = 'tttRemote.bat';

type
  //------------------------------------------------------------------------------
  // load from main setting file.
  //------------------------------------------------------------------------------
  TNetSetting = record
    SessionPort     : Word;     // TCP sessionPort Session Server Listen. GC Connect
    DBEditPort      : Word;
    CommandPort     : Word;     // TCP GameServer Listen.
    VBSPort         : Word;     // TCP GameServerVBS Listen.
    GamePort        : Word;     // UDP GameServer BC
    GameAddress     : string;   // UDP Broadcast Address.
    VoipCtrlPort    : Word;     // gameClient listen for archos.
    VoipCtrlAddress : string;   // konsole ip
    AutoStart       : Boolean;
    MapStubPort     : Word;
    MapStubGCPort   : Word;
    MapStubAddr     : string;
  end;

  TNetServerSetting = record
    SendInterval: Integer;
    VBSSendInterval : Integer;
  end;

  TNetClientSetting = record
    ServerIP: string;
  end;

  TNetBridgeSetSetting = record
    ServerIP: string;
    Port: Integer;
  end;

  //------------------------------------------------------------------------------
  TMapSetting = record
    MapPath,
    MapGeoset: string;
    MapDataGeoset: string;

    MapENCPath: string;
    MapGSTGame: string;
    MapDefGame: string;
    MapKarvak : string;

    OverlayPath : string;
    OverlayDestination : string;
    PlottingPath : string;
    PlottingDestination : string;
    PatternPath : string;
    Project      : string;
    MapZoom: integer;
    mX, mY: double;
    Colorbg : TColor;
    FullScreen: boolean;
    FormWasdal: Boolean;
    FormViewer: Boolean;
    FormPlotter: Boolean;
//    GroupController : Boolean;
//    GroupWasdal : Boolean;
//    GroupCubicle : Boolean;
    ActiveDoubleBufferd : Boolean;

    TerrainID : Byte;
    TerrainName : string;
    MiniMapPath : string;
  end;

  //----------------------------------------------------------------------------
  TRecPlayMode   = record
    GameType      : byte ;
    RecFileName   : string;
  end;
  //----------------------------------------------------------------------------
  TGameDataSetting = record
    DataPath: string;
    ScenarioID : Integer;
    SnapshotName : string ;
    RootRecordPath : string;
    GamePlayMode : TRecPlayMode ;
    OwnShipPlatfomID: Integer;
    GroupSetting: string;
    GameSessionID : Integer;
    RemotePort : integer ;
    RemoteScreen : integer ;
    ReplayScreen : integer;
    TacticalScreen : Integer;
    ToteScreen : Integer;
    DemoMode : Boolean;
    VisibleCircleWP : Boolean;
    LogData : Boolean;
    DelaySendData : Cardinal;
    VBSPath : string;
    SQFPath : string;
    GotoInterval : integer; //goto delta time interval in second
  end;
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  TExcluedMapArea = record
    Areas : array of T2DRect; // map area
  end;

//  TPortMapArea = TExcluedMapArea;
  TPortMapArea = record
    Areas : array of T2DPolygon;
  end;

  TDBaseSetting  = record
    dbServer,
    dbProto,
    dbName,
    dbUser,
    dbPass: string
  end;

  TSymbolSetting = record
    ImgPath: string;
    BmpPath: string;
    DefaultSymbol: string;
    MissileSeekerVisible : Boolean;
    FontSize : Integer;
  end;

  TVBSSetting = record
    VBSUser: string;
    VBSMission: string;
  end;
  TApplicationSetting = record
    GameServerName  : string;
    GameClientName  : string;
    VBSClientName   : string;
    DBEditorName    : string;
    MapSynchName    : string;
    RemoteServerName: string;
    RemoteClientName: string;
    GameReplayName  : string;
    MapStubName     : string;
    WasdalName      : string;
    VBSName         : string;
    CameraController: string;
  end;

  TCubicleAssignSetting = record
    GroupIDs : array of Integer;
  end;

  TTerrainArea = record
    Area : array of string;
  end;

  function getFileSetting: string;

  function LoadFF_NetSetting(const fName: string; var nSet: TNetSetting): boolean;
  function LoadFF_NetServerSetting(const fName: string; var nSet: TNetServerSetting): boolean;
  function LoadFF_NetClientSetting(const fName: string; var nSet: TNetClientSetting): boolean;
  function LoadFF_NetBridgeSetSetting(const fName: string; var nSet: TNetBridgeSetSetting): boolean;
  //------------------------------------------------------------------------------

  function LoadFF_MapSetting(const fName: string; var mSet: TMapSetting): boolean;

  //------------------------------------------------------------------------------
  function LoadFF_GameSetting(const fName: string; var gdSet: TGameDataSetting): boolean;
  procedure SaveFF_GameSetting(const fName: string; var gdSet: TGameDataSetting);

  procedure LoadFF_ExcludeMapArea(const fName: string; var gdAreas: TExcluedMapArea);

  //untuk pengecekan apakah memasuki area pelabuhan atau tidak
  procedure LoadFF_PortMapArea(const fName: string; var gdAreas: TPortMapArea);

  procedure LoadFF_TerrainArea(const fName: string; var gdAreas: TTerrainArea);

  function LoadFF_dBaseSetting(const fName: string; var dbSet: TDBaseSetting): boolean;
  procedure SaveFF_dBaseSetting(const fName: string; var dbSet: TDBaseSetting);

  function LoadFF_SymbolSetting(const fName: string; var imgSet: TSymbolSetting): boolean;

  function LoadFF_VBSSetting(const fName: string; var vbsSet: TVBSSetting): Boolean;

  function LoadFF_AppSetting(const fName: string; var appSett: TApplicationSetting): boolean;

  procedure LoadFF_CubicalAssignSetting(const fName: string; var caSett: TCubicleAssignSetting);
  procedure SaveFF_CubicalAssignSetting(const fName: string; var caSett: TCubicleAssignSetting);


var
  {global var}
  //loaded setting  FROM FILE

  vSettingFile: string;

  vNetSetting         : TNetSetting;
    vNetServerSetting : TNetServerSetting;
    vNetClientSetting : TNetClientSetting;
    vNetBridgeSetSetting : TNetBridgeSetSetting;

  vMapSetting         : TMapSetting;
  vGameDataSetting    : TGameDataSetting;
  vDBSetting          : TDBaseSetting;
  vSymbolSetting      : TSymbolSetting;
  vVBSSetting         : TVBSSetting;

  vAppSetting         : TApplicationSetting;

  vCubicalAssignSetting : TCubicleAssignSetting;
  vExcludeMapArea     : TExcluedMapArea;

  vPortMapArea        : TPortMapArea;

  vTerrainArea : TTerrainArea;

implementation

uses
  Classes, IniFiles, SysUtils, uIniFilesProcs, uCodecBase64;

const
   c_gdata = 'gamedata';

//==============================================================================
function getFileSetting: string;
begin
//  result := ChangeFileExt(ParamStr(0), '.ini');
  result := ExtractFilePath(ParamStr(0)) + 'Setting.ini';
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
//    BasePort  := Abs(INIFReadInteger(inif, c_net, 'baseport',  c_NET_PORT));
    SessionPort   := Abs(INIFReadInteger(inif, c_net, 'sessionport',  c_NET_SESSIONPORT));
    DBEditPort    := Abs(INIFReadInteger(inif, c_net, 'dbeditport',   c_NET_DBEDITPORT));
    CommandPort   := Abs(INIFReadInteger(inif, c_net, 'commandport',  c_NET_COMMANDPORT));
    VBSPort       := Abs(INIFReadInteger(IniF, c_net, 'VBSport', c_NET_VBSPORT));

    GamePort      := Abs(INIFReadInteger(inif, c_net, 'gameport',     c_NET_GAMEPORT));
    GameAddress   := INIFReadString(inif, c_net,      'gameaddress',  c_NET_BC_ADDRESS);

    VoipCtrlPort    := Abs(INIFReadInteger(inif, c_net, 'voipctrlport', c_NET_VOIP_CTRL_PORT));
    VoipCtrlAddress := INIFReadString(inif, c_net, 'voipctrladdress', c_NET_VoipCtrlAddress);

    AutoStart     := INIFReadBool(inif, c_net,       'autostart', true);

    MapStubPort    := Abs(INIFReadInteger(inif, c_net, 'mapstubport', c_NET_MAPSTUBPORT));
    MapStubGCPort  := Abs(INIFReadInteger(inif, c_net, 'mapstubGCport', c_NET_MAPSTUBGCPORT));
    MapStubAddr    := INIFReadString(inif, c_net, 'mapstubaddress', c_NET_MAPSTUBADDR);
  end;

  Inif.Free;

  result := true;
end;

function LoadFF_NetServerSetting(const fName: string; var nSet: TNetServerSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  s := ExtractFilePath(ParamStr(0));
  IniF := TIniFile.Create(fName);

  with nSet do begin
    SendInterval :=  Abs(INIFReadInteger(inif, c_net, 'sendinterval', 4));
    VBSSendInterval :=  Abs(INIFReadInteger(inif, c_net, 'VBSSendInterval', 4));
  end;

  Inif.Free;

  result := true;
end;

function LoadFF_NetClientSetting(const fName: string; var nSet: TNetClientSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  s := ExtractFilePath(ParamStr(0));
  IniF := TIniFile.Create(fName);

  with nSet do begin
    ServerIP  := INIFReadString(inif, c_net, 'serverip',  c_NET_SVRIP);
  end;

  Inif.Free;

  result := true;
end;

function LoadFF_NetBridgeSetSetting(const fName: string; var nSet: TNetBridgeSetSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  s := ExtractFilePath(ParamStr(0));
  IniF := TIniFile.Create(fName);

  with nSet do begin
    ServerIP  := INIFReadString(inif, c_net, 'BridgeSetServer',  '192.168.1.4');
    Port      := abs(INIFReadInteger(IniF, c_net, 'BridgeSetPort', 2121));
  end;

  Inif.Free;

  result := true;
end;

//==============================================================================

function LoadFF_MapSetting(const fName: string; var mSet: TMapSetting): boolean;
var IniF: TIniFile;
    s: string;
begin
  IniF := TIniFile.Create(fName);

  s := ExtractFilePath(ParamStr(0));
  with mSet do begin
    MapPath := IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'mappath', 'M:\game_area'));
//      s + IniFReadstring(inif, c_map, 'mappath', 'mapsea'));

    MapENCPath:= IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'mapencpath', 'M:\mapsea'));

    MapGSTGame := INIFReadString(IniF, c_map, 'MapGSTGame', '');

    MapDefGame := INIFReadString(IniF, c_map, 'MapDefGame', '');

    MapGeoset     := IniFReadstring(inif, c_map, 'defmap', 'Indonesia.gst');

    MapDataGeoset  := IniFReadstring(inif, c_map, 'mapdata',
      'M:\map\mapdata\mapdata.gst');

    MapKarvak := INIFReadString(IniF, c_map, 'MapKarvak', '');

//    MapDataGeoset  := IniFReadstring(inif, c_map, 'mapdata',
//      'M:\maps\mapdata\mapdata.gst');

    MapZoom := INIFReadInteger(inif, c_map, 'zoom', 5);
    if MapZoom > C_MaxZoomIndex then
      MapZoom := C_MaxZoomIndex;
    if MapZoom < C_MinZoomIndex then
        MapZoom := C_MinZoomIndex;

    mX := INIFReadFloat(IniF, c_map, 'long', 112.75 );
    mY := INIFReadFloat(IniF, c_map, 'latt', -7.2 );

    FullScreen := INIFReadBool(inif, c_map, 'fullscreen', True );

    FormWasdal := INIFReadBool(inif, c_map, 'formWasdal', True );
    FormViewer := INIFReadBool(inif, c_map, 'formViewer', True );
    FormPlotter := INIFReadBool(inif, c_map, 'formPlotter', True );

//    GroupController := INIFReadBool(inif, c_map, 'groupcontroller', True );
//    GroupWasdal := INIFReadBool(inif, c_map, 'groupwasdal', True );
//    GroupCubicle := INIFReadBool(inif, c_map, 'groupcubicle', True );


    ActiveDoubleBufferd := INIFReadBool(inif, c_map, 'activeDoubleBuffered', True );

    {added by me}
    OverlayPath := IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'overlaypath', 'M:\map\map\overlay'));

    OverlayDestination := IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'overlayDestination', '\\192.168.1.202\Map\Map\overlay'));

    PlottingPath := IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'plottingpath', 'M:\map\PlottingPath'));
    PlottingDestination := IncludeTrailingBackslash(
      INIFReadString(inif, c_map, 'PlottingDestination', '\\192.168.5.1\Map\PlottingPath'));
    PatternPath := IncludeTrailingBackslash(
      IniFReadstring(inif, c_map, 'patternpath', 'M:\map\pattern'));

    TerrainID := INIFReadInteger(IniF, c_map, 'TerrainID', 0);
    TerrainName := INIFReadString(IniF, c_map, 'TerrainName',
      'Indonesia_Surabaya');
    MiniMapPath := INIFReadString(IniF, c_map, 'MiniMapPath',
      'D:\MAP\DEF_MAP_VIEW\Indonesia');
    Project := INIFReadString(IniF, c_map, 'Project',
      'NOPR');

  end;

  result := true;
end;

function LoadFF_GameSetting(const fName: string; var gdSet: TGameDataSetting): boolean;
var IniF: TIniFile;
    s: string;
begin
  IniF := TIniFile.Create(fName);

  s := ExtractFilePath(ParamStr(0));
  with gdSet do begin
    DataPath    := IncludeTrailingBackslash(
      s + IniFReadstring(inif, c_gdata, 'datapath', '.\data\'));
    GroupSetting := DataPath + IniFReadstring(inif, c_gdata, 'groups' , 'cubicles.xml');

    ScenarioID    := INIFReadInteger(IniF, c_gdata, 'scenarioid', 452);
    GameSessionID := INIFReadInteger(IniF, c_gdata, 'sessionid', 1111);
    SnapshotName              := INIFReadString(IniF, c_gdata, 'snapshotname', ' ');
    RootRecordPath            := INIFReadString(IniF, c_gdata, 'rootrecordpath', 'C:\T3RecordPath');
    GamePlayMode.GameType     := INIFReadInteger(IniF, c_gdata, 'gameplaymode', 0 );
    GamePlayMode.RecFileName  := INIFReadString(IniF, c_gdata, 'recplayname', '' );
    RemotePort                := INIFReadInteger(IniF, c_gdata, 'remoteport',9000);
    RemoteScreen              := INIFReadInteger(IniF, c_gdata, 'remotescreen',0);
    ReplayScreen              := INIFReadInteger(IniF, c_gdata, 'replayscreen',2);
    TacticalScreen            := INIFReadInteger(IniF, c_gdata, 'TacticalScreen',0);
    ToteScreen                := INIFReadInteger(IniF, c_gdata, 'ToteScreen',1);
    DemoMode                  := INIFReadBool(IniF, c_gdata, 'DemoMode', False);
    VBSPath                   := INIFReadString(IniF, c_gdata, 'VBSPath', 'C');
    SQFPath                   := INIFReadString(IniF, c_gdata, 'SQFPath',
                  'C:\Bohemia Interactive\VBS3\mpmissions\SQFMission\init.sqf');
    DelaySendData             := INIFReadInteger(IniF, c_gdata, 'DelaySendData', 500);
    VisibleCircleWP           := INIFReadBool(IniF, c_gdata, 'VisibleCircleWP', False);
    LogData                   := INIFReadBool(IniF, c_gdata, 'LogData', LogData); {Mubdi}
    GotoInterval              := INIFReadInteger(IniF, c_gdata, 'gotointerval', 10 ); // 10 second default
  end;
  result := true;
end;

procedure SaveFF_GameSetting(const fName: string; var gdSet: TGameDataSetting);
var  iniF: TIniFile;
begin
  IniF := TIniFile.Create(fName);

  with iniF, gdSet do begin
    WriteInteger(c_gdata, 'sessionid',     GameSessionID); //untuk client.
    WriteInteger (c_gdata,  'scenarioid',  ScenarioID);
    WriteString(c_gdata, 'snapshotname' ,  SnapshotName);
   // WriteString(c_gdata, 'rootrecordpath' ,  RootRecordPath);
    WriteInteger(c_gdata, 'gameplaymode',  GamePlayMode.GameType);
    WriteString(c_gdata, 'recplayname',    GamePlayMode.RecFileName);
    WriteInteger (c_gdata,  'remoteport',  RemotePort);
    WriteInteger (c_gdata,  'remotescreen',  RemoteScreen);
    WriteInteger(c_gdata, 'TacticalScreen', TacticalScreen);
    WriteInteger(c_gdata, 'ToteScreen', ToteScreen);
    WriteBool(c_gdata, 'DemoMode', DemoMode);
    WriteString(c_gdata, 'VBSPath', VBSPath);
    WriteString(c_gdata, 'SQFPath', SQFPath);
    WriteInteger(c_gdata, 'DelaySendData', DelaySendData);
    WriteBool(c_gdata, 'VisibleCircleWP', False);
    WriteBool(c_gdata, 'LogData', LogData); {Mubdi}
  end;
  inif.Free;

end;


function LoadFF_dBaseSetting(const fName: string; var dbSet: TDBaseSetting): boolean;
var IniF: TIniFile;
    s: string;
    readIn, readOut : string;
begin
  IniF := TIniFile.Create(fName);
  s := ExtractFilePath(ParamStr(0));

  with dbSet do begin
    dbServer :=  IniFReadstring(inif, c_dBase, 'dbserver', '192.168.1.15');
    dbProto  :=  IniFReadstring(inif, c_dBase, 'dbproto', c_defaultDBProto );
    dbName   :=  IniFReadstring(inif, c_dBase, 'dbname',  'runtime_db');

    readIn    := Base64Encode(c_defaultDBUser);
    readOut   := IniFReadstring(inif, c_dBase, 'dbuser', readIn);
    dbUser    := Base64Decode(readOut);

    readIn    := Base64Encode(c_defaultDBPassword);
    readOut   := IniFReadstring(inif, c_dBase, 'dbpass', readIn);
    dbPass    := Base64Decode(readOut);

  end;
  result := true;
end;

procedure SaveFF_dBaseSetting(const fName: string; var dbSet: TDBaseSetting);
var  iniF: TIniFile;
begin
  IniF := TIniFile.Create(fName);

  with iniF, dbSet do begin
    WriteString(c_dBase, 'dbserver', dbServer);
    WriteString(c_dBase, 'dbproto',  dbProto );
    WriteString(c_dBase, 'dbname',   dbName);
    WriteString(c_dBase, 'dbuser',   Base64Encode(dbUser));
    WriteString(c_dBase, 'dbpass',   Base64Encode(dbPass));
  end;
  inif.Free;

end;

function LoadFF_SymbolSetting(const fName: string; var imgSet: TSymbolSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  IniF := TIniFile.Create(fName);
  s := ExtractFilePath(ParamStr(0));

  with imgSet do
  begin
    ImgPath := IncludeTrailingBackslash(s + IniFReadstring(IniF, c_symbol,
      'imgpath', '.\data\bitmap\'));
    BmpPath := IncludeTrailingBackslash(s + IniFReadstring(IniF, c_symbol,
      'bmpPath', '.\data\TacticalSymbol\'));
    DefaultSymbol := IniFReadstring(IniF, c_symbol, 'defsymbol',
      'SurfacePending.bmp' );
    MissileSeekerVisible := Boolean(INIFReadInteger(IniF, c_symbol,
      'Missile_Seeker_Visible', 0));
    FontSize := INIFReadInteger(IniF, c_symbol,
      'FontSize', 24);
  end;

  Result := True;
end;

function LoadFF_VBSSetting(const fName: string; var vbsSet: TVBSSetting): boolean;
var
  IniF: TIniFile;
  s: string;
begin
  IniF := TIniFile.Create(fName);
  s := ExtractFilePath(ParamStr(0));

  with vbsSet do
  begin
    VBSUser := IniFReadstring(IniF, c_vbs, 'user',
      'Server3D' );
    VBSMission := IniFReadstring(IniF, c_vbs, 'mission',
      'AOPR.STDBTester_TRN' );
  end;

  Result := True;
end;

function LoadFF_AppSetting(const fName: string; var appSett: TApplicationSetting): boolean;
const
   c_appsetting = 'application';
var IniF: TIniFile;
    s: string;
begin
  IniF := TIniFile.Create(fName);
  s := ExtractFilePath(ParamStr(0));

  with appSett do begin
    GameServerName  := IniFReadstring(inif, c_appsetting, 'gameserver', 'tttSimServer.exe' );
    GameClientName  := IniFReadstring(inif, c_appsetting, 'gameclient', 'tttSimClient.exe' );
    VBSClientName   := IniFReadstring(inif, c_appsetting, 'VBSClientName', 'StartVBS.bat' );
    DBEditorName    := IniFReadstring(inif, c_appsetting, 'dbeditclient', 'pDBEditor.exe' );
    MapSynchName    := IniFReadstring(inif, c_appsetting, 'mapsynch', 'synchmap.bat' );
    RemoteServerName:= IniFReadstring(inif, c_appsetting, 'remoteserver', 'tttRServer.exe' );
    RemoteClientName:= IniFReadstring(inif, c_appsetting, 'remoteclient', 'tttRClient.exe' );
    GameReplayName  := IniFReadstring(inif, c_appsetting, 'gamereplay', 'tttSimReplay.exe' );
    MapStubName     := IniFReadstring(inif, c_appsetting, 'mapstub', 'tttMapStub.exe' );
    VBSName         := INIFReadString(IniF, c_appsetting, 'vbs', 'VBS3.exe');
    CameraController:= INIFReadString(IniF, c_appsetting, 'cameracontroller', 'CameraController.exe')
  end;
  result := true;
end;

procedure LoadFF_CubicalAssignSetting(const fName: string; var caSett: TCubicleAssignSetting);
const C_ASSIGN = 'cubicalassign';
var IniF: TIniFile;
    key: string;
    i : Integer;
    ss: TStrings;

begin
  IniF := TIniFile.Create(fName);
  ss := TStringList.Create;

  IniF.ReadSection(C_ASSIGN , ss);
  SetLength(caSett.GroupIDs, ss.Count);

  for i := 0 to ss.Count - 1 do begin

    key := ss[i];
    caSett.GroupIDs[i] := IniF.ReadInteger(C_ASSIGN, ss[i], 0);

  end;

  IniF.Free;

  ss.Free;
end;

procedure SaveFF_CubicalAssignSetting(const fName: string; var caSett: TCubicleAssignSetting);
const C_ASSIGN = 'cubicalassign';
var IniF: TIniFile;
    i: Integer;
    ss: TStrings;

begin
  IniF := TIniFile.Create(fName);
  ss := TStringList.Create;

  IniF.EraseSection(C_ASSIGN);

  for i := 0 to Length(caSett.GroupIDs) - 1 do begin
    IniF.WriteInteger(C_ASSIGN, 'groupID'+ IntToStr(i), caSett.GroupIDs[i]);

  end;

  IniF.Free;

  ss.Free;
end;


procedure LoadFF_ExcludeMapArea(const fName: string; var gdAreas: TExcluedMapArea);
const
  C_EXCLUDEAREA = 'excludearea';
var IniF: TIniFile;
    key: string;
    i,j : Integer;
    ss: TStrings;
    areas : TStrings;

begin
  IniF := TIniFile.Create(fName);
  ss := TStringList.Create;

  IniF.ReadSection(C_EXCLUDEAREA , ss);
  SetLength(gdAreas.Areas, ss.Count);
  j := 0;

  for i := 0 to ss.Count - 1 do begin

    key   := ss[i];
    areas := TStringList.Create;

    areas.DelimitedText := IniF.ReadString(C_EXCLUDEAREA, ss[i], '');
    areas.Delimiter := ',';

    if areas.Count = 4 then // valid
    begin

      TryStrToFloat(areas[0],gdAreas.Areas[j].Left);
      TryStrToFloat(areas[1],gdAreas.Areas[j].Top);
      TryStrToFloat(areas[2],gdAreas.Areas[j].Right);
      TryStrToFloat(areas[3],gdAreas.Areas[j].Bottom);

      Inc(j);

    end;

    areas.Free;

  end;

  IniF.Free;

  ss.Free;
end;

procedure LoadFF_PortMapArea(const fName: string; var gdAreas: TPortMapArea);
const
  C_PORTAREA = 'portarea';
var IniF: TIniFile;
    key: string;
    i,j : Integer;
    ss: TStrings;
    areas : TStrings;

begin
  IniF := TIniFile.Create(fName);
  ss := TStringList.Create;

  IniF.ReadSection(C_PORTAREA , ss);
  SetLength(gdAreas.Areas, ss.Count);
  j := 0;

  for i := 0 to ss.Count - 1 do begin

    key   := ss[i];
    areas := TStringList.Create;

    areas.DelimitedText := IniF.ReadString(C_PORTAREA, ss[i], '');
    areas.Delimiter := ',';

    if areas.Count = 8 then // valid
    begin

      TryStrToFloat(areas[0],gdAreas.Areas[j].Point1.x);
      TryStrToFloat(areas[1],gdAreas.Areas[j].Point1.y);
      TryStrToFloat(areas[2],gdAreas.Areas[j].Point2.x);
      TryStrToFloat(areas[3],gdAreas.Areas[j].Point2.y);
      TryStrToFloat(areas[4],gdAreas.Areas[j].Point3.x);
      TryStrToFloat(areas[5],gdAreas.Areas[j].Point3.y);
      TryStrToFloat(areas[6],gdAreas.Areas[j].Point4.x);
      TryStrToFloat(areas[7],gdAreas.Areas[j].Point4.y);

      Inc(j);

    end;

    areas.Free;

  end;

  IniF.Free;

  ss.Free;
end;

procedure LoadFF_TerrainArea(const fName: string; var gdAreas: TTerrainArea);
const
  C_TERRAIN_AREA = 'TerrainArea';
var
  i : Integer;
  areas : TStrings;
  IniF: TIniFile;
begin
  IniF := TIniFile.Create(fName);
  areas := TStringList.Create;

  areas.DelimitedText := IniF.ReadString(C_TERRAIN_AREA, 'Area', '');
  areas.Delimiter := ',';

  if areas.Count > 0 then
  begin
    SetLength(gdAreas.Area, areas.Count);
    for i := 0 to areas.Count - 1 do begin
      gdAreas.Area[i] := areas[i];
    end;
    areas.Free;
  end
  else
    areas.Free;

  IniF.Free;
end;

end.


