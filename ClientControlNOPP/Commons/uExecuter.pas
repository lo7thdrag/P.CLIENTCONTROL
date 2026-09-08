unit uExecuter;

interface

uses
  Classes, Windows;

type

  TAppExecute = class
  protected
    pi: TProcessInformation;
    si: TStartupInfo;

    FActive: Boolean;
    FOnStartExec  : TNotifyEvent;
    FOnEndExec    : TNotifyEvent;
  public
    FExecFname: string;

    constructor Create;
    destructor Destroy; override;

    procedure Executes;
    procedure ExecutesAndWait;

	  procedure ExecutesWithParams ( params : string) ;
    procedure Terminates;
  public

    property Active: boolean read FActive;
    property OnStartExecute:  TNotifyEvent read FOnStartExec write FOnStartExec;
    property OnEndExecute:    TNotifyEvent read FOnEndExec   write FOnEndExec;
  end;

//  procedure CreateProcessSimple(sExecutableFilePath: string);
{
  procedure ExecuteAndWait(const fName: string);
  procedure CreateProcessSimple(sExecutableFilePath: string);
}

implementation

uses
  Dialogs;

{procedure CreateProcessSimple(sExecutableFilePath: string);
var pi: TProcessInformation;
    si: TStartupInfo;
begin
  FillMemory(@si, sizeof(si), 0);
  si.cb := sizeof(si);

  CreateProcess(
    nil,
    PChar(sExecutableFilePath),
    nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil,
    si, pi);

  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);
end;

procedure ExecuteAndWait(const fName: string);
var prInfo : TProcessInformation;
    stInfo: TStartupInfo;
    exCode: Cardinal;
begin
  FillChar(prInfo, SizeOf(TProcessInformation), 0);
  FillChar(stInfo, SizeOf(TStartupInfo), 0);
  stInfo.cb :=  sizeof(TStartupInfo);;

  if CreateProcess(
    nil, PAnsiChar(fName) , nil, nil, false,  NORMAL_PRIORITY_CLASS,
    nil, nil,  stInfo, prInfo) then begin

    WaitForSingleObject(prInfo.hProcess, INFINITE);

    GetExitCodeProcess(prInfo.hProcess, exCode);  // Optional
    CloseHandle(prInfo.hThread);
    CloseHandle(prInfo.hProcess);
  end
  else
    ShowMessage('Error in launching '+ fName);
end;
}
{ TAppExecute }

constructor TAppExecute.Create;
begin
  FillMemory(@si, sizeof(si), 0);
  si.cb := sizeof(si);

  FActive := False;
end;

destructor TAppExecute.Destroy;
begin
  if FActive then
     Terminates;

  inherited;
end;

procedure TAppExecute.Executes;
begin
  FActive := True;
  if CreateProcess(
    nil,
    PChar(FExecFname),
    nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, si, pi) then begin

  end;
end;

procedure TAppExecute.ExecutesAndWait;
var exCode: Cardinal;
begin
  FillChar(pi, SizeOf(TProcessInformation), 0);
  FillChar(si, SizeOf(TStartupInfo), 0);
  si.cb :=  sizeof(TStartupInfo);;

  if CreateProcess(
    nil, PChar(FExecFname) , nil, nil, false,  NORMAL_PRIORITY_CLASS,
    nil, nil,  si, pi) then begin

    if Assigned(FOnStartExec) then
      FOnStartExec(self);

    WaitForSingleObject(pi.hProcess, INFINITE);

    GetExitCodeProcess(pi.hProcess, exCode);  // Optional
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);

    if Assigned(FOnEndExec) then
      FOnEndExec(self);

  end
  else
    ShowMessage('Error in launching '+ FExecFname);
end;

procedure TAppExecute.ExecutesWithParams ( params : string) ;
var
  CmdLine: PChar;
begin
  FActive := True;
  CmdLine := PChar(FExecFname+' '+params);

  if CreateProcess(
    nil,
    CmdLine,
    nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, si, pi) then
  begin
  end;
end;

procedure TAppExecute.Terminates;
begin
  if FActive then begin
    TerminateProcess(pi.hProcess, 0);
      CloseHandle(pi.hProcess);
      CloseHandle(pi.hThread);

  end;

  FActive := False;
end;

end.
