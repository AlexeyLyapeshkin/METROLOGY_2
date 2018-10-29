object Form1: TForm1
  Left = 2584
  Top = 312
  Width = 930
  Height = 570
  Caption = 'Best Lab In'#39'da world'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mainmenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SG1: TStringGrid
    Left = 0
    Top = 0
    Width = 914
    Height = 511
    Align = alClient
    ColCount = 6
    DefaultColWidth = 152
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 0
  end
  object mainmenu: TMainMenu
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object Open: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = OpenClick
      end
    end
  end
  object dlgOpen1: TOpenDialog
    Left = 32
    Top = 48
  end
end
