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

type
  RecCommandData = record
    pid: TPacketID;
    projectType: Byte;
    command: Byte;
  end;

implementation

end.
