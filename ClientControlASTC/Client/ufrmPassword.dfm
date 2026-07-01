object frmPassword: TfrmPassword
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmPassword'
  ClientHeight = 117
  ClientWidth = 323
  Color = clGrayText
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 40
    Top = 31
    Width = 243
    Height = 14
    Caption = 'Opo password e, lek memang wes izin ?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtPassword: TEdit
    Left = 25
    Top = 60
    Width = 273
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = edtPasswordKeyPress
  end
end
