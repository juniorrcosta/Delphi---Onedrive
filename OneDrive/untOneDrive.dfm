object frmOneDrive: TfrmOneDrive
  Left = 0
  Top = 0
  Caption = 'OneDrive'
  ClientHeight = 426
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 409
    Height = 184
    Caption = '  Fun'#231#245'es de Login  '
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 64
      Width = 89
      Height = 33
      Caption = 'Get Acess Code'
      TabOrder = 0
      OnClick = Button1Click
    end
    object EdtAcessCode: TLabeledEdit
      Left = 111
      Top = 76
      Width = 285
      Height = 21
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Acess Code'
      TabOrder = 1
    end
    object Button2: TButton
      Left = 359
      Top = 104
      Width = 37
      Height = 33
      Caption = 'Set Token'
      TabOrder = 2
      WordWrap = True
    end
    object edtAcessToken: TLabeledEdit
      Left = 111
      Top = 116
      Width = 242
      Height = 21
      EditLabel.Width = 60
      EditLabel.Height = 13
      EditLabel.Caption = 'Acess Token'
      TabOrder = 3
    end
    object Button3: TButton
      Left = 16
      Top = 104
      Width = 89
      Height = 33
      Caption = 'Get Acess Token'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Panel1: TPanel
      Left = 111
      Top = 142
      Width = 285
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object Button4: TButton
      Left = 16
      Top = 16
      Width = 380
      Height = 42
      Caption = 'Full Login - Acess Code + Acess Token + Account Ifo'
      TabOrder = 6
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 16
      Top = 142
      Width = 89
      Height = 33
      Caption = 'Refresh Token'
      TabOrder = 7
      OnClick = Button5Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 423
    Top = 8
    Width = 238
    Height = 184
    Caption = '  Account Info  '
    TabOrder = 1
    object Image1: TImage
      Left = 9
      Top = 47
      Width = 96
      Height = 96
      Proportional = True
    end
    object Label1: TLabel
      Left = 111
      Top = 47
      Width = 33
      Height = 13
      Caption = 'Email:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 111
      Top = 80
      Width = 79
      Height = 13
      Caption = 'Display Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 111
      Top = 113
      Width = 98
      Height = 13
      Caption = 'Given + Surname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 155
      Width = 65
      Height = 13
      Caption = 'Account ID:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblemail: TLabel
      Left = 114
      Top = 61
      Width = 121
      Height = 13
      AutoSize = False
    end
    object lbldname: TLabel
      Left = 111
      Top = 94
      Width = 121
      Height = 13
      AutoSize = False
    end
    object lblgsname: TLabel
      Left = 111
      Top = 132
      Width = 121
      Height = 13
      AutoSize = False
    end
    object lblaccID: TLabel
      Left = 86
      Top = 147
      Width = 144
      Height = 31
      Alignment = taCenter
      AutoSize = False
      Layout = tlCenter
      WordWrap = True
    end
    object Button6: TButton
      Left = 7
      Top = 16
      Width = 110
      Height = 25
      Caption = 'Get Account Info'
      TabOrder = 0
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 120
      Top = 16
      Width = 110
      Height = 25
      Caption = 'Get Photo'
      TabOrder = 1
      OnClick = Button7Click
    end
  end
  object Memo1: TMemo
    Left = 422
    Top = 198
    Width = 239
    Height = 220
    TabOrder = 2
  end
end
