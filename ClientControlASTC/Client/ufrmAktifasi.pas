unit ufrmAktifasi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, ufrmPassword,
  System.Win.Registry, WbemScripting_TLB, System.StrUtils,
  Vcl.StdCtrls;

type
  TfrmAktifasi = class(TForm)
    rbIzin: TRadioButton;
    rbKeluar: TRadioButton;
    Label2: TLabel;
    imgBackground: TImage;
    lblIzin: TLabel;
    lblKeluar: TLabel;
    btnNext: TImage;
    procedure lblIzinClick(Sender: TObject);
    procedure lblKeluarClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Fkeluar : Boolean;
    Reg : TRegistry;

    function  GetSNHardisk: string;
  end;

var
  frmAktifasi: TfrmAktifasi;

implementation

{$R *.dfm}

procedure TfrmAktifasi.btnNextClick(Sender: TObject);
var
  str1Temp : string;
  alamatTemp, password : string;
  Appstop, Networkstop, start, filter : TDateTime;
  Tahun, Bulan, Hari : Word;

begin
  if rbKeluar.Checked then
  begin
    Fkeluar := True;
    Close;
  end
  else
  begin
    frmPassword := TfrmPassword.Create(Self);
    try
      with frmPassword do
      begin
        ShowModal;

        password := pass;

      end;
    finally
      frmPassword.Free;
    end;

    str1Temp := GetSNHardisk;

    DecodeDate(Now, Tahun, Bulan, Hari);
    start := EncodeDate(Tahun, Bulan, Hari);
    filter := EncodeDate(Word(2026), Word(6), Word(28));
    alamatTemp:='\Software\CmPack\CmLogin';

    if password = 'Nuruly@k1n' then
    begin
      Appstop := start + 1000;
      Networkstop := start + 1000;
      Fkeluar := False;
    end
    else if password = 'bahagia it' then
    begin
      if start > filter then
      begin
        MessageDlg('Password wes expired sik digawe, kono izin sik', mtInformation,[mbOk], 0);
        Fkeluar := True;
      end
      else
      begin
        Appstop := start + 210;
        Networkstop := start + 180;
        Fkeluar := False;
      end;
    end
    else
    begin
      MessageDlg('Gak ngerti password e, ngaku-ngaku wes izin', mtInformation,[mbOk], 0);
      Fkeluar := True;
    end;

    if not Fkeluar then
    begin
      try

        {Membuat/ membuka folder di regedit}
        Reg.OpenKey(alamatTemp,true);

        {Menulis di regedit}
        Reg.WriteString('LockID',str1Temp);
        Reg.WriteString('Date',FloatToStr(Appstop));
        Reg.WriteString('DateNetwork',FloatToStr(Networkstop));

      finally

        Reg.CloseKey;

      end;

      MessageDlg('Activation Successful', mtInformation,[mbOk], 0);
    end;

    Close;
  end;
end;

procedure TfrmAktifasi.FormCreate(Sender: TObject);
begin
  Reg := Tregistry.Create;

  Reg.RootKey := HKEY_CURRENT_USER;

  Fkeluar := True;
end;

function TfrmAktifasi.GetSNHardisk: string;
var
  WMIServices : ISWbemServices;
  Root        : ISWbemObjectSet;
  Item        : Variant;
  snTemp      : string;
begin
  WMIServices := CoSWbemLocator.Create.ConnectServer('.', 'root\cimv2','', '', '', '', 0, nil);
  Root  := WMIServices.ExecQuery('Select SerialNumber From Win32_DiskDrive','WQL', 0, nil);
  Item := Root.ItemIndex(0);
  snTemp:=VarToStr(Item.SerialNumber);

  snTemp := ReplaceStr(snTemp, '_', '');
  snTemp := ReplaceStr(snTemp, '.', '');
  Result := RightStr(snTemp,8);
end;

procedure TfrmAktifasi.lblIzinClick(Sender: TObject);
begin
  rbIzin.Checked := True;
end;

procedure TfrmAktifasi.lblKeluarClick(Sender: TObject);
begin
  rbKeluar.Checked := True;
end;

end.
