unit uBaseNetHandler;
{ be an abstract!
 class yg menggunakan socket, (udp + tcp) * (server + client)
}

interface

uses
  Classes, OverbyteIcsWSocket,  uNetBaseSocket, uPacketRegister;

type

//==============================================================================

  TBaseNetHandler = class
  protected                       // event member
    FOnStartNetworking: TNotifyEvent;
    FOnStopNetworking : TNotifyEvent;
    FOnStateChange    : TChangeState;

  protected
    FNetSock  : TNetBaseSocket;  //abstract
                                 // di server jadi TCP server / UDP sender
                                 // di client jadi TCP client / UDP listener;

    procedure FTCPSock_OnSocketChangeState(Sender: TObject;
                                 OldState, NewState : TSocketState);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ApplySetting; virtual;
    procedure StartNetworking; virtual;
    procedure StopNetworking;  virtual;
    procedure RegisterPacket(const aType, aRecSize: word;
              aProcedure: TRegPacketHandlerProc);
    procedure UnRegisterAllPacket;

  public
    property OnStartNetworking: TNotifyEvent
        read FOnStartNetworking write FOnStartNetworking;
    property OnStopNetworking: TNotifyEvent
        read FOnStopNetworking write FOnStopNetworking;
    property OnStateChange: TChangeState read FOnStateChange
       write FOnStateChange;
  end;


implementation

{ TBaseNetHandler }

//==============================================================================
procedure TBaseNetHandler.ApplySetting;
begin
  //
end;

constructor TBaseNetHandler.Create;
begin
  // create FNetSock sesuai yg dibutuhkan di class turunan;
  inherited;

end;

destructor TBaseNetHandler.Destroy;
begin

  inherited;
end;

//== protected method ==========================================================

procedure TBaseNetHandler.FTCPSock_OnSocketChangeState(Sender: TObject; OldState,
  NewState: TSocketState);
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Sender, OldState, NewState);

end;

//== public method =============================================================

procedure TBaseNetHandler.StartNetworking;
begin
  if Assigned(FOnStartNetworking) then
    FOnStartNetworking(self);

end;

procedure TBaseNetHandler.StopNetworking;
begin
  if Assigned(FOnStopNetworking) then
    FOnStopNetworking(self);

end;

procedure TBaseNetHandler.RegisterPacket(const aType, aRecSize: word;
      aProcedure: TRegPacketHandlerProc);
begin
  FNetSock.RegisterProcedure(aType, aProcedure, aRecSize);

end;

procedure TBaseNetHandler.UnRegisterAllPacket;
begin
  FNetSock.UnregisterAllProcedure;

end;


end.
