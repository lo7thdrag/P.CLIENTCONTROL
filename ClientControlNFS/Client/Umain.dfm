object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Client'
  ClientHeight = 277
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBody: TAdvSmoothPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 277
    Cursor = crDefault
    Caption.Location = plTopCenter
    Caption.HatchStyle = HatchStyleDiagonalBrick
    Caption.HTMLFont.Charset = DEFAULT_CHARSET
    Caption.HTMLFont.Color = clWindowText
    Caption.HTMLFont.Height = -13
    Caption.HTMLFont.Name = 'Tahoma'
    Caption.HTMLFont.Style = []
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -16
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = [fsBold]
    Caption.Top = 20
    Caption.ColorStart = clWhite
    Caption.ColorEnd = clWhite
    Caption.GradientType = gtHorizontal
    Caption.LineColor = clBlack
    Caption.Line = False
    Fill.Color = 14939662
    Fill.ColorTo = 16777164
    Fill.ColorMirror = 16777164
    Fill.ColorMirrorTo = 14939662
    Fill.GradientType = gtVertical
    Fill.GradientMirrorType = gtVertical
    Fill.BorderColor = clSilver
    Fill.BorderWidth = 5
    Fill.Rounding = 10
    Fill.ShadowColor = clNone
    Fill.ShadowOffset = 10
    Fill.Glow = gmNone
    Version = '1.6.0.1'
    Align = alClient
    TabOrder = 0
    TMSStyle = 0
    object lblClearLog: TLabel
      Left = 12
      Top = 244
      Width = 67
      Height = 19
      Cursor = crHandPoint
      Caption = 'Clear Log'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Deusex'
      Font.Style = []
      ParentFont = False
      OnClick = lblClearLogClick
    end
    object LogMemo: TMemo
      Left = 11
      Top = 11
      Width = 345
      Height = 222
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object btnClose: TButton
      Left = 281
      Top = 241
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object GetPacketTimer: TTimer
    Enabled = False
    OnTimer = GetPacketTimerTimer
    Left = 9
    Top = 1
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 42
    Top = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 107
    Top = 1
    object Show1: TMenuItem
      Caption = '&Show'
      OnClick = Show1Click
    end
    object Hide1: TMenuItem
      Caption = '&Hide'
      OnClick = Hide1Click
    end
  end
  object tmrCekApplication: TTimer
    OnTimer = tmrCekApplicationTimer
    Left = 74
    Top = 2
  end
end
