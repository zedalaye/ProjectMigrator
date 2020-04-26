object ProjectMigratorMainForm: TProjectMigratorMainForm
  Left = 0
  Top = 0
  Caption = 'Project Migrator - '#169'2020 - PrY -'
  ClientHeight = 515
  ClientWidth = 1079
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pSource: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 320
    Height = 509
    Align = alLeft
    Caption = 'pSource'
    TabOrder = 0
    object pSourceToolbar: TPanel
      Left = 1
      Top = 1
      Width = 318
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pSourceToolbar'
      ShowCaption = False
      TabOrder = 0
      object lbSource: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 312
        Height = 13
        Align = alTop
        Caption = 'Source'
      end
      object btnSourceRefresh: TSpeedButton
        AlignWithMargins = True
        Left = 289
        Top = 16
        Width = 26
        Height = 29
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        OnClick = btnSourceRefreshClick
      end
      object deSource: TJvDirectoryEdit
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 283
        Height = 23
        TextHint = 'Original project sources'
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = ''
      end
    end
    object vstSource: TVirtualStringTree
      AlignWithMargins = True
      Left = 6
      Top = 51
      Width = 308
      Height = 452
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      DragType = dtVCL
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      PopupMenu = pmActions
      TabOrder = 1
      TreeOptions.SelectionOptions = [toLevelSelectConstraint, toMultiSelect]
      OnDragAllowed = vstSourceDragAllowed
      OnDragOver = vstSourceDragOver
      OnFreeNode = TreeFreeNode
      OnGetText = TreeGetText
      OnPaintText = TreePaintText
      OnInitNode = TreeInitNode
      OnLoadNode = TreeLoadNode
      OnSaveNode = TreeSaveNode
      Columns = <>
    end
  end
  object pDestination: TPanel
    AlignWithMargins = True
    Left = 329
    Top = 3
    Width = 320
    Height = 509
    Align = alLeft
    Caption = 'pDestination'
    TabOrder = 1
    object pDestinationToolbar: TPanel
      Left = 1
      Top = 1
      Width = 318
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pSourceToolbar'
      ShowCaption = False
      TabOrder = 0
      object lbDestination: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 312
        Height = 13
        Align = alTop
        Caption = 'Destination'
      end
      object btnDestinationRefresh: TSpeedButton
        AlignWithMargins = True
        Left = 260
        Top = 16
        Width = 26
        Height = 29
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        OnClick = btnDestinationRefreshClick
      end
      object btnCreateTree: TSpeedButton
        AlignWithMargins = True
        Left = 289
        Top = 16
        Width = 26
        Height = 29
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        OnClick = btnCreateTreeClick
      end
      object deDestination: TJvDirectoryEdit
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 254
        Height = 23
        TextHint = 'New project sources'
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = ''
      end
    end
    object vstDestination: TVirtualStringTree
      AlignWithMargins = True
      Left = 6
      Top = 51
      Width = 308
      Height = 452
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      DragType = dtVCL
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      TabOrder = 1
      OnDragOver = vstDestinationDragOver
      OnDragDrop = vstDestinationDragDrop
      OnFreeNode = TreeFreeNode
      OnGetText = TreeGetText
      OnPaintText = TreePaintText
      OnInitNode = TreeInitNode
      OnLoadNode = TreeLoadNode
      OnSaveNode = TreeSaveNode
      Columns = <>
    end
  end
  object pScript: TPanel
    AlignWithMargins = True
    Left = 655
    Top = 3
    Width = 421
    Height = 509
    Align = alClient
    Caption = 'pScript'
    TabOrder = 2
    object mScript: TMemo
      AlignWithMargins = True
      Left = 6
      Top = 51
      Width = 409
      Height = 452
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object pScriptToolbar: TPanel
      Left = 1
      Top = 1
      Width = 419
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pScriptToolbar'
      ShowCaption = False
      TabOrder = 1
      object btnCheck: TSpeedButton
        AlignWithMargins = True
        Left = 361
        Top = 19
        Width = 26
        Height = 26
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alRight
        OnClick = btnCheckClick
      end
      object lbScript: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 413
        Height = 13
        Align = alTop
        Caption = 'Migration script'
      end
      object btnSave: TSpeedButton
        AlignWithMargins = True
        Left = 390
        Top = 19
        Width = 26
        Height = 26
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alRight
        OnClick = btnSaveClick
      end
      object pbCheckProgress: TProgressBar
        AlignWithMargins = True
        Left = 5
        Top = 23
        Width = 353
        Height = 17
        Margins.Left = 5
        Margins.Top = 7
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object pmActions: TPopupMenu
    Left = 27
    Top = 124
    object miDelete: TMenuItem
      Caption = 'Delete'
      OnClick = miDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miUnmark: TMenuItem
      Caption = 'Unmark'
      OnClick = miUnmarkClick
    end
    object miMarkMoved: TMenuItem
      Caption = 'Mark moved'
      OnClick = miMarkMovedClick
    end
    object miMarkDeleted: TMenuItem
      Caption = 'Mark deleted'
      OnClick = miMarkDeletedClick
    end
  end
  object ilIcons: TImageList
    ColorDepth = cd32Bit
    Left = 27
    Top = 68
    Bitmap = {
      494C010104001800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000051000000AC0000000A0000
      00000000000C0000005A00000095000000B2000000AF0000008D0000004B0000
      0005000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000071000000FF000000C20000
      0075000000EE000000FF000000FF000000FF000000FF000000FF000000FF0000
      00DF000000520000000000000000000000000000000000000000000000000000
      0000000000000808081B0B090922000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000076000000BB0000
      00BB000000BB000000BB000000BB000000BB000000BB000000BB000000BB0000
      00BB000000BB000000BB00000071000000000000000000000000050505380A0A
      0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A
      0A600A0A0A6005050538000000000000000000000071000000FF000000FF0000
      00FF000000FF000000FF000000FE000000EA000000EE000000FF000000FF0000
      00FF000000FF0000008800000000000000000000000000000000000000000000
      000007070717424141D7454343DF0808081D0000000000000000000000000000
      00000000000000000000000000000000000000000000000000A1000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF00000099000000000000000000000000121212BF1919
      19FF191919FF191919FF191919FF191919FF191919FF191919FF191919FF1919
      19FF191919FF121212BF000000000000000000000071000000FF000000FF0000
      00FF000000FF00000088000000160000000000000000000000230000008C0000
      00FA000000FF000000FF00000071000000000000000000000000000000000606
      0613413F3FD24F4D4DFF4F4D4DFF444141DA0707071800000000000000000000
      00000000000000000000000000000000000000000000000000A1000000FF0000
      009A0000004E0000004E0000004E0000004E0000004E0000004E0000004E0000
      004E0000009A000000FF00000099000000000000000000000000151515E51919
      19FF191919FF191919FF191919FF161616E3161616E3191919FF191919FF1919
      19FF191919FF151515E5000000000000000000000071000000FF000000FF0000
      00FF000000FF000000D80000001B000000000000000000000000000000000000
      0042000000F6000000FF000000F70000001E00000000000000000404040F3F3D
      3DCB4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF434040D406060614000000000000
      00000000000000000000000000000000000000000000000000A1000000FF0000
      006D000000000000000000000000000000000000000000000000000000000000
      00000000006D000000FF0000009900000000000000000101010D191919FE1919
      19FF191919FF191919FF191919FF101010A0101010A0191919FF191919FF1919
      19FF191919FF191919FE0101010D0000000000000070000000FF000000FF0000
      00FF000000FF000000FF000000B9000000000000000000000000000000000000
      00000000006F000000FF000000FF00000088000000000303030C3D3A3AC54F4D
      4DFF4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF3F3D3DCE050505100000
      0000000000000000000000000000000000000000000000000036000000550000
      00240000000000000000000000000000002D0000004400000000000000000000
      0000000000240000005500000033000000000000000005050532191919FF1919
      19FF191919FF151515E5101010A50A0A0A670A0A0A67101010A5161616E31919
      19FF191919FF191919FF05050532000000000000000B00000027000000260000
      0026000000270000002700000013000000000000000000000000000000000000
      000000000008000000F1000000FF000000D1020202093C3939BE4F4D4DFF4F4D
      4DFF4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF3D3C3CC70303
      030D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000034000000EB000000F100000047000000000000
      0000000000000000000000000000000000000000000008080858191919FF1919
      19FF191919FF161616E10F0F0F9B090909610A0A0A64101010A0161616E31919
      19FF191919FF191919FF08080858000000000000006F000000700000004F0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000C0000000FF000000F6292828874F4D4DFF4F4D4DFF4F4D
      4DFF4F4D4DFF3A3A3AC0383636B54F4D4DFF4F4D4DFF4F4D4DFF4F4D4DFF3B3A
      3AC10303030A0000000000000000000000000000000000000000000000000000
      0000000000000000003F000000EE000000FF000000FF000000F4000000550000
      000000000000000000000000000000000000000000000C0C0C7F191919FF1919
      19FF191919FF191919FF191919FF101010A0101010A0191919FF191919FF1919
      19FF191919FF191919FF0C0C0C7F00000000000000F7000000FF000000BE0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000005000000071000000700303030E3E3C3CC94F4D4DFF4F4D
      4DFF3D3C3CC70303030D020202093A3A3ABC4F4D4DFF4F4D4DFF4F4D4DFF4F4D
      4DFF3A3838BA0101010700000000000000000000000000000000000000000000
      000000000035000000F3000000E0000000F8000000F4000000DA000000FB0000
      00530000000000000000000000000000000000000000101010A5191919FF1919
      19FF191919FF191919FF191919FF161616E3161616E3191919FF191919FF1919
      19FF191919FF191919FF101010A500000000000000D2000000FF000000F00000
      0007000000000000000000000000000000000000000000000012000000260000
      00250000002500000025000000260000000A0000000004040411403F3FCF403E
      3ECD0505051000000000000000000303030B3C3B3BC44F4D4DFF4F4D4DFF4F4D
      4DFF4F4D4DFF373535B201010105000000000000000000000000000000000000
      000000000019000000AB0000002F000000F3000000EB0000001F000000B10000
      002B0000000000000000000000000000000000000000141414CB171717E71212
      12AC121212AC121212AC121212AC121212AC121212AC121212AC121212AC1212
      12AC121212AC171717E7141414CB0000000000000089000000FF000000FF0000
      006D0000000000000000000000000000000000000000000000BB000000FF0000
      00FF000000FF000000FF000000FF0000006D0000000000000000050505150606
      0614000000000000000000000000000000000303030F3F3D3DCA4F4D4DFF4F4D
      4DFF4F4D4DFF4F4D4DFF353333AA000000030000000000000000000000000000
      0000000000000000000000000019000000F3000000EB00000009000000000000
      00000000000000000000000000000000000000000000090909590E0E0E860E0E
      0E910E0E0E910E0E0E910E0E0E910E0E0E910E0E0E910E0E0E910E0E0E910E0E
      0E910E0E0E910E0E0E8609090956000000000000001F000000F7000000FF0000
      00F500000040000000000000000000000000000000000000001D000000DA0000
      00FF000000FF000000FF000000FF0000006F0000000000000000000000000000
      0000000000000000000000000000000000000000000005050512403F3FD14F4D
      4DFF4F4D4DFF4F4D4DFF4F4D4DFF282727820000000000000000000000000000
      0000000000000000000000000019000000F3000000EB00000009000000000000
      00000000000000000000000000000000000000000000000000000E0E0E981515
      15D90F0F0F9A0F0F0F9A0F0F0F9A0F0F0F9A0F0F0F9A0F0F0F9A0F0F0F9A0F0F
      0F9A151515DA1010109900000000000000000000000000000073000000FF0000
      00FF000000FA0000008900000021000000000000000000000015000000880000
      00FF000000FF000000FF000000FF0000006F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000060606164240
      40D64F4D4DFF4F4D4DFF424141D7060606160000000000000000000000000000
      0000000000000000000000000019000000F3000000EB00000009000000000000
      0000000000000000000000000000000000000000000000000000050505360E0E
      0E8A111111A3111111A3111111A3111111A3111111A3111111A3111111A31111
      11A30D0D0D8805050534000000000000000000000000000000000000008B0000
      00FF000000FF000000FF000000FF000000ED000000E8000000FE000000FF0000
      00FF000000FF000000FF000000FF0000006F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000707
      071A434242DC434242DC0707071A000000000000000000000000000000000000
      0000000000000000000000000017000000E2000000DB00000009000000000000
      0000000000000000000000000000000000000000000000000000000000001212
      12AD191919FF191919FF191919FF191919FF191919FF191919FF191919FF1919
      19FF111111AA0000000000000000000000000000000000000000000000000000
      0055000000E1000000FF000000FF000000FF000000FF000000FF000000FF0000
      00EF00000076000000C5000000FF0000006F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000908081F0908081F00000000000000000000000000000000000000000000
      0000000000000000000000000002000000100000000F00000001000000000000
      0000000000000000000000000000000000000000000000000000000000000707
      07400A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A0A600A0A
      0A600606063F0000000000000000000000000000000000000000000000000000
      0000000000050000004D0000008F000000B0000000B3000000970000005B0000
      000C000000000000000B000000AE000000500000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000100FFFFFFFFFFFFF0007F9FF8001C003
      0003F0FF8001C0030181E07F8001C00301E0C03F8FF1800101F0801F8E718001
      01F0000FFC3F80011FF80007F81F80011FF80003F00F80010F808601F00F8001
      0F80CF00FC3F80010780FF80FC3FC0038180FFC0FC3FC003C000FFE1FC3FE007
      E000FFF3FC3FE007F008FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
