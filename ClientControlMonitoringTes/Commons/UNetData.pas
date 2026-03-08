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
  doMonitor       = 7;

  CommandID: Word = 77;

type
  RecCommandData = record
    pid: TPacketID;
    command: Byte;
  end;

implementation

end.
