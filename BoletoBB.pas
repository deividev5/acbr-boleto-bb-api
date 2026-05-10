unit BoletoBB;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ACBrPIXCD, ACBrBoletoRetorno,
  ACBrBoleto, ACBrBoletoFCFortesFr, ACBrUtil.FilesIO, ACBrDFeSSL, ACBrBoletoConversao, ACBrBase,
  ACBrDFeUtil, ACBrUtil.Base, blcksock, Vcl.StdCtrls, ACBrBoletoFCFR,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.NetEncoding, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, System.StrUtils, ComObj;

type
  TForm1 = class(TForm)
    ACBrBoleto1: TACBrBoleto;
    ACBrBoletoFCFR1: TACBrBoletoFCFR;
    pgcPrincipal: TPageControl;
    tabCedente: TTabSheet;
    tabCredenciais: TTabSheet;
    tabBoleto: TTabSheet;
    tabSacado: TTabSheet;
    // --- Cedente ---
    grpCedente: TGroupBox;
    lblCedenteNome: TLabel;
    edtCedenteNome: TEdit;
    lblCedenteCNPJ: TLabel;
    edtCedenteCNPJ: TEdit;
    lblCedenteAgencia: TLabel;
    edtCedenteAgencia: TEdit;
    lblCedenteAgenciaDigito: TLabel;
    edtCedenteAgenciaDigito: TEdit;
    lblCedenteConta: TLabel;
    edtCedenteConta: TEdit;
    lblCedenteContaDigito: TLabel;
    edtCedenteContaDigito: TEdit;
    lblCedenteConvenio: TLabel;
    edtCedenteConvenio: TEdit;
    lblCedenteModalidade: TLabel;
    edtCedenteModalidade: TEdit;
    // --- Credenciais API ---
    grpCredenciais: TGroupBox;
    lblClientID: TLabel;
    edtClientID: TEdit;
    lblClientSecret: TLabel;
    edtClientSecret: TEdit;
    lblKeyUser: TLabel;
    edtKeyUser: TEdit;
    lblScope: TLabel;
    edtScope: TEdit;
    chkIndicadorPix: TCheckBox;
    chkHomologacao: TCheckBox;
    // --- Boleto ---
    grpBoleto: TGroupBox;
    lblNumeroDoc: TLabel;
    edtNumeroDoc: TEdit;
    lblNossoNumero: TLabel;
    edtNossoNumero: TEdit;
    lblValor: TLabel;
    edtValor: TEdit;
    lblDataDocumento: TLabel;
    dtpDataDocumento: TDateTimePicker;
    lblVencimento: TLabel;
    dtpVencimento: TDateTimePicker;
    lblCarteira: TLabel;
    edtCarteira: TEdit;
    lblEspecieMod: TLabel;
    edtEspecieMod: TEdit;
    lblEspecieDoc: TLabel;
    cmbEspecieDoc: TComboBox;
    lblAceite: TLabel;
    cmbAceite: TComboBox;
    // --- Sacado ---
    grpSacado: TGroupBox;
    lblSacadoNome: TLabel;
    edtSacadoNome: TEdit;
    lblSacadoCNPJ: TLabel;
    edtSacadoCNPJ: TEdit;
    lblSacadoLogradouro: TLabel;
    edtSacadoLogradouro: TEdit;
    lblSacadoNumero: TLabel;
    edtSacadoNumero: TEdit;
    lblSacadoBairro: TLabel;
    edtSacadoBairro: TEdit;
    lblSacadoCidade: TLabel;
    edtSacadoCidade: TEdit;
    lblSacadoUF: TLabel;
    cmbSacadoUF: TComboBox;
    lblSacadoCEP: TLabel;
    edtSacadoCEP: TEdit;
    lblSacadoComplemento: TLabel;
    edtSacadoComplemento: TEdit;
    lblSacadoEmail: TLabel;
    edtSacadoEmail: TEdit;
    // --- Rodape ---
    mmoStatus: TMemo;
    btnRegistrar: TButton;
    btnLimpar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
  private
    FTokenOAuth: string;
    FTokenValidade: TDateTime;
    procedure PreencherValoresPadrao;
    function ValidarCamposObrigatorios: Boolean;
    procedure ExibirLogNoMemo(const ALogPath: string);
    function ObterTokenOAuth(const AClientID, AClientSecret, AScope: string;
      AHomologacao: Boolean; out AToken: string): Boolean;
    function EspecieDocParaCodigo(const AEspecie: string): Integer;
    function EnviarBoletoDireto(const AToken, AAppKey: string; AHomologacao: Boolean;
      out ARespostaJSON: string): Boolean;
    procedure OnAntesAutenticarBoleto(var AToken: String; var AValidadeToken: TDateTime);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.ObterTokenOAuth(const AClientID, AClientSecret, AScope: string;
  AHomologacao: Boolean; out AToken: string): Boolean;
var
  Http: TNetHTTPClient;
  Params: TStringList;
  Resp: IHTTPResponse;
  JSON: TJSONObject;
  sURL, sBasic: string;
begin
  Result := False;
  AToken := '';

  sURL := 'https://oauth.sandbox.bb.com.br/oauth/token';
  if not AHomologacao then
    sURL := 'https://oauth.bb.com.br/oauth/token';

  sBasic := TNetEncoding.Base64.Encode(AClientID + ':' + AClientSecret);
  // Base64 do Delphi adiciona quebras de linha - remove
  sBasic := StringReplace(sBasic, #13, '', [rfReplaceAll]);
  sBasic := StringReplace(sBasic, #10, '', [rfReplaceAll]);

  Http := TNetHTTPClient.Create(nil);
  Params := TStringList.Create;
  try
    Http.SecureProtocols := [THTTPSecureProtocol.TLS12];
    Http.CustomHeaders['Authorization'] := 'Basic ' + sBasic;
    Http.ContentType := 'application/x-www-form-urlencoded';

    Params.Add('grant_type=client_credentials');
    Params.Add('scope=' + AScope);

    mmoStatus.Lines.Add('Obtendo token OAuth via TNetHTTPClient...');
    Resp := Http.Post(sURL, Params);

    if Resp.StatusCode in [200, 201] then
    begin
      JSON := TJSONObject.ParseJSONValue(Resp.ContentAsString()) as TJSONObject;
      try
        if Assigned(JSON) then
        begin
          AToken := JSON.GetValue<string>('access_token');
          Result := AToken <> '';
          mmoStatus.Lines.Add('Token obtido com sucesso!');
        end;
      finally
        JSON.Free;
      end;
    end
    else
    begin
      mmoStatus.Lines.Add('Falha OAuth HTTP ' + Resp.StatusCode.ToString + ': ' + Resp.ContentAsString());
    end;
  finally
    Params.Free;
    Http.Free;
  end;
end;

procedure TForm1.OnAntesAutenticarBoleto(var AToken: String; var AValidadeToken: TDateTime);
begin
  AToken := FTokenOAuth;
  AValidadeToken := FTokenValidade;
end;

function TForm1.EspecieDocParaCodigo(const AEspecie: string): Integer;
begin
  if AEspecie = 'DM'  then Result := 2
  else if AEspecie = 'DS'  then Result := 4
  else if AEspecie = 'LC'  then Result := 7
  else if AEspecie = 'NP'  then Result := 12
  else if AEspecie = 'RC'  then Result := 17
  else if AEspecie = 'ND'  then Result := 19
  else if AEspecie = 'FAT' then Result := 18
  else Result := 2; // padrao DM
end;

function TForm1.EnviarBoletoDireto(const AToken, AAppKey: string;
  AHomologacao: Boolean; out ARespostaJSON: string): Boolean;
var
  WinHttp: OleVariant;
  sURL, sJSON, sDoc, sEndereco, sSoDigitos: string;
  sConvenio, sNossoNum, sValor: string;
  dataEmissao, dataVenc: string;
  nConvenio, nCarteira, nVariacao, nCEP, tipoInscricao, nTipoTitulo: Integer;
  nDocInt64: Int64;
  ValorDoc: Double;
  FS: TFormatSettings;
  nStatus: Integer;
  I: Integer;
begin
  Result := False;
  ARespostaJSON := '';

  if AHomologacao then
    sURL := 'https://api.hm.bb.com.br/cobrancas/v2/boletos?gw-dev-app-key=' + AAppKey
  else
    sURL := 'https://api.bb.com.br/cobrancas/v2/boletos?gw-dev-app-key=' + AAppKey;

  // Datas no formato dd.mm.yyyy
  dataEmissao := FormatDateTime('dd.mm.yyyy', dtpDataDocumento.Date);
  dataVenc    := FormatDateTime('dd.mm.yyyy', dtpVencimento.Date);

  // Valor
  FS := TFormatSettings.Create;
  FS.DecimalSeparator  := '.';
  FS.ThousandSeparator := ',';
  sValor := StringReplace(Trim(edtValor.Text), '.', '', [rfReplaceAll]);
  sValor := StringReplace(sValor, ',', '.', [rfReplaceAll]);
  TryStrToFloat(sValor, ValorDoc, FS);

  nConvenio := StrToIntDef(Trim(edtCedenteConvenio.Text), 0);
  nCarteira := StrToIntDef(Trim(edtCarteira.Text), 0);
  // numeroVariacaoCarteira = campo Modalidade do cedente (ex: 35), nao EspecieMod
  nVariacao := StrToIntDef(Trim(edtCedenteModalidade.Text), 0);

  // CEP - so digitos
  sSoDigitos := '';
  for I := 1 to Length(edtSacadoCEP.Text) do
    if edtSacadoCEP.Text[I] in ['0'..'9'] then
      sSoDigitos := sSoDigitos + edtSacadoCEP.Text[I];
  nCEP := StrToIntDef(sSoDigitos, 0);

  // CPF/CNPJ - so digitos
  sDoc := '';
  for I := 1 to Length(edtSacadoCNPJ.Text) do
    if edtSacadoCNPJ.Text[I] in ['0'..'9'] then
      sDoc := sDoc + edtSacadoCNPJ.Text[I];
  if Length(sDoc) <= 11 then tipoInscricao := 1 else tipoInscricao := 2;
  nDocInt64 := StrToInt64Def(sDoc, 0);

  // Endereco
  sEndereco := Trim(edtSacadoLogradouro.Text);
  if Trim(edtSacadoNumero.Text) <> '' then
    sEndereco := sEndereco + ' ' + Trim(edtSacadoNumero.Text);

  // numeroTituloCliente
  sConvenio := edtCedenteConvenio.Text;
  while Length(sConvenio) < 7 do sConvenio := '0' + sConvenio;
  sNossoNum := edtNossoNumero.Text;
  while Length(sNossoNum) < 10 do sNossoNum := '0' + sNossoNum;

  nTipoTitulo := EspecieDocParaCodigo(cmbEspecieDoc.Text);

  sJSON :=
    '{' +
    '"numeroConvenio":' + IntToStr(nConvenio) + ',' +
    '"numeroCarteira":' + IntToStr(nCarteira) + ',' +
    '"numeroVariacaoCarteira":' + IntToStr(nVariacao) + ',' +
    '"codigoModalidade":1,' +
    '"dataEmissao":"' + dataEmissao + '",' +
    '"dataVencimento":"' + dataVenc + '",' +
    '"valorOriginal":' + FormatFloat('0.##', ValorDoc, FS) + ',' +
    '"valorAbatimento":0,' +
    '"quantidadeDiasProtesto":0,' +
    '"codigoAceite":"' + IfThen(cmbAceite.ItemIndex = 0, 'A', 'N') + '",' +
    '"codigoTipoTitulo":' + IntToStr(nTipoTitulo) + ',' +
    '"descricaoTipoTitulo":"' + cmbEspecieDoc.Text + '",' +
    '"indicadorPermissaoRecebimentoParcial":"N",' +
    '"campoUtilizacaoBeneficiario":"' + edtNumeroDoc.Text + '",' +
    '"numeroTituloBeneficiario":"' + edtNumeroDoc.Text + '",' +
    '"numeroTituloCliente":"000' + sConvenio + sNossoNum + '",' +
    '"mensagemBloquetoOcorrencia":"",' +
    '"pagador":{' +
      '"tipoInscricao":' + IntToStr(tipoInscricao) + ',' +
      '"numeroInscricao":' + IntToStr(nDocInt64) + ',' +
      '"nome":"' + edtSacadoNome.Text + '",' +
      '"endereco":"' + sEndereco + '",' +
      '"cep":' + IntToStr(nCEP) + ',' +
      '"cidade":"' + edtSacadoCidade.Text + '",' +
      '"bairro":"' + edtSacadoBairro.Text + '",' +
      '"uf":"' + cmbSacadoUF.Text + '"' +
    '},' +
    '"indicadorPix":"' + IfThen(chkIndicadorPix.Checked, 'S', 'N') + '"' +
    '}';

  mmoStatus.Lines.Add('JSON: ' + sJSON);
  mmoStatus.Lines.Add('Token recebido: [' + Copy(AToken, 1, 30) + '...] Len=' + IntToStr(Length(AToken)));
  mmoStatus.Lines.Add('URL: ' + sURL);
  mmoStatus.Lines.Add('Enviando boleto via WinHttp COM...');

  // Usa WinHttp COM - nativo do Windows, sem OpenSSL, headers garantidos
  WinHttp := CreateOleObject('WinHttp.WinHttpRequest.5.1');
  WinHttp.Open('POST', sURL, False);
  WinHttp.SetRequestHeader('Authorization', 'Bearer ' + AToken);
  WinHttp.SetRequestHeader('Content-Type', 'application/json; charset=utf-8');
  WinHttp.SetRequestHeader('Accept', 'application/json');
  WinHttp.Send(sJSON);

  nStatus := WinHttp.Status;
  ARespostaJSON := WinHttp.ResponseText;
  mmoStatus.Lines.Add('HTTP ' + IntToStr(nStatus) + ': ' + ARespostaJSON);
  Result := nStatus in [200, 201];
end;

procedure TForm1.ExibirLogNoMemo(const ALogPath: string);
begin
  mmoStatus.Lines.Add('');
  if FileExists(ALogPath) then
  begin
    mmoStatus.Lines.Add('=== LOG DE COMUNICACAO ===');
    mmoStatus.Lines.Add('(Arquivo: ' + ALogPath + ')');
    mmoStatus.Lines.Add('');
    mmoStatus.Lines.LoadFromFile(ALogPath);
  end
  else
    mmoStatus.Lines.Add('(arquivo de log nao encontrado em: ' + ALogPath + ')');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PreencherValoresPadrao;

  // Informa campos opcionais que podem enriquecer o boleto
  mmoStatus.Lines.Clear;
  mmoStatus.Lines.Add('=== CAMPOS OPCIONAIS NAO IMPLEMENTADOS (podem ser necessarios) ===');
  mmoStatus.Lines.Add('  * Titulo.Instrucao1 / Instrucao2   - Instrucoes de cobranca impressas no boleto');
  mmoStatus.Lines.Add('  * Titulo.LocalPagamento            - Onde o boleto pode ser pago');
  mmoStatus.Lines.Add('  * Titulo.Mora / Juros              - Valor ou % de juros apos vencimento');
  mmoStatus.Lines.Add('  * Titulo.Multa                     - Valor ou % de multa apos vencimento');
  mmoStatus.Lines.Add('  * Titulo.Desconto                  - Desconto para pagamento antecipado');
  mmoStatus.Lines.Add('  * Titulo.NomeSacadorAvalista       - Nome do sacador/avalista (se houver)');
  mmoStatus.Lines.Add('  * Sacado.Complemento               - Complemento do endereco (ja no formulario)');
  mmoStatus.Lines.Add('  * Sacado.Email                     - Email do pagador (ja no formulario)');
  mmoStatus.Lines.Add('  * Cedente.TipoInscricao            - PF ou PJ (padrao: pJuridica no DFM)');
  mmoStatus.Lines.Add('--------------------------------------------------------');
  mmoStatus.Lines.Add('Preencha os campos e clique em "Registrar Boleto".');
end;

procedure TForm1.PreencherValoresPadrao;
begin
  // Cedente - dados padrao do Sandbox BB
  edtCedenteNome.Text          := 'CLIENTE TESTE';
  edtCedenteCNPJ.Text          := '00000000000191';
  edtCedenteAgencia.Text       := '452';
  edtCedenteAgenciaDigito.Text := '4';
  edtCedenteConta.Text         := '123871';
  edtCedenteContaDigito.Text   := '1';
  edtCedenteConvenio.Text      := '3128557';
  edtCedenteModalidade.Text    := '35';

  // Credenciais API - preencha com dados reais do portal developers.bb.com.br
  edtClientID.Text     := '';
  edtClientSecret.Text := '';
  edtKeyUser.Text      := '';
  chkIndicadorPix.Checked  := True;
  chkHomologacao.Checked   := True;
  // Scope minimo para registro de boleto (deve estar habilitado no portal BB)
  edtScope.Text := 'cobrancas.boletos-requisicao';

  // Dados do Boleto
  edtNumeroDoc.Text  := '101';
  edtNossoNumero.Text := '14947076';
  edtValor.Text      := '100,50';
  dtpVencimento.Date     := Date + 10;
  dtpDataDocumento.Date  := Date;
  edtCarteira.Text   := '17';
  edtEspecieMod.Text := '019';
  cmbEspecieDoc.ItemIndex := cmbEspecieDoc.Items.IndexOf('DM');
  cmbAceite.ItemIndex := 1; // Nao

  // Sacado
  edtSacadoNome.Text      := 'Odorico Paraguasu';
  edtSacadoCNPJ.Text      := '97965940132';
  edtSacadoLogradouro.Text := 'Avenida Dias Gomes 1970';
  edtSacadoNumero.Text    := '10';
  edtSacadoBairro.Text    := 'Centro';
  edtSacadoCidade.Text    := 'Sucupira';
  cmbSacadoUF.ItemIndex   := cmbSacadoUF.Items.IndexOf('TO');
  edtSacadoCEP.Text       := '77458000';
end;

function TForm1.ValidarCamposObrigatorios: Boolean;
var
  Erros: TStringList;
begin
  Result := True;
  Erros := TStringList.Create;
  try
    // Cedente
    if Trim(edtCedenteNome.Text) = ''      then Erros.Add('- [Cedente] Nome do Cedente');
    if Trim(edtCedenteCNPJ.Text) = ''      then Erros.Add('- [Cedente] CNPJ/CPF');
    if Trim(edtCedenteAgencia.Text) = ''   then Erros.Add('- [Cedente] Agencia');
    if Trim(edtCedenteConta.Text) = ''     then Erros.Add('- [Cedente] Conta');
    if Trim(edtCedenteConvenio.Text) = ''  then Erros.Add('- [Cedente] Convenio');
    if Trim(edtCedenteModalidade.Text) = '' then Erros.Add('- [Cedente] Modalidade');
    // Credenciais
    if Trim(edtClientID.Text) = ''     then Erros.Add('- [API] Client ID');
    if Trim(edtClientSecret.Text) = '' then Erros.Add('- [API] Client Secret');
    if Trim(edtKeyUser.Text) = ''      then Erros.Add('- [API] App Key (gw-dev-app-key): campo obrigatorio');
    // Detecta placeholders comuns do portal BB
    if (LowerCase(Trim(edtKeyUser.Text)) = 'suaappkey') or
       (LowerCase(Trim(edtKeyUser.Text)) = 'sua-app-key') or
       (LowerCase(Trim(edtKeyUser.Text)) = 'gw-dev-app-key') then
      Erros.Add('- [API] App Key: o valor "' + Trim(edtKeyUser.Text) + '" e um placeholder.' + #13#10 +
                '        No portal BB, copie o valor real de "App Key" do seu aplicativo');
    if (LowerCase(Trim(edtClientID.Text)) = 'cliente-teste') or
       (LowerCase(Trim(edtClientSecret.Text)) = 'cliente-teste-secret') then
      Erros.Add('- [API] Client ID/Secret ainda com valores de exemplo. Use credenciais reais do portal BB.');
    // Boleto
    if Trim(edtNumeroDoc.Text) = ''   then Erros.Add('- [Boleto] Numero do Documento');
    if Trim(edtNossoNumero.Text) = '' then Erros.Add('- [Boleto] Nosso Numero');
    if Trim(edtValor.Text) = ''       then Erros.Add('- [Boleto] Valor');
    if Trim(edtCarteira.Text) = ''    then Erros.Add('- [Boleto] Carteira');
    if cmbEspecieDoc.ItemIndex < 0    then Erros.Add('- [Boleto] Especie do Documento');
    // Sacado
    if Trim(edtSacadoNome.Text) = ''      then Erros.Add('- [Sacado] Nome');
    if Trim(edtSacadoCNPJ.Text) = ''      then Erros.Add('- [Sacado] CNPJ/CPF');
    if Trim(edtSacadoLogradouro.Text) = '' then Erros.Add('- [Sacado] Logradouro');
    if Trim(edtSacadoCidade.Text) = ''    then Erros.Add('- [Sacado] Cidade');
    if cmbSacadoUF.ItemIndex < 0          then Erros.Add('- [Sacado] UF');
    if Trim(edtSacadoCEP.Text) = ''       then Erros.Add('- [Sacado] CEP');

    if Erros.Count > 0 then
    begin
      Result := False;
      mmoStatus.Lines.Clear;
      mmoStatus.Lines.Add('=== CAMPOS OBRIGATORIOS NAO PREENCHIDOS ===');
      mmoStatus.Lines.AddStrings(Erros);
    end;
  finally
    Erros.Free;
  end;
end;

procedure TForm1.btnRegistrarClick(Sender: TObject);
var
  Titulo: TACBrTitulo;
  ValorDoc: Double;
  sValor: string;
  FS: TFormatSettings;
  sLogPath: string;
  sToken: string;
  sMsgRetorno: string;
begin
  if not ValidarCamposObrigatorios then
    Exit;

  FS := TFormatSettings.Create;
  FS.DecimalSeparator  := '.';
  FS.ThousandSeparator := ',';

  sValor := StringReplace(Trim(edtValor.Text), '.', '', [rfReplaceAll]);
  sValor := StringReplace(sValor, ',', '.', [rfReplaceAll]);
  if not TryStrToFloat(sValor, ValorDoc, FS) then
  begin
    ShowMessage('Valor do documento invalido. Use virgula como separador decimal (ex: 100,50).');
    Exit;
  end;

  ACBrBoleto1.ListadeBoletos.Clear;
  Titulo := TACBrTitulo.Create(ACBrBoleto1);
  try
    ACBrBoleto1.ACBrBoletoFC := ACBrBoletoFCFR1;
    ACBrBoleto1.ListadeBoletos.Add(Titulo);
    ACBrBoleto1.Banco.TipoCobranca := cobBancoDoBrasilAPI;
    ACBrBoleto1.Configuracoes.WebService.Operacao := tpInclui;

    // Cedente
    ACBrBoleto1.Cedente.Nome          := edtCedenteNome.Text;
    ACBrBoleto1.Cedente.CNPJCPF       := edtCedenteCNPJ.Text;
    ACBrBoleto1.Cedente.Agencia        := edtCedenteAgencia.Text;
    ACBrBoleto1.Cedente.AgenciaDigito  := edtCedenteAgenciaDigito.Text;
    ACBrBoleto1.Cedente.Conta          := edtCedenteConta.Text;
    ACBrBoleto1.Cedente.ContaDigito    := edtCedenteContaDigito.Text;
    ACBrBoleto1.Cedente.Convenio       := edtCedenteConvenio.Text;
    ACBrBoleto1.Cedente.Modalidade     := edtCedenteModalidade.Text;

    // Credenciais e ambiente
    ACBrBoleto1.Homologacao := chkHomologacao.Checked;
    if chkHomologacao.Checked then
      ACBrBoleto1.Configuracoes.WebService.Ambiente := tawsHomologacao
    else
      ACBrBoleto1.Configuracoes.WebService.Ambiente := tawsProducao;

    ACBrBoleto1.Cedente.CedenteWS.ClientID     := Trim(edtClientID.Text);
    ACBrBoleto1.Cedente.CedenteWS.ClientSecret := Trim(edtClientSecret.Text);
    ACBrBoleto1.Cedente.CedenteWS.KeyUser      := Trim(edtKeyUser.Text);
    ACBrBoleto1.Cedente.CedenteWS.IndicadorPix := chkIndicadorPix.Checked;
    ACBrBoleto1.Cedente.CedenteWS.Scope        := Trim(edtScope.Text);

    // Forca WinHttp antes de qualquer chamada para evitar fallback ao OpenSSL
    ACBrBoleto1.Configuracoes.WebService.SSLType    := LT_TLSv1_2;
    ACBrBoleto1.Configuracoes.WebService.SSLHttpLib := httpWinHttp;

    // Dados do titulo (boleto)
    Titulo.Vencimento      := dtpVencimento.Date;
    Titulo.DataDocumento   := dtpDataDocumento.Date;
    Titulo.NumeroDocumento := edtNumeroDoc.Text;
    Titulo.Carteira        := edtCarteira.Text;
    Titulo.EspecieMod      := edtEspecieMod.Text;
    Titulo.NossoNumero     := edtNossoNumero.Text;
    Titulo.ValorDocumento  := ValorDoc;
    Titulo.EspecieDoc      := cmbEspecieDoc.Text;
    if cmbAceite.ItemIndex = 0 then
      Titulo.Aceite := atSim
    else
      Titulo.Aceite := atNao;

    // Sacado
    Titulo.Sacado.NomeSacado  := edtSacadoNome.Text;
    Titulo.Sacado.CNPJCPF     := edtSacadoCNPJ.Text;
    Titulo.Sacado.Logradouro  := edtSacadoLogradouro.Text;
    Titulo.Sacado.Numero      := edtSacadoNumero.Text;
    Titulo.Sacado.Bairro      := edtSacadoBairro.Text;
    Titulo.Sacado.Cidade      := edtSacadoCidade.Text;
    Titulo.Sacado.UF          := cmbSacadoUF.Text;
    Titulo.Sacado.CEP         := edtSacadoCEP.Text;
    Titulo.Sacado.Complemento := edtSacadoComplemento.Text;

    // Log e PDF (usa Documents para evitar restricao de acesso)
    sLogPath := GetEnvironmentVariable('USERPROFILE') + '\Documents\Log_Boleto_BB.txt';
    if FileExists(sLogPath) then
      DeleteFile(sLogPath);
    ACBrBoleto1.Configuracoes.Arquivos.PathGravarRegistro := sLogPath;
    ACBrBoleto1.Configuracoes.Arquivos.LogNivel := logParanoico;

    ACBrBoletoFCFR1.FastReportFile := ExtractFilePath(ParamStr(0)) + 'BoletoFR.fr3';
    ACBrBoletoFCFR1.NomeArquivo   := GetEnvironmentVariable('USERPROFILE') + '\Documents\BoletoFast.pdf';
    ACBrBoletoFCFR1.Filtro        := fiPDF;
    ACBrBoletoFCFR1.MostrarSetup  := False;
    ACBrBoletoFCFR1.LayOut        := lPadraoPIX;
    ACBrBoletoFCFR1.DirLogo       := 'C:\Users\Deivisson Matos\Documents\Acbr\Fontes\ACBrBoleto\Logos\Colorido\bmp';

    mmoStatus.Lines.Clear;
    mmoStatus.Lines.Add('Registrando boleto na API do Banco do Brasil...');

    // Obtem o token OAuth via TNetHTTPClient (evita bug do ACBr com Synapse/OpenSSL)
    if not ObterTokenOAuth(
        Trim(edtClientID.Text),
        Trim(edtClientSecret.Text),
        Trim(edtScope.Text),
        chkHomologacao.Checked,
        sToken) then
    begin
      mmoStatus.Lines.Add('Falha ao obter token OAuth. Verifique as credenciais e o scope.');
      ExibirLogNoMemo(sLogPath);
      Exit;
    end;
    mmoStatus.Lines.Add('Token: ' + Copy(sToken, 1, 20) + '...');

    // Injeta o token no ACBr via evento OnAntesAutenticar
    FTokenOAuth := sToken;
    FTokenValidade := Now + 1/144; // token valido por 10 minutos
    ACBrBoleto1.OnAntesAutenticar := OnAntesAutenticarBoleto;

    // Envia o boleto diretamente via WinHttp COM (Synapse e hardcoded no ACBr e tem problemas com TLS)
    try
      if EnviarBoletoDireto(sToken, Trim(edtKeyUser.Text), chkHomologacao.Checked, sMsgRetorno) then
      begin
        mmoStatus.Lines.Add('Boleto registrado com sucesso!');

        // Popula o titulo com dados retornados pelo BB para gerar o PDF corretamente
        try
          var JSONRet := TJSONObject.ParseJSONValue(sMsgRetorno) as TJSONObject;
          if Assigned(JSONRet) then
          try
            var Tit := ACBrBoleto1.ListadeBoletos[0];
            // Atualiza NossoNumero com o numero completo retornado pelo banco
            var sNosso := JSONRet.GetValue<string>('numero', '');
            if sNosso <> '' then Tit.NossoNumero := sNosso;
            // QRCode PIX - campos disponiveis em TACBrTitulo.QrCode
            var JSONQr := JSONRet.GetValue<TJSONObject>('qrCode');
            if Assigned(JSONQr) then
            begin
              Tit.QrCode.EMV  := JSONQr.GetValue<string>('emv', '');
              Tit.QrCode.URL  := JSONQr.GetValue<string>('url', '');
            end;
          finally
            JSONRet.Free;
          end;
        except
          // ignora erro ao popular dados do retorno
        end;

        try
          ACBrBoleto1.GerarPDF;
          var sPDFPath := GetEnvironmentVariable('USERPROFILE') + '\Documents\BoletoFast.pdf';
          mmoStatus.Lines.Add('PDF gerado em: ' + sPDFPath);
          ShellExecute(0, 'open', PChar(sPDFPath), nil, nil, SW_SHOWNORMAL);
          ShowMessage('Boleto cadastrado e PDF gerado com sucesso!');
        except
          on E: Exception do
          begin
            mmoStatus.Lines.Add('(PDF nao gerado: ' + E.Message + ')');
            ShowMessage('Boleto cadastrado com sucesso!' + #13#10 +
              'Mas o PDF falhou: ' + E.Message + #13#10 + #13#10 + sMsgRetorno);
          end;
        end;
      end
      else
      begin
        mmoStatus.Lines.Add('Erro ao registrar boleto. Veja a resposta acima.');
        ShowMessage('Erro ao registrar boleto:' + #13#10 + sMsgRetorno);
      end;
    except
      on E: Exception do
      begin
        mmoStatus.Lines.Add('EXCECAO CAPTURADA: ' + E.ClassName + ': ' + E.Message);
        ExibirLogNoMemo(sLogPath);
        ShowMessage('Excecao ao registrar boleto:' + #13#10 + E.ClassName + ': ' + E.Message);
      end;
    end;
  finally
    // Titulo e gerenciado pela ListadeBoletos apos Add()
  end;
end;

procedure TForm1.btnLimparClick(Sender: TObject);
begin
  edtSacadoNome.Clear;
  edtSacadoCNPJ.Clear;
  edtSacadoLogradouro.Clear;
  edtSacadoNumero.Clear;
  edtSacadoBairro.Clear;
  edtSacadoCidade.Clear;
  edtSacadoComplemento.Clear;
  edtSacadoEmail.Clear;
  cmbSacadoUF.ItemIndex := -1;
  edtSacadoCEP.Clear;
  edtNumeroDoc.Clear;
  edtNossoNumero.Clear;
  edtValor.Clear;
  dtpVencimento.Date    := Date + 10;
  dtpDataDocumento.Date := Date;
  mmoStatus.Lines.Clear;
end;

end.
