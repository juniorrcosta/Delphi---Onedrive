unit uDropbox;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  Vcl.StdCtrls,
  Vcl.OleCtrls,
  SHDocVw,
  ActiveX,
  Data.DBXJSON,
  math;

const
  //OAUTH
  AppKey = 'rreu7e3usf8wi52';
  AppSecret = '3zfqh3769bwu2sv';
  URL_AUTH_CODE = 'https://www.dropbox.com/oauth2/authorize?response_type=code&client_id=';

  //API
  URL_OAUTH2_TOKEN = 'https://api.dropbox.com/oauth2/token';
  URL_LIST_FOLDER = 'https://api.dropboxapi.com/2/files/list_folder';
  URL_FILE_UPLOAD = 'https://content.dropboxapi.com/2/files/upload';
  URL_FILE_SESSION_START = 'https://content.dropboxapi.com/2/files/upload_session/start';
  URL_FILE_SESSION_APPEND = 'https://content.dropboxapi.com/2/files/upload_session/append_v2';
  URL_FILE_SESSION_FINISH = 'https://content.dropboxapi.com/2/files/upload_session/finish';
  URL_GET_CURRENT_ACCOUNT = 'https://api.dropboxapi.com/2/users/get_current_account';
  URL_FILE_DOWNLOAD = 'https://content.dropboxapi.com/2/files/download';

type
  TOnLogAdd = procedure(s: string) of object;

  TOnGetAccountInfo = procedure(s: string) of object;

  TOnUploadStart = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadProgress = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadEnd = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadError = procedure(FFilePath: string; FMaxFileSize: integer; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FSectionDateTIme: TDateTime) of object;

  TDropboxOP = (TOpNone = 0, TOpDownload = 1, TOpUpload = 2);

  TDropBox = class
  private
    FAcessToken: string;
    FAcessCode: string;
    FWebBrowser: TWebBrowser;
    FormGetToken: TForm;
    FDefaultFolder: string;
    FLog: TStringList;
    FOnLogAdd: TOnLogAdd;
    FMemoLog: TMemo;
    FUploadSessionID: string;
    FDisplayName: string;
    FEmail: string;
    FFamiliarName: string;
    FFolderHasMore: Boolean;
    FAccountID: string;
    FSurname: string;
    FLocale: string;
    FGivenName: string;
    FFullFileName: string;
    FQtdParts: integer;
    FQtdSent: integer;
    FDataSent: integer;
    FMaxFileSize: integer;
    FSectionDateTime: TDateTime;
    FLastUploadDateTime: TDateTime;
    FOnUploadProgress: TOnUploadProgress;
    FOnUploadError: TOnUploadError;
    FOnUploadStart: TOnUploadStart;
    FOnUploadEnd: TOnUploadEnd;
    FOnGetAccountInfo: TOnGetAccountInfo;
    FCountry: string;
    FProgress: Integer;
    FBytesToTransfer: Int64;
    FOnChange: TNotifyEvent;
    IOHndl: TIdSSLIOHandlerSocketOpenSSL;
    FTransferedBytes: Int64;
    FFullFileSize: Int64;
    FTipo: TDropboxOP;
    FstartWriteTime: Cardinal;
    FelapsedSeconds: Dword;
    FspeedBytesPerSeconds: Int64;
    FelapsedMilliSeconds: Dword;
    FTotalBytesSent: int64;
    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure SetProgress(const Value: Integer);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetAcessToken(const Value: string);
    procedure SetAcessCode(const Value: string);
    function GetWebBrowserHTML(const WebBrowser: TWebBrowser): string;
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure GetWebBrowserToken;
    procedure FormWbClose(Sender: TObject; var Action: TCloseAction);
    procedure SetDefaultFolder(const Value: string);
    procedure SetLog(const Value: TStringList);
    procedure SetOnLogAdd(const Value: TOnLogAdd);
    procedure ChangeLog(Sender: TObject);
    procedure SetMemoLog(const Value: TMemo);
    procedure SetUploadSessionID(const Value: string);
    procedure SetAccountID(const Value: string);
    procedure SetDisplayName(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetFamiliarName(const Value: string);
    procedure SetGivenName(const Value: string);
    procedure SetFolderHasMore(const Value: Boolean);
    procedure SetLocale(const Value: string);
    procedure SetSurname(const Value: string);
    function GetException(e: EIdHTTPProtocolException): string;
    procedure VerificaAcessCode;
    procedure VerificaAcessToken;
    procedure SetMaxFileSize(const Value: integer);
    procedure SetOnUploadError(const Value: TOnUploadError);
    procedure SetOnUploadProgress(const Value: TOnUploadProgress);
    procedure SetOnUploadEnd(const Value: TOnUploadEnd);
    procedure SetOnUploadStart(const Value: TOnUploadStart);
    procedure SetOnGetAccountInfo(const Value: TOnGetAccountInfo);
    procedure SetCountry(const Value: string);
    procedure SetQtdSent(const Value: integer);
    procedure SetQtdParts(const Value: integer);
    procedure SetTransferedBytes(const Value: Int64);
    procedure SetFullFileSize(const Value: Int64);
    procedure SetTipo(const Value: TDropboxOP);
    procedure SetstartWriteTime(const Value: Cardinal);
    procedure displayWriteSpeed(byteWritten: Int64);
    procedure SetelapsedMilliSeconds(const Value: Dword);
    procedure SetelapsedSeconds(const Value: Dword);
    procedure SetspeedBytesPerSeconds(const Value: Int64);
    procedure SetTotalBytesSent(const Value: int64);
  public
    constructor Create;
    destructor destroy;
    //Account Functions
    procedure GetAcessCode;
    procedure GetAcessToken;
    function GetAccountInfo: TJsonObject;
    //Folder Functions
    function GetFolders: TJSONObject;
    function GetFoldersAsString: string;
    function GetFoldersAsList(OrdenarPorNome: boolean = false): TStringList;
    function GetFilesAsList(OrdenarPorNome: boolean = false): TStringList;
    //Upload Functions
    procedure Upload(sFile: string);
    procedure UploadSessionStart;
    procedure UploadSessionAppend;
    procedure UploadSessionFinish;
    //Download Functions
    procedure Download(sFilePath, sDestination: string);
  published
    property AcessToken: string read FAcessToken write SetAcessToken;
    property AcessCode: string read FAcessCode write SetAcessCode;
    property DefaultFolder: string read FDefaultFolder write SetDefaultFolder;
    property Log: TStringList read FLog write SetLog;
    property OnLogAdd: TOnLogAdd read FOnLogAdd write SetOnLogAdd;
    property OnGetAccountInfo: TOnGetAccountInfo read FOnGetAccountInfo write SetOnGetAccountInfo;
    property MemoLog: TMemo read FMemoLog write SetMemoLog;
    property UploadSessionID: string read FUploadSessionID write SetUploadSessionID;
    property AccountID: string read FAccountID write SetAccountID;
    property Email: string read FEmail write SetEmail;
    property Locale: string read FLocale write SetLocale;
    property Country: string read FCountry write SetCountry;
    property DisplayName: string read FDisplayName write SetDisplayName;
    property FamiliarName: string read FFamiliarName write SetFamiliarName;
    property GivenName: string read FGivenName write SetGivenName;
    property Surname: string read FSurname write SetSurname;
    property FolderHasMore: Boolean read FFolderHasMore write SetFolderHasMore;
    property MaxFileSize: integer read FMaxFileSize write SetMaxFileSize;
    property OnUploadProgress: TOnUploadProgress read FOnUploadProgress write SetOnUploadProgress;
    property OnUploadError: TOnUploadError read FOnUploadError write SetOnUploadError;
    property OnUploadStart: TOnUploadStart read FOnUploadStart write SetOnUploadStart;
    property OnUploadEnd: TOnUploadEnd read FOnUploadEnd write SetOnUploadEnd;
    property Progress: Integer read FProgress write SetProgress;
    property BytesToTransfer: Int64 read FBytesToTransfer;
    property TransferedBytes: Int64 read FTransferedBytes write SetTransferedBytes;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property QtdSent: integer read FQtdSent write SetQtdSent;
    property QtdParts: integer read FQtdParts write SetQtdParts;
    property FullFileSize: Int64 read FFullFileSize write SetFullFileSize;
    property Tipo: TDropboxOP read FTipo write SetTipo;
    property startWriteTime: Cardinal read FstartWriteTime write SetstartWriteTime;
    property elapsedMilliSeconds: Dword read FelapsedMilliSeconds write SetelapsedMilliSeconds;
    property elapsedSeconds: Dword read FelapsedSeconds write SetelapsedSeconds;
    property speedBytesPerSeconds: Int64 read FspeedBytesPerSeconds write SetspeedBytesPerSeconds;
    Property TotalBytesSent: int64 read FTotalBytesSent write SetTotalBytesSent default 0;
  end;

implementation

{ TDropBox }

function TDropBox.GetWebBrowserHTML(const WebBrowser: TWebBrowser): string;
var
  LStream: TStringStream;
  Stream: IStream;
  LPersistStreamInit: IPersistStreamInit;
begin
  if not Assigned(WebBrowser.Document) then
    exit;
  LStream := TStringStream.Create('');
  try
    LPersistStreamInit := WebBrowser.Document as IPersistStreamInit;
    Stream := TStreamAdapter.Create(LStream, soReference);
    LPersistStreamInit.Save(Stream, true);
    result := LStream.DataString;
  finally
    LStream.Free();
  end;
end;

procedure TDropbox.GetWebBrowserToken;
var
  HTMLCODE: string;
  Token: string;
begin

  HTMLCODE := (GetWebBrowserHTML(FWebBrowser));

  FAcessCode := '';
  if pos('data-token=', HTMLCODE) <> 0 then
  begin
    Token := HTMLCODE;
    Token := Copy(Token, Pos('data-token=', Token) + 12, length(Token));
    Token := Copy(Token, 0, Pos('">', Token) - 1);
    FAcessCode := Token;
  end;

  if FAcessCode <> '' then
    FormGetToken.Close
  else
  begin

  end;

end;

procedure TDropBox.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  if URL = 'https://www.dropbox.com/1/oauth2/authorize_submit' then
  begin
    GetWebBrowserToken;
  end;
end;

procedure TDropBox.ChangeLog(Sender: TObject);
begin
  if Assigned(OnLogAdd) then
  begin
    FOnLogAdd('[' + inttostr(TStringList(Sender).Count) + ']' + TStringList(Sender)[Pred(TStringList(Sender).Count)]);
  end;

  if Assigned(FMemoLog) then
  begin
    FMemoLog.Lines.Add('[' + inttostr(TStringList(Sender).Count) + ']' + TStringList(Sender)[Pred(TStringList(Sender).Count)]);
    FMemoLog.Lines.Add('');
  end;
end;

constructor TDropBox.Create;
begin
  FDefaultFolder := '/';
  FLog := TStringList.Create;
  FLog.OnChange := ChangeLog;
  FMaxFileSize := 10 * (1024 * 1024); // 10MB
  FQtdSent := 0;
  Tipo := TOpNone;
end;

destructor TDropBox.destroy;
begin
  FLog.Free;
end;

procedure TDropBox.Download(sFilePath, sDestination: string);
var
  IdHTTP: TIdHTTP;
  Source: TMemoryStream;
  Res: string;
  jsonObj: TJSONObject;
  jv: TJSONValue;
  Buffer: PChar;
  BytesToRead: integer;
begin
  VerificaAcessToken;
  Tipo := TOpDownload;
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.OnWork := HTTPWork;
  IdHTTP.OnWorkBegin := HTTPWorkBegin;
  IdHTTP.OnWorkEnd := HTTPWorkEnd;
  FTotalBytesSent := 0;

  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] := '{"path": "' + sFilePath + '"}';

    Source := TMemoryStream.Create;
    Source.Position := 0;
    FDataSent := 0;
    FQtdParts := 1;
    FQtdSent := 0;

    try

      IdHTTP.get(URL_FILE_DOWNLOAD, Source);

      Source.Position := 0;
      Source.SaveToFile('c:' + sFilePath);

    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));

      end;
    end;

  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

procedure TDropBox.FormWbClose(Sender: TObject; var Action: TCloseAction);
begin
  GetWebBrowserToken;
end;

function TDropBox.GetAccountInfo: TJsonObject;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  jsonObj, jSubObj: TJSONObject;
  ja: TJSONArray;
  jv: TJSONValue;
begin

  VerificaAcessToken;

  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    //IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('');
    try
      Res := IdHTTP.Post(URL_GET_CURRENT_ACCOUNT, Source);
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
      Result := jsonObj;

      if Res <> '' then
      begin
        FAccountID := jsonObj.Get('account_id').JsonValue.Value;
        jSubObj := jsonObj.Get('name').JsonValue as TJSONObject;

        FGivenName := TJSONObject(jsonObj.Get('name').JsonValue).Get(0).JsonValue.value;
        FSurname := TJSONObject(jsonObj.Get('name').JsonValue).Get(1).JsonValue.value;
        FFamiliarName := TJSONObject(jsonObj.Get('name').JsonValue).Get(2).JsonValue.value;
        FDisplayName := TJSONObject(jsonObj.Get('name').JsonValue).Get(3).JsonValue.value;

        FEmail := jsonObj.Get('email').JsonValue.Value;
        FCountry := jsonObj.Get('country').JsonValue.Value;
        FLocale := jsonObj.Get('locale').JsonValue.Value;
      end;

      if Assigned(FOnGetAccountInfo) then
        FOnGetAccountInfo(Res);

    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;
  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

procedure TDropBox.GetAcessCode;
begin
  FormGetToken := TForm.Create(nil);
  FormGetToken.Width := 500;
  FormGetToken.Height := 700;
  FormGetToken.Position := poMainFormCenter;
  FWebBrowser := TWebBrowser.Create(FormGetToken);
  TWinControl(FWebBrowser).Parent := FormGetToken;
  FWebBrowser.Align := alClient;
  FWebBrowser.Navigate(URL_AUTH_CODE + AppKey);
  FWebBrowser.OnDocumentComplete := WebBrowser1DocumentComplete;
  FormGetToken.OnClose := FormWbClose;
  FormGetToken.ShowModal;
end;

procedure TDropBox.GetAcessToken;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  parameters: TStringList;
  jsonObj, jSubObj: TJSONObject;
  jv: TJSONValue;
begin

  VerificaAcessCode;

  if AcessCode <> '' then
  begin
    parameters := TStringList.Create;
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.HandleRedirects := True;
      IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';

      parameters.Add('code=' + FAcessCode);
      parameters.Add('grant_type=authorization_code');
      parameters.Add('client_id=' + AppKey);
      parameters.Add('client_secret=' + AppSecret);

      try
        Res := IdHTTP.Post(URL_OAUTH2_TOKEN, parameters);
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;

        jv := jsonObj.Get('access_token').JsonValue;
        FAcessToken := jv.Value;
      except
        on E: EIdHTTPProtocolException do
        begin
          FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
          raise Exception.Create(GetException(e));
        end;
      end;
    finally
      IdHTTP.Free;
      parameters.free;
    end;
  end
  else
    AcessToken := '';
end;

function TDropBox.GetFoldersAsString: string;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('{"path": "", "recursive": true}');
    try
      Res := IdHTTP.Post(URL_LIST_FOLDER, Source);
      Result := Res;
    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));

      end;
    end;
  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

function TDropBox.GetFolders: TJSONObject;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  jsonObj: TJSONObject;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('{"path": "", "recursive": true}');
    try
      Res := IdHTTP.Post(URL_LIST_FOLDER, Source);
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
      Result := jsonObj;
    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;
  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

function TDropBox.GetFoldersAsList(OrdenarPorNome: boolean = false): TStringList;

  function Compare(List: TStringList; Index1, Index2: Integer): Integer;
  begin
    Result := CompareStr(List[Index1], List[Index2]);
  end;

var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  jsonObj: TJSONObject;
  jSubObj: TJSONObject;
  FolderList: TStringList;
  ja: TJSONArray;
  jv: TJSONValue;
  i: Integer;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  FolderList := TStringList.Create;
  Res := '';
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('{"path": "", "recursive": true}');
    try
      Res := IdHTTP.Post(URL_LIST_FOLDER, Source);
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;
    if Res <> '' then
    begin

      jv := jsonObj.Get('entries').JsonValue;
      ja := jv as TJSONArray;

      FolderList.Clear;

      for i := 0 to ja.Size - 1 do
      begin
        jSubObj := (ja.Get(i) as TJSONObject);
        jv := jSubObj.Get(0).JsonValue;
        if jv.Value = 'folder' then
        begin
          jv := jSubObj.Get(2).JsonValue;
          FolderList.Add(Copy(jv.Value, 2, length(jv.Value)).Replace('/', '\'));
        end;
      end;
      if OrdenarPorNome then
        FolderList.CustomSort(@compare);

      jv := jsonObj.Get('has_more').JsonValue;

      FFolderHasMore := (jv.Value = 'true');

    end;
    result := FolderList;
  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

function TDropBox.GetFilesAsList(OrdenarPorNome: boolean = false): TStringList;

  function Compare(List: TStringList; Index1, Index2: Integer): Integer;
  begin
    Result := CompareStr(List[Index1], List[Index2]);
  end;

var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  jsonObj: TJSONObject;
  jSubObj: TJSONObject;
  FolderList: TStringList;
  ja: TJSONArray;
  jv: TJSONValue;
  i: Integer;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  FolderList := TStringList.Create;
  Res := '';
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('{"path": "", "recursive": true}');
    try
      Res := IdHTTP.Post(URL_LIST_FOLDER, Source);
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;
    if Res <> '' then
    begin

      jv := jsonObj.Get('entries').JsonValue;
      ja := jv as TJSONArray;

      FolderList.Clear;

      for i := 0 to ja.Size - 1 do
      begin
        jSubObj := (ja.Get(i) as TJSONObject);
        jv := jSubObj.Get(0).JsonValue;
        begin
          jv := jSubObj.Get(2).JsonValue;
          FolderList.Add({'Dropbox'+}Copy(jv.Value, 1, length(jv.Value)).Replace('/', '\'));
        end;
      end;
      if OrdenarPorNome then
        FolderList.CustomSort(@compare);

    end;
    result := FolderList;
  finally
    IdHTTP.Free;
    Source.Free;
  end;

end;

procedure TDropBox.SetAccountID(const Value: string);
begin
  FAccountID := Value;
end;

procedure TDropBox.SetAcessCode(const Value: string);
begin
  FAcessCode := Value;
end;

procedure TDropBox.SetAcessToken(const Value: string);
begin
  FAcessToken := Value;
end;

procedure TDropBox.SetCountry(const Value: string);
begin
  FCountry := Value;
end;

procedure TDropBox.SetDefaultFolder(const Value: string);
begin
  if length(Value) > 1 then
    FDefaultFolder := Value + '/'
  else
    FDefaultFolder := Value;
end;

procedure TDropBox.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

procedure TDropBox.SetelapsedMilliSeconds(const Value: Dword);
begin
  FelapsedMilliSeconds := Value;
end;

procedure TDropBox.SetelapsedSeconds(const Value: Dword);
begin
  FelapsedSeconds := Value;
end;

procedure TDropBox.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TDropBox.SetFamiliarName(const Value: string);
begin
  FFamiliarName := Value;
end;

procedure TDropBox.SetGivenName(const Value: string);
begin
  FGivenName := Value;
end;

procedure TDropBox.SetFolderHasMore(const Value: Boolean);
begin
  FFolderHasMore := Value;
end;

procedure TDropBox.SetFullFileSize(const Value: Int64);
begin
  FFullFileSize := Value;
end;

procedure TDropBox.SetLocale(const Value: string);
begin
  FLocale := Value;
end;

procedure TDropBox.SetLog(const Value: TStringList);
begin
  FLog := Value;
end;

procedure TDropBox.SetMaxFileSize(const Value: integer);
begin
  FMaxFileSize := Value * (1024 * 1024);
end;

procedure TDropBox.SetMemoLog(const Value: TMemo);
begin
  FMemoLog := Value;
end;

procedure TDropBox.SetOnGetAccountInfo(const Value: TOnGetAccountInfo);
begin
  FOnGetAccountInfo := Value;
end;

procedure TDropBox.SetOnLogAdd(const Value: TOnLogAdd);
begin
  FOnLogAdd := Value;
end;

procedure TDropBox.SetOnUploadEnd(const Value: TOnUploadEnd);
begin
  FOnUploadEnd := Value;
end;

procedure TDropBox.SetOnUploadError(const Value: TOnUploadError);
begin
  FOnUploadError := Value;
end;

procedure TDropBox.SetOnUploadProgress(const Value: TOnUploadProgress);
begin
  FOnUploadProgress := Value;
end;

procedure TDropBox.SetOnUploadStart(const Value: TOnUploadStart);
begin
  FOnUploadStart := Value;
end;

procedure TDropBox.SetSurname(const Value: string);
begin
  FSurname := Value;
end;

procedure TDropBox.SetTipo(const Value: TDropboxOP);
begin
  FTipo := Value;
end;

procedure TDropBox.SetTotalBytesSent(const Value: int64);
begin
  FTotalBytesSent := Value;
end;

procedure TDropBox.SetTransferedBytes(const Value: Int64);
begin
  FTransferedBytes := Value;
end;

procedure TDropBox.SetUploadSessionID(const Value: string);
begin
  FUploadSessionID := Value;
end;

function splitFile(FileName: string): TMemoryStream;
var
  fs: TFileStream;
  ms: TMemoryStream;
  i, BytesToRead: integer;
begin

  fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  ms := TMemoryStream.Create;
  fs.Position := 0;
  BytesToRead := Min(fs.Size - fs.Position, 1024 * 1024);
  ms.CopyFrom(fs, BytesToRead);
  result := ms;
    // fs.Free;
    // ms.Free;
end;

procedure TDropBox.UploadSessionStart;
var
  IdHTTP: TIdHTTP;
  Source: TFileStream;
  Res: string;
  jsonObj: TJSONObject;
  jv: TJSONValue;
  Buffer: PChar;
  BytesToRead: integer;
  ms: TMemoryStream;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.OnWork := HTTPWork;
  IdHTTP.OnWorkBegin := HTTPWorkBegin;
  IdHTTP.OnWorkEnd := HTTPWorkEnd;
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/octet-stream';
    IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] := '{"close": false}';

    Source := TFileStream.Create(FFullFileName, fmOpenRead);
    FFullFileSize := Source.Size;

    ms := TMemoryStream.Create;
    FDataSent := 0;

    try
      //ENVIA APENAS PARTE DO ARQUIVO
      Source.Position := 0;

      ms.CopyFrom(Source, MaxFileSize);
      Res := IdHTTP.Post(URL_FILE_SESSION_START, ms);

      if Assigned(FOnUploadStart) then
        FOnUploadStart(FFullFileName, Source.Size, FDataSent, FUploadSessionID, FQtdParts, FQtdSent);

      FDataSent := ms.Size;

      if Assigned(FOnUploadProgress) then
        FOnUploadProgress(FFullFileName, Source.Size, FDataSent, FUploadSessionID, FQtdParts, FQtdSent);

      FQtdSent := 1;

      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
    except
      on E: EIdHTTPProtocolException do
      begin
        if Assigned(FOnUploadError) then
          FOnUploadError(FFullFileName, FMaxFileSize, Source.Size, FDataSent, FUploadSessionID, FSectionDateTime);

        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;

    if Res <> '' then
    begin

      jv := jsonObj.Get('session_id').JsonValue;
      FUploadSessionID := jv.Value;
      FSectionDateTime := now();
      FLog.Add('Upload Session Start ID: ' + FUploadSessionID);
      FLog.Add('Enviado: ' + inttostr(FDataSent) + ' de ' + inttostr(Source.Size));

    end;

  finally
    IdHTTP.Free;
    Source.Free;
    ms.Free;
  end;

end;

procedure TDropBox.UploadSessionAppend;
var
  IdHTTP: TIdHTTP;
  Source: TFileStream;
  Res: string;
  jsonObj: TJSONObject;
  jv: TJSONValue;
  Buffer: PChar;
  ms: TMemoryStream;
begin
  VerificaAcessToken;
  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.OnWork := HTTPWork;
  IdHTTP.OnWorkBegin := HTTPWorkBegin;
  IdHTTP.OnWorkEnd := HTTPWorkEnd;
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/octet-stream';

    ms := TMemoryStream.Create;
    Source := TFileStream.Create(FFullFileName, fmOpenRead);

    if FDataSent = Source.Size then
      Exit;

    Source.Position := FDataSent;

    if (FDataSent + MaxFileSize) > Source.Size then
    begin
      ms.CopyFrom(Source, Source.Size - FDataSent);
    end
    else
      ms.CopyFrom(Source, MaxFileSize);

    IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] := '{"cursor": {"session_id": "' + FUploadSessionID + '","offset": ' + inttostr(FDataSent) + '},"close": false}';
    FDataSent := FDataSent + ms.Size;

    try

      Res := IdHTTP.Post(URL_FILE_SESSION_APPEND, ms);

      FLog.Add('Enviado: ' + inttostr(FDataSent) + ' de ' + inttostr(Source.Size));

      if Assigned(FOnUploadProgress) then
        FOnUploadProgress(FFullFileName, Source.Size, FDataSent, FUploadSessionID, FQtdParts, FQtdSent);

    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);

        if Assigned(FOnUploadError) then
          FOnUploadError(FFullFileName, FMaxFileSize, Source.Size, FDataSent, FUploadSessionID, FSectionDateTime);

        raise Exception.Create(GetException(e));

      end;
    end;

  finally
    IdHTTP.Free;
    Source.Free;
    ms.Free;
  end;

end;

procedure TDropBox.UploadSessionFinish;
var
  IdHTTP: TIdHTTP;
  Source: TFileStream;
  Res: string;
  jsonObj: TJSONObject;
  jv: TJSONValue;
  LStream: TStringStream;
begin
  VerificaAcessToken;

  if FUploadSessionID <> '' then
  begin

    IdHTTP := TIdHTTP.Create(nil);
    IdHTTP.OnWork := HTTPWork;
    IdHTTP.OnWorkBegin := HTTPWorkBegin;
    IdHTTP.OnWorkEnd := HTTPWorkEnd;
    try
      IdHTTP.HandleRedirects := True;
      IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.Request.CustomHeaders.FoldLines := False;
      IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
      IdHTTP.Request.ContentType := 'application/octet-stream';

      Source := TFileStream.Create(FFullFileName, fmOpenRead);
      LStream := TStringStream.Create('teste');

      IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] := '{"cursor": {"session_id": "' + FUploadSessionID + '","offset": ' + inttostr(Source.Size) + '},"commit": {"path": "' + FDefaultFolder + ExtractFileName(FFullFileName) + '","mode": "add","autorename": true,"mute": false,"strict_conflict": false}}';

      try
        Res := IdHTTP.Post(URL_FILE_SESSION_FINISH, LStream);
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;

        if Assigned(FOnUploadEnd) then
          FOnUploadEnd(FFullFileName, Source.Size, FDataSent, FUploadSessionID, FQtdParts, FQtdSent);

      except
        on E: EIdHTTPProtocolException do
        begin
          FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);

          if Assigned(FOnUploadError) then
            FOnUploadError(FFullFileName, FMaxFileSize, Source.Size, FDataSent, FUploadSessionID, FSectionDateTime);

          raise Exception.Create(GetException(e));

        end;
      end;

      if Res <> '' then
      begin

      end;

    finally
      IdHTTP.Free;
      Source.Free;
      LStream.Free;
    end;

  end;

  FUploadSessionID := '';

end;

procedure TDropBox.Upload(sFile: string);
var
  IdHTTP: TIdHTTP;
  Source: TFileStream;
  Res, sFileDirName: string;
  vMB: Double;
  FileSize: integer;
  i: Integer;
begin
  Tipo := TOpUpload;
  VerificaAcessToken;

  IdHTTP := TIdHTTP.Create(nil);
  IdHTTP.OnWork := HTTPWork;
  IdHTTP.OnWorkBegin := HTTPWorkBegin;
  IdHTTP.OnWorkEnd := HTTPWorkEnd;
  FQtdSent := 0;

  FTotalBytesSent := 0;
  try
    FFullFileName := sFile;
    sFileDirName := FDefaultFolder + ExtractFileName(FFullFileName);
    Source := TFileStream.Create(sFile, fmOpenRead);
    FileSize := Source.Size;
    vMB := (FileSize / (1024 * 1024));

    FLog.Add('Arquivo: ' + sFile + ' Tamanho: ' + FormatFloat('###0.###', (vMB)) + 'MB ');

    if FileSize < MaxFileSize then
    begin
      FQtdParts := 1;
      IdHTTP.HandleRedirects := True;
      IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.Request.CustomHeaders.FoldLines := False;
      IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAcessToken);
      IdHTTP.Request.ContentType := 'application/octet-stream';

      IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] := Format('{ "path": "%s", "mode": "overwrite"}', [sFileDirName.Replace('\', '/')]);

      try
        Res := IdHTTP.Post(URL_FILE_UPLOAD, Source);
      except
        on E: EIdHTTPProtocolException do
        begin
          FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
          raise Exception.Create(GetException(e));
        end;
      end;

      Source.Free;

    end
    else
    begin
      Source.Free;
      FQtdParts := System.Math.Ceil(FileSize / MaxFileSize);

      if FQtdSent = 0 then
        UploadSessionStart;


      while FQtdSent < FQtdParts do
      begin
        UploadSessionAppend;
        FQtdSent := FQtdSent + 1;
      end;
      //end;

      UploadSessionFinish;

    end;
  finally
    IdHTTP.Free;
  end;
end;

procedure TDropBox.VerificaAcessCode;
begin
  if FAcessCode = '' then
  begin
    raise Exception.Create('AcessCode não foi informado.');
  end;
end;

procedure TDropBox.VerificaAcessToken;
begin
  if FAcessToken = '' then
  begin
    raise Exception.Create('AcessToken não foi informado.');
  end;
end;

function TDropBox.GetException(e: EIdHTTPProtocolException): string;
begin
  if e.ErrorCode = 401 then
  begin
    result := ('Token expirado ou inválido!');
  end;

  if e.ErrorCode = 409 then
  begin
    result := ('Erro no jSon: (' + IntToStr(e.ErrorCode) + ') ' + e.Message);
  end;

  if e.ErrorCode = 429 then
  begin
    result := ('A aplicação está fazendo requisições demais e atingiu o limite de conexões; Aguarde 10 segundos e tente novamente.: ' + e.Message);
  end;
end;

procedure TDropBox.HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if BytesToTransfer = 0 then
    Exit;

  Progress := Round((AWorkCount / BytesToTransfer) * 100);
  FTransferedBytes := AWorkCount;

  displayWriteSpeed(AWorkCount);
end;

procedure TDropBox.HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if tipo = TOpDownload then
    FFullFileSize := AWorkCountMax;

  FTransferedBytes := 0;
  FBytesToTransfer := AWorkCountMax;
  startWriteTime := GetTickCount;
  displayWriteSpeed(-1);
end;

procedure TDropBox.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  Progress := 100;
  displayWriteSpeed(FBytesToTransfer);
  FTotalBytesSent := FTotalBytesSent + FBytesToTransfer;
end;

procedure TDropBox.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TDropBox.displayWriteSpeed(byteWritten: Int64);
begin
  if byteWritten < 0 then
  //b/egin
  //  {writeSpeedLabel.}Caption := 'upload speed: ?';
    Exit;
  //end;
  try
    elapsedMilliSeconds := GetTickCount - startWriteTime;
    elapsedSeconds := elapsedMilliSeconds div 1000;
    if elapsedSeconds <> 0 then
    
    speedBytesPerSeconds := byteWritten div elapsedSeconds;
  except

  end;
  //{writeSpeedLabel.}Caption := SysUtils.Format('upload speed: %d b/s', [speedBytesPerSeconds ] );
end;

procedure TDropBox.SetProgress(const Value: Integer);
begin
  FProgress := Value;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDropBox.SetQtdSent(const Value: integer);
begin
  FQtdSent := Value;
end;

procedure TDropBox.SetspeedBytesPerSeconds(const Value: Int64);
begin
  FspeedBytesPerSeconds := Value;
end;

procedure TDropBox.SetstartWriteTime(const Value: Cardinal);
begin
  FstartWriteTime := Value;
end;

procedure TDropBox.SetQtdParts(const Value: integer);
begin
  FQtdParts := Value;
end;

end.

