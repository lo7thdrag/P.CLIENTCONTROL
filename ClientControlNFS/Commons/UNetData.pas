unit UNetData;

interface

uses
  uTCPDataType;

const
  doShutdown      = 0;
  doRestart       = 1;
  doRunGC         = 2;
  doRunSimClient  = 3;
  doKillGC        = 4;
  doKillSimClient = 5;
  doKillLauncher  = 6;

  CommandID: Word = 77;
  CommandApp: Word = 78;

type
  RecCommandData = record
    pid: TPacketID;
    command: Byte;
  end;

  RecAppData = record
    pid: TPacketID;
    command: Byte;
    state : Boolean;
    appName : string;
  end;

implementation

end.
