unit uNetHandler;
{ Net handler dengan menggunakan thread sendiri  socket
}

interface

uses
   Classes, SysUtils,
   uNetBaseSocket, uThreadTimer, OverbyteIcsWSocket,
   uBaseNetHandler;

type

//------------------------------------------------------------------------------
// kelas abstract
// network connection manager.
//------------------------------------------------------------------------------

  TNetHandler = class(TBaseNetHandler)
  protected

    FNetThread: TZTimer;
    FBasePort: string;

    procedure setBasePort(const Value: string);

    procedure FNetThread_OnCreate(const dt: double);    virtual; abstract;
    procedure FNetThread_OnRunning (const dt: double);  virtual;
    procedure FNetThread_OnTerminate (sender : TObject);virtual;

  public

    constructor Create;
    destructor Destroy; override;

  public

    GamePort   : integer;
    CommandPort: integer;
    BroadCastAddress: string;

    property  BasePort: string read FBasePort write setBasePort;
  end;


implementation


//===============================================================================
{ TNetHandler }

//==============================================================================
constructor TNetHandler.Create;
begin
  inherited;

end;

destructor TNetHandler.Destroy;
begin
  if Assigned(FNetThread) then begin
    FNetThread.FreeOnTerminate := true;
    FNetThread.Terminate;
  end;

  inherited;
end;

//abstract procedure TNetHandler.FNetThread_OnCreate(const dt: double);

procedure TNetHandler.FNetThread_OnRunning(const dt: double);
begin
  FNetSock.ProcessMessages; //send , receive , on data available

end;

procedure TNetHandler.FNetThread_OnTerminate(sender: TObject);
begin
  FNetSock.CloseSocket;
  FNetSock.Free;
  FNetSock := nil;

end;

procedure TNetHandler.setBasePort(const Value: string);
begin
  FBasePort := Value;

end;

//==============================================================================



end.
