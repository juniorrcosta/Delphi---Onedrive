unit untOneDrive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uOneDrive,
  Vcl.ExtCtrls, dateutils;

type
  TfrmOneDrive = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    EdtAcessCode: TLabeledEdit;
    Button2: TButton;
    edtAcessToken: TLabeledEdit;
    Button3: TButton;
    Panel1: TPanel;
    Button4: TButton;
    GroupBox2: TGroupBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Memo1: TMemo;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblemail: TLabel;
    lbldname: TLabel;
    lblgsname: TLabel;
    lblaccID: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    procedure AccountInfo(AccountID: string; GivenName: string; DisplayName: string; Surname: string; Email: string);
    { Private declarations }
  public
    OneDrive: TOneDrive;
  end;

var
  frmOneDrive: TfrmOneDrive;

implementation

{$R *.dfm}

procedure TfrmOneDrive.Button1Click(Sender: TObject);
begin
  OneDrive.GetAcessCode;
  EdtAcessCode.Text := OneDrive.AcessCode;

end;

procedure TfrmOneDrive.Button3Click(Sender: TObject);
begin
  OneDrive.getacesstoken;
  if OneDrive.AcessToken <> '' then
  begin
    edtAcessToken.Text := OneDrive.AcessToken;
    Panel1.Caption := 'Acess Token válido até: ' + FormatDateTime('c', IncHour(OneDrive.AcessTokenDateTime, 1));
  end;
end;

procedure TfrmOneDrive.Button4Click(Sender: TObject);
begin

  Button1.Click;
  Button3.Click;

end;

procedure TfrmOneDrive.Button5Click(Sender: TObject);
begin
  if OneDrive.RefreshToken <> '' then
  begin
    OneDrive.RefreshAcessToken;
    if OneDrive.AcessToken <> '' then
    begin
      edtAcessToken.Text := OneDrive.AcessToken;
      Panel1.Caption := 'Acess Token válido até: ' + FormatDateTime('c', IncHour(OneDrive.AcessTokenDateTime, 1));
    end;
  end;
end;

procedure TfrmOneDrive.Button6Click(Sender: TObject);
begin
  OneDrive.GetAccountInfo;
end;

procedure TfrmOneDrive.Button7Click(Sender: TObject);
begin
  image1.Picture.Assign(OneDrive.GetAccountPhoto);

end;

procedure TfrmOneDrive.AccountInfo(AccountID: string; GivenName: string; DisplayName: string; Surname: string; Email: string);
begin
  lblemail.Caption := Email;
  lbldname.Caption := DisplayName;
  lblgsname.Caption := GivenName+' '+Surname;
  lblaccID.Caption := AccountID;
end;

procedure TfrmOneDrive.FormCreate(Sender: TObject);
begin
  OneDrive := TOneDrive.Create;
  OneDrive.MemoLog := Memo1;
  OneDrive.OnGetAccountInfo := AccountInfo;
end;

end.

