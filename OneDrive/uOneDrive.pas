unit uOneDrive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls, Vcl.OleCtrls,
  SHDocVw, ActiveX, Data.DBXJSON, math, vcl.ExtCtrls, Vcl.Imaging.jpeg;

const
  //OAUTH
  AppKey = 'c0429cee-b3a8-4875-850c-ceb0fa6efd49';
  AppSecret = 'podnUS249~#iunTEAQN81|-';
  redirect_uri = 'https://login.live.com/oauth20_desktop.srf';
  scope = 'files.readwrite.all, wl.offline_access, wl.basic, wl.offline_access, wl.signin, openid, profile, offline_access, user.readwrite, mail.readwrite, mail.send';
  URL_ACESS_CODE = 'https://login.live.com/oauth20_authorize.srf?client_id=%s&scope=%s&response_type=code&redirect_uri=%s';

  //API
  URL_OAUTH2_TOKEN = 'https://login.live.com/oauth20_token.srf';
  URL_LIST_FOLDER = 'https://api.dropboxapi.com/2/files/list_folder';
  URL_FILE_UPLOAD = 'https://content.dropboxapi.com/2/files/upload';
  URL_FILE_SESSION_START = 'https://content.dropboxapi.com/2/files/upload_session/start';
  URL_FILE_SESSION_APPEND = 'https://content.dropboxapi.com/2/files/upload_session/append_v2';
  URL_FILE_SESSION_FINISH = 'https://content.dropboxapi.com/2/files/upload_session/finish';
  URL_GET_CURRENT_ACCOUNT = 'https://graph.microsoft.com/v1.0/users/';
  URL_FILE_DOWNLOAD = 'https://content.dropboxapi.com/2/files/download';
  URL_RESOURCE = 'https://graph.microsoft.com/v1.0';

type
  TOnLogAdd = procedure(s: string) of object;

  {FAccountID := jsonObj.Get('id').JsonValue.Value;

        FGivenName := jsonObj.Get('givenName').JsonValue.value;
        FDisplayName := jsonObj.Get('displayName').JsonValue.value;
        FSurname := jsonObj.Get('surname').JsonValue.value;
        FUserID := FAccountID;

        FEmail := jsonObj.Get('userPrincipalName').JsonValue.Value;}

  TOnGetAccountInfo = procedure(AccountID: string; GivenName: string; DisplayName: string; Surname: string; Email: string) of object;

  TOnUploadStart = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadProgress = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadEnd = procedure(FFilePath: string; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FQtdArquivos: Integer; FQtdEnviados: integer) of object;

  TOnUploadError = procedure(FFilePath: string; FMaxFileSize: integer; FFileSize: Integer; FSentSize: Integer; FSectionID: string; FSectionDateTIme: TDateTime) of object;

  TOneDriveOP = (TOpNone = 0, TOpDownload = 1, TOpUpload = 2);

  TOneDrive = class
  private
    FAcessToken: string;
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
    FTipo: TOneDriveOP;
    FstartWriteTime: Cardinal;
    FelapsedSeconds: Dword;
    FspeedBytesPerSeconds: Int64;
    FelapsedMilliSeconds: Dword;
    FTotalBytesSent: int64;
    FAcessCode: string;
    FUserID: string;
    FRefreshToken: string;
    FAcessTokenDateTime: TDateTime;
    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure SetProgress(const Value: Integer);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetAcessToken(const Value: string);
    function GetWebBrowserHTML(const WebBrowser: TWebBrowser): string;
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
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
    procedure SetTipo(const Value: TOneDriveOP);
    procedure SetstartWriteTime(const Value: Cardinal);
    procedure displayWriteSpeed(byteWritten: Int64);
    procedure SetelapsedMilliSeconds(const Value: Dword);
    procedure SetelapsedSeconds(const Value: Dword);
    procedure SetspeedBytesPerSeconds(const Value: Int64);
    procedure SetTotalBytesSent(const Value: int64);
    procedure SetCode(const Value: string);
    procedure SetUserID(const Value: string);
    procedure SetRefreshToken(const Value: string);
    procedure SetAcessTokenDateTime(const Value: TDateTime);
  public
    constructor Create;
    destructor destroy;
    //Account Functions
    procedure GetAcessCode;
    procedure GetAcessToken;
    procedure RefreshAcessToken;
    function GetAccountInfo: TJsonObject;
    function GetAccountPhoto: TJPEGImage;
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
    procedure VerificaAcessToken;
    procedure VerificaAcessCode;
    procedure VerificaRefreshToken;
  published
    property AcessToken: string read FAcessToken write SetAcessToken;
    property RefreshToken: string read FRefreshToken write SetRefreshToken;
    property AcessTokenDateTime: TDateTime read FAcessTokenDateTime write SetAcessTokenDateTime;
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
    property Tipo: TOneDriveOP read FTipo write SetTipo;
    property startWriteTime: Cardinal read FstartWriteTime write SetstartWriteTime;
    property elapsedMilliSeconds: Dword read FelapsedMilliSeconds write SetelapsedMilliSeconds;
    property elapsedSeconds: Dword read FelapsedSeconds write SetelapsedSeconds;
    property speedBytesPerSeconds: Int64 read FspeedBytesPerSeconds write SetspeedBytesPerSeconds;
    property TotalBytesSent: int64 read FTotalBytesSent write SetTotalBytesSent default 0;
    property AcessCode: string read FAcessCode write SetCode;
    property UserID: string read FUserID write SetUserID;
  end;

implementation

{ TOneDrive }

function TOneDrive.GetWebBrowserHTML(const WebBrowser: TWebBrowser): string;
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

procedure TOneDrive.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  if Pos('code=', URL) <> 0 then
  begin
    FAcessCode := Copy(URL, Pos('code=', URL) + 5, length(URL));
    FAcessCode := Copy(FAcessCode, 0, Pos('&lc=', FAcessCode) - 1);
    TForm(TWinControl(ASender).Parent).Close;
  end;
end;

procedure TOneDrive.ChangeLog(Sender: TObject);
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

constructor TOneDrive.Create;
begin
  FDefaultFolder := '/';
  FLog := TStringList.Create;
  FLog.OnChange := ChangeLog;
  FMaxFileSize := 10 * (1024 * 1024); // 10MB
  FQtdSent := 0;
  Tipo := TOpNone;
end;

destructor TOneDrive.destroy;
begin
  FLog.Free;
end;

procedure TOneDrive.Download(sFilePath, sDestination: string);
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
    FDataSent := 0;
    FQtdParts := 1;
    FQtdSent := 0;

    try

      Res := IdHTTP.Post(URL_FILE_DOWNLOAD, Source);

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

function TOneDrive.GetAccountInfo: TJsonObject;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  jsonObj, jSubObj: TJSONObject;
  ja: TJSONArray;
  jv: TJSONValue;
  SslHandler: TIdSSLIOHandlerSocketOpenSSL;
begin

  VerificaAcessToken;

  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'application/json';

    Source := TStringStream.Create('');
    try
      Res := IdHTTP.get(URL_RESOURCE + '/me');
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;
      Result := jsonObj;

      if Res <> '' then
      begin
        FAccountID := jsonObj.Get('id').JsonValue.Value;

        FGivenName := jsonObj.Get('givenName').JsonValue.value;
        FDisplayName := jsonObj.Get('displayName').JsonValue.value;
        FSurname := jsonObj.Get('surname').JsonValue.value;
        FUserID := FAccountID;

        FEmail := jsonObj.Get('userPrincipalName').JsonValue.Value;
      end;

      if Assigned(FOnGetAccountInfo) then
      {AccountID: string; GivenName: string; DisplayName: string; FSurname: string; FEmail: string)}
        FOnGetAccountInfo(FAccountID, FGivenName, FDisplayName, FSurname, FEmail);

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

function TOneDrive.GetAccountPhoto: TJPEGImage;
var
  IdHTTP: TIdHTTP;
  Source: TMemoryStream;
  Res: string;
  jsonObj, jSubObj: TJSONObject;
  ja: TJSONArray;
  jv: TJSONValue;
  SslHandler: TIdSSLIOHandlerSocketOpenSSL;
  image: TJPEGImage;
begin

  VerificaAcessToken;

  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + FAcessToken);
    IdHTTP.Request.ContentType := 'image/jpg';

    Source := TMemoryStream.Create;
    try
      IdHTTP.get('https://graph.microsoft.com/beta/me/photos/48x48/$value', Source);

      Source.Position := 0;
      Source.SaveToFile('c:/OneDrive/image.jpg');

      if Assigned(FOnGetAccountInfo) then
        FOnGetAccountInfo(FAccountID, FGivenName, FDisplayName, FSurname, FEmail);

    except
      on E: EIdHTTPProtocolException do
      begin
        FLog.Add('Código: ' + inttostr(e.ErrorCode) + #10#13 + 'Mensagem: ' + e.ErrorMessage);
        raise Exception.Create(GetException(e));
      end;
    end;
  finally
    IdHTTP.Free;
    image := TJPEGImage.Create;
    image.LoadFromStream(Source);
    Source.Free;

    Result := image;
  end;

end;

procedure TOneDrive.GetAcessCode;
var
  Link: string;
begin
  FormGetToken := TForm.Create(nil);
  FormGetToken.Width := 500;
  FormGetToken.Height := 550;
  FormGetToken.Position := poMainFormCenter;
  FWebBrowser := TWebBrowser.Create(FormGetToken);
  TWinControl(FWebBrowser).Parent := FormGetToken;
  FWebBrowser.Align := alClient;
  Link := Format(URL_ACESS_CODE, [AppKey, Scope, redirect_uri]);
  FWebBrowser.Navigate(Link);

  FWebBrowser.OnDocumentComplete := WebBrowser1DocumentComplete;
  FormGetToken.ShowModal;
end;

procedure TOneDrive.GetAcessToken;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  parameters: TStringList;
  jsonObj, jSubObj: TJSONObject;
  jv: TJSONValue;
  SslHandler: TIdSSLIOHandlerSocketOpenSSL;
begin

  VerificaAcessCode;

  if AcessCode <> '' then
  begin
    parameters := TStringList.Create;
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.HandleRedirects := True;
      SslHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
      SslHandler.SSLOptions.Method := sslvSSLv23;
      IdHTTP.IOHandler := SslHandler;

      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';

      parameters.Add('client_id=' + AppKey);
      parameters.Add('code=' + FAcessCode);
      parameters.Add('redirect_uri=https://login.live.com/oauth20_desktop.srf');
      parameters.Add('grant_type=authorization_code');

      //&

      try
        Res := IdHTTP.Post(URL_OAUTH2_TOKEN, parameters);
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;

        FAcessToken := jsonObj.Get('access_token').JsonValue.Value;
        try
          //FUserID := jsonObj.Get('user_id').JsonValue.Value;
        except

        end;
        try
          FRefreshToken := jsonObj.Get('refresh_token').JsonValue.Value;
        except

        end;
        FAcessTokenDateTime := now();
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

procedure TOneDrive.RefreshAcessToken;
var
  IdHTTP: TIdHTTP;
  Source: TStringStream;
  Res: string;
  parameters: TStringList;
  jsonObj, jSubObj: TJSONObject;
  jv: TJSONValue;
  SslHandler: TIdSSLIOHandlerSocketOpenSSL;
begin

  VerificaRefreshToken;

  parameters := TStringList.Create;
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.HandleRedirects := True;
    SslHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    SslHandler.SSLOptions.Method := sslvSSLv23;
    IdHTTP.IOHandler := SslHandler;

    IdHTTP.Request.BasicAuthentication := False;
    IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';

    parameters.Add('client_id=' + AppKey);
    parameters.Add('refresh_token=' + FRefreshToken);
    parameters.Add('redirect_uri=https://login.live.com/oauth20_desktop.srf');
    parameters.Add('grant_type=refresh_token');

    try
      Res := IdHTTP.Post(URL_OAUTH2_TOKEN, parameters);
      jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Res), 0) as TJSONObject;

      FAcessToken := jsonObj.Get('access_token').JsonValue.Value;
      FUserID := jsonObj.Get('user_id').JsonValue.Value;
      try
        FRefreshToken := jsonObj.Get('refresh_token').JsonValue.Value;
      except

      end;
      FAcessTokenDateTime := now();
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

end;

procedure TOneDrive.VerificaAcessCode;
begin
  if FAcessCode = '' then
  begin
    raise Exception.Create('AcessCode não foi informado.');
  end;
end;

function TOneDrive.GetFoldersAsString: string;
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

function TOneDrive.GetFolders: TJSONObject;
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

function TOneDrive.GetFoldersAsList(OrdenarPorNome: boolean = false): TStringList;

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

function TOneDrive.GetFilesAsList(OrdenarPorNome: boolean = false): TStringList;

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

procedure TOneDrive.SetAccountID(const Value: string);
begin
  FAccountID := Value;
end;

procedure TOneDrive.SetAcessToken(const Value: string);
begin
  FAcessToken := Value;
end;

procedure TOneDrive.SetAcessTokenDateTime(const Value: TDateTime);
begin
  FAcessTokenDateTime := Value;
end;

procedure TOneDrive.SetCode(const Value: string);
begin
  FAcessCode := Value;
end;

procedure TOneDrive.SetCountry(const Value: string);
begin
  FCountry := Value;
end;

procedure TOneDrive.SetDefaultFolder(const Value: string);
begin
  if length(Value) > 1 then
    FDefaultFolder := Value + '/'
  else
    FDefaultFolder := Value;
end;

procedure TOneDrive.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

procedure TOneDrive.SetelapsedMilliSeconds(const Value: Dword);
begin
  FelapsedMilliSeconds := Value;
end;

procedure TOneDrive.SetelapsedSeconds(const Value: Dword);
begin
  FelapsedSeconds := Value;
end;

procedure TOneDrive.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TOneDrive.SetFamiliarName(const Value: string);
begin
  FFamiliarName := Value;
end;

procedure TOneDrive.SetGivenName(const Value: string);
begin
  FGivenName := Value;
end;

procedure TOneDrive.SetFolderHasMore(const Value: Boolean);
begin
  FFolderHasMore := Value;
end;

procedure TOneDrive.SetFullFileSize(const Value: Int64);
begin
  FFullFileSize := Value;
end;

procedure TOneDrive.SetLocale(const Value: string);
begin
  FLocale := Value;
end;

procedure TOneDrive.SetLog(const Value: TStringList);
begin
  FLog := Value;
end;

procedure TOneDrive.SetMaxFileSize(const Value: integer);
begin
  FMaxFileSize := Value * (1024 * 1024);
end;

procedure TOneDrive.SetMemoLog(const Value: TMemo);
begin
  FMemoLog := Value;
end;

procedure TOneDrive.SetOnGetAccountInfo(const Value: TOnGetAccountInfo);
begin
  FOnGetAccountInfo := Value;
end;

procedure TOneDrive.SetOnLogAdd(const Value: TOnLogAdd);
begin
  FOnLogAdd := Value;
end;

procedure TOneDrive.SetOnUploadEnd(const Value: TOnUploadEnd);
begin
  FOnUploadEnd := Value;
end;

procedure TOneDrive.SetOnUploadError(const Value: TOnUploadError);
begin
  FOnUploadError := Value;
end;

procedure TOneDrive.SetOnUploadProgress(const Value: TOnUploadProgress);
begin
  FOnUploadProgress := Value;
end;

procedure TOneDrive.SetOnUploadStart(const Value: TOnUploadStart);
begin
  FOnUploadStart := Value;
end;

procedure TOneDrive.SetSurname(const Value: string);
begin
  FSurname := Value;
end;

procedure TOneDrive.SetTipo(const Value: TOneDriveOP);
begin
  FTipo := Value;
end;

procedure TOneDrive.SetTotalBytesSent(const Value: int64);
begin
  FTotalBytesSent := Value;
end;

procedure TOneDrive.SetTransferedBytes(const Value: Int64);
begin
  FTransferedBytes := Value;
end;

procedure TOneDrive.SetUploadSessionID(const Value: string);
begin
  FUploadSessionID := Value;
end;

procedure TOneDrive.SetUserID(const Value: string);
begin
  FUserID := Value;
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

procedure TOneDrive.UploadSessionStart;
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

procedure TOneDrive.UploadSessionAppend;
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

procedure TOneDrive.UploadSessionFinish;
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

procedure TOneDrive.Upload(sFile: string);
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

procedure TOneDrive.VerificaAcessToken;
begin
  if FAcessToken = '' then
  begin
    raise Exception.Create('AcessToken não foi informado.');
  end;
end;

procedure TOneDrive.VerificaRefreshToken;
begin
  if FRefreshToken = '' then
  begin
    raise Exception.Create('RefreshToken não foi informado.');
  end;
end;

function TOneDrive.GetException(e: EIdHTTPProtocolException): string;
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

  result := result + ' ----- ' + IntToStr(e.ErrorCode) + ') ' + e.Message;
end;

procedure TOneDrive.HTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if BytesToTransfer = 0 then
    Exit;

  Progress := Round((AWorkCount / BytesToTransfer) * 100);
  FTransferedBytes := AWorkCount;

  displayWriteSpeed(AWorkCount);
end;

procedure TOneDrive.HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if tipo = TOpDownload then
    FFullFileSize := AWorkCountMax;

  FTransferedBytes := 0;
  FBytesToTransfer := AWorkCountMax;
  startWriteTime := GetTickCount;
  displayWriteSpeed(-1);
end;

procedure TOneDrive.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  Progress := 100;
  displayWriteSpeed(FBytesToTransfer);
  FTotalBytesSent := FTotalBytesSent + FBytesToTransfer;
end;

procedure TOneDrive.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TOneDrive.displayWriteSpeed(byteWritten: Int64);
begin
  if byteWritten < 0 then
    Exit;

  try
    elapsedMilliSeconds := GetTickCount - startWriteTime;
    elapsedSeconds := elapsedMilliSeconds div 1000;
    if elapsedSeconds <> 0 then
      speedBytesPerSeconds := byteWritten div elapsedSeconds;
  except

  end;
end;

procedure TOneDrive.SetProgress(const Value: Integer);
begin
  FProgress := Value;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TOneDrive.SetQtdSent(const Value: integer);
begin
  FQtdSent := Value;
end;

procedure TOneDrive.SetRefreshToken(const Value: string);
begin
  FRefreshToken := Value;
end;

procedure TOneDrive.SetspeedBytesPerSeconds(const Value: Int64);
begin
  FspeedBytesPerSeconds := Value;
end;

procedure TOneDrive.SetstartWriteTime(const Value: Cardinal);
begin
  FstartWriteTime := Value;
end;

procedure TOneDrive.SetQtdParts(const Value: integer);
begin
  FQtdParts := Value;
end;

end.

