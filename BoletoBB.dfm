object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Registro de Boleto - Banco do Brasil API'
  ClientHeight = 700
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pgcPrincipal: TPageControl
    Left = 8
    Top = 8
    Width = 904
    Height = 540
    ActivePage = tabCredenciais
    TabOrder = 0
    object tabCedente: TTabSheet
      Caption = 'Cedente'
      object grpCedente: TGroupBox
        Left = 8
        Top = 4
        Width = 880
        Height = 500
        Caption = 'Dados do Cedente'
        TabOrder = 0
        object lblCedenteNome: TLabel
          Left = 16
          Top = 28
          Width = 100
          Height = 15
          Caption = 'Nome do Cedente:'
        end
        object lblCedenteCNPJ: TLabel
          Left = 16
          Top = 82
          Width = 56
          Height = 15
          Caption = 'CNPJ/CPF:'
        end
        object lblCedenteAgencia: TLabel
          Left = 16
          Top = 136
          Width = 46
          Height = 15
          Caption = 'Agencia:'
        end
        object lblCedenteAgenciaDigito: TLabel
          Left = 148
          Top = 136
          Width = 56
          Height = 15
          Caption = 'Digito Ag.:'
        end
        object lblCedenteConta: TLabel
          Left = 16
          Top = 190
          Width = 35
          Height = 15
          Caption = 'Conta:'
        end
        object lblCedenteContaDigito: TLabel
          Left = 178
          Top = 190
          Width = 53
          Height = 15
          Caption = 'Digito Ct.:'
        end
        object lblCedenteConvenio: TLabel
          Left = 16
          Top = 244
          Width = 54
          Height = 15
          Caption = 'Convenio:'
        end
        object lblCedenteModalidade: TLabel
          Left = 16
          Top = 298
          Width = 66
          Height = 15
          Caption = 'Modalidade:'
        end
        object edtCedenteNome: TEdit
          Left = 16
          Top = 46
          Width = 840
          Height = 23
          TabOrder = 0
        end
        object edtCedenteCNPJ: TEdit
          Left = 16
          Top = 100
          Width = 220
          Height = 23
          TabOrder = 1
        end
        object edtCedenteAgencia: TEdit
          Left = 16
          Top = 154
          Width = 120
          Height = 23
          TabOrder = 2
        end
        object edtCedenteAgenciaDigito: TEdit
          Left = 148
          Top = 154
          Width = 60
          Height = 23
          TabOrder = 3
        end
        object edtCedenteConta: TEdit
          Left = 16
          Top = 208
          Width = 150
          Height = 23
          TabOrder = 4
        end
        object edtCedenteContaDigito: TEdit
          Left = 178
          Top = 208
          Width = 60
          Height = 23
          TabOrder = 5
        end
        object edtCedenteConvenio: TEdit
          Left = 16
          Top = 262
          Width = 180
          Height = 23
          TabOrder = 6
        end
        object edtCedenteModalidade: TEdit
          Left = 16
          Top = 316
          Width = 100
          Height = 23
          TabOrder = 7
        end
      end
    end
    object tabCredenciais: TTabSheet
      Caption = 'Credenciais API'
      object grpCredenciais: TGroupBox
        Left = 0
        Top = 7
        Width = 880
        Height = 500
        Caption = 'Credenciais de Acesso a API do Banco do Brasil'
        TabOrder = 0
        object lblClientID: TLabel
          Left = 16
          Top = 28
          Width = 48
          Height = 15
          Caption = 'Client ID:'
        end
        object lblClientSecret: TLabel
          Left = 16
          Top = 82
          Width = 69
          Height = 15
          Caption = 'Client Secret:'
        end
        object lblKeyUser: TLabel
          Left = 16
          Top = 136
          Width = 146
          Height = 15
          Caption = 'App Key (gw-dev-app-key):'
        end
        object lblScope: TLabel
          Left = 16
          Top = 190
          Width = 35
          Height = 15
          Caption = 'Scope:'
        end
        object edtClientID: TEdit
          Left = 16
          Top = 49
          Width = 500
          Height = 23
          TabOrder = 0
        end
        object edtClientSecret: TEdit
          Left = 16
          Top = 103
          Width = 500
          Height = 23
          PasswordChar = '*'
          TabOrder = 1
        end
        object edtKeyUser: TEdit
          Left = 16
          Top = 154
          Width = 500
          Height = 23
          TabOrder = 2
        end
        object edtScope: TEdit
          Left = 16
          Top = 208
          Width = 840
          Height = 23
          TabOrder = 3
        end
        object chkIndicadorPix: TCheckBox
          Left = 16
          Top = 254
          Width = 160
          Height = 17
          Caption = 'Indicador PIX'
          TabOrder = 4
        end
        object chkHomologacao: TCheckBox
          Left = 200
          Top = 254
          Width = 210
          Height = 17
          Caption = 'Homologacao (Sandbox)'
          TabOrder = 5
        end
      end
    end
    object tabBoleto: TTabSheet
      Caption = 'Boleto'
      object grpBoleto: TGroupBox
        Left = 8
        Top = 4
        Width = 880
        Height = 500
        Caption = 'Dados do Boleto'
        TabOrder = 0
        object lblNumeroDoc: TLabel
          Left = 16
          Top = 28
          Width = 130
          Height = 15
          Caption = 'Numero do Documento:'
        end
        object lblNossoNumero: TLabel
          Left = 216
          Top = 28
          Width = 83
          Height = 15
          Caption = 'Nosso Numero:'
        end
        object lblValor: TLabel
          Left = 16
          Top = 82
          Width = 53
          Height = 15
          Caption = 'Valor (R$):'
        end
        object lblDataDocumento: TLabel
          Left = 16
          Top = 136
          Width = 110
          Height = 15
          Caption = 'Data do Documento:'
        end
        object lblVencimento: TLabel
          Left = 196
          Top = 136
          Width = 66
          Height = 15
          Caption = 'Vencimento:'
        end
        object lblCarteira: TLabel
          Left = 16
          Top = 190
          Width = 44
          Height = 15
          Caption = 'Carteira:'
        end
        object lblEspecieMod: TLabel
          Left = 136
          Top = 190
          Width = 108
          Height = 15
          Caption = 'Especie Modalidade:'
        end
        object lblEspecieDoc: TLabel
          Left = 16
          Top = 244
          Width = 125
          Height = 15
          Caption = 'Especie do Documento:'
        end
        object lblAceite: TLabel
          Left = 216
          Top = 244
          Width = 36
          Height = 15
          Caption = 'Aceite:'
        end
        object edtNumeroDoc: TEdit
          Left = 16
          Top = 46
          Width = 180
          Height = 23
          TabOrder = 0
        end
        object edtNossoNumero: TEdit
          Left = 216
          Top = 46
          Width = 180
          Height = 23
          TabOrder = 1
        end
        object edtValor: TEdit
          Left = 16
          Top = 100
          Width = 150
          Height = 23
          TabOrder = 2
        end
        object dtpDataDocumento: TDateTimePicker
          Left = 16
          Top = 154
          Width = 160
          Height = 23
          Date = 46152.000000000000000000
          Time = 0.640157187503064100
          TabOrder = 3
        end
        object dtpVencimento: TDateTimePicker
          Left = 196
          Top = 154
          Width = 160
          Height = 23
          Date = 46152.000000000000000000
          Time = 0.640157187503064100
          TabOrder = 4
        end
        object edtCarteira: TEdit
          Left = 16
          Top = 208
          Width = 100
          Height = 23
          TabOrder = 5
        end
        object edtEspecieMod: TEdit
          Left = 136
          Top = 208
          Width = 100
          Height = 23
          TabOrder = 6
        end
        object cmbEspecieDoc: TComboBox
          Left = 16
          Top = 262
          Width = 180
          Height = 23
          Style = csDropDownList
          TabOrder = 7
          Items.Strings = (
            'DM'
            'DS'
            'NP'
            'RC'
            'AP'
            'CH'
            'LC'
            'LE'
            'NS'
            'OM')
        end
        object cmbAceite: TComboBox
          Left = 216
          Top = 262
          Width = 120
          Height = 23
          Style = csDropDownList
          TabOrder = 8
          Items.Strings = (
            'Sim'
            'Nao')
        end
      end
    end
    object tabSacado: TTabSheet
      Caption = 'Sacado'
      object grpSacado: TGroupBox
        Left = 8
        Top = 4
        Width = 880
        Height = 500
        Caption = 'Dados do Sacado (Pagador)'
        TabOrder = 0
        object lblSacadoNome: TLabel
          Left = 16
          Top = 28
          Width = 36
          Height = 15
          Caption = 'Nome:'
        end
        object lblSacadoCNPJ: TLabel
          Left = 16
          Top = 82
          Width = 56
          Height = 15
          Caption = 'CNPJ/CPF:'
        end
        object lblSacadoLogradouro: TLabel
          Left = 16
          Top = 136
          Width = 65
          Height = 15
          Caption = 'Logradouro:'
        end
        object lblSacadoNumero: TLabel
          Left = 668
          Top = 136
          Width = 47
          Height = 15
          Caption = 'Numero:'
        end
        object lblSacadoBairro: TLabel
          Left = 16
          Top = 190
          Width = 34
          Height = 15
          Caption = 'Bairro:'
        end
        object lblSacadoCidade: TLabel
          Left = 308
          Top = 190
          Width = 40
          Height = 15
          Caption = 'Cidade:'
        end
        object lblSacadoUF: TLabel
          Left = 660
          Top = 190
          Width = 17
          Height = 15
          Caption = 'UF:'
        end
        object lblSacadoCEP: TLabel
          Left = 16
          Top = 244
          Width = 24
          Height = 15
          Caption = 'CEP:'
        end
        object lblSacadoComplemento: TLabel
          Left = 16
          Top = 298
          Width = 80
          Height = 15
          Caption = 'Complemento:'
        end
        object lblSacadoEmail: TLabel
          Left = 16
          Top = 352
          Width = 32
          Height = 15
          Caption = 'Email:'
        end
        object edtSacadoNome: TEdit
          Left = 16
          Top = 46
          Width = 840
          Height = 23
          TabOrder = 0
        end
        object edtSacadoCNPJ: TEdit
          Left = 16
          Top = 100
          Width = 220
          Height = 23
          TabOrder = 1
        end
        object edtSacadoLogradouro: TEdit
          Left = 16
          Top = 154
          Width = 640
          Height = 23
          TabOrder = 2
        end
        object edtSacadoNumero: TEdit
          Left = 668
          Top = 154
          Width = 188
          Height = 23
          TabOrder = 3
        end
        object edtSacadoBairro: TEdit
          Left = 16
          Top = 208
          Width = 280
          Height = 23
          TabOrder = 4
        end
        object edtSacadoCidade: TEdit
          Left = 308
          Top = 208
          Width = 340
          Height = 23
          TabOrder = 5
        end
        object cmbSacadoUF: TComboBox
          Left = 660
          Top = 208
          Width = 80
          Height = 23
          Style = csDropDownList
          TabOrder = 6
          Items.Strings = (
            'AC'
            'AL'
            'AM'
            'AP'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MA'
            'MG'
            'MS'
            'MT'
            'PA'
            'PB'
            'PE'
            'PI'
            'PR'
            'RJ'
            'RN'
            'RO'
            'RR'
            'RS'
            'SC'
            'SE'
            'SP'
            'TO')
        end
        object edtSacadoCEP: TEdit
          Left = 16
          Top = 262
          Width = 120
          Height = 23
          TabOrder = 7
        end
        object edtSacadoComplemento: TEdit
          Left = 16
          Top = 316
          Width = 840
          Height = 23
          TabOrder = 8
        end
        object edtSacadoEmail: TEdit
          Left = 16
          Top = 370
          Width = 400
          Height = 23
          TabOrder = 9
        end
      end
    end
  end
  object mmoStatus: TMemo
    Left = 8
    Top = 556
    Width = 775
    Height = 135
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnRegistrar: TButton
    Left = 791
    Top = 556
    Width = 121
    Height = 55
    Caption = 'Registrar Boleto'
    TabOrder = 2
    OnClick = btnRegistrarClick
  end
  object btnLimpar: TButton
    Left = 791
    Top = 619
    Width = 121
    Height = 30
    Caption = 'Limpar'
    TabOrder = 3
    OnClick = btnLimparClick
  end
  object ACBrBoleto1: TACBrBoleto
    Banco.TamanhoMaximoNossoNum = 10
    Banco.TipoCobranca = cobNenhum
    Banco.LayoutVersaoArquivo = 0
    Banco.LayoutVersaoLote = 0
    Banco.CasasDecimaisMoraJuros = 2
    Cedente.TipoInscricao = pJuridica
    Cedente.PIX.TipoChavePIX = tchNenhuma
    Cedente.IntegradoraBoleto = tibNenhum
    NumeroArquivo = 0
    Configuracoes.Arquivos.LogNivel = logNenhum
    Configuracoes.WebService.SSLHttpLib = httpWinHttp
    Configuracoes.WebService.StoreName = 'My'
    Configuracoes.WebService.Ambiente = tawsHomologacao
    Configuracoes.WebService.Operacao = tpInclui
    Configuracoes.WebService.VersaoDF = '1.2'
    Left = 40
    Top = 648
  end
  object ACBrBoletoFCFR1: TACBrBoletoFCFR
    ModoThread = False
    IncorporarBackgroundPdf = False
    IncorporarFontesPdf = False
    Left = 120
    Top = 648
  end
end
