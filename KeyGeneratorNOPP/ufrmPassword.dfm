object frmPassword: TfrmPassword
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmPassword'
  ClientHeight = 67
  ClientWidth = 240
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
  object edtPassword: TEdit
    Left = 34
    Top = 20
    Width = 171
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = edtPasswordKeyPress
  end
end
