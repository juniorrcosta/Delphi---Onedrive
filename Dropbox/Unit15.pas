unit Unit15;

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
  uDropBox,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Data.DBXJSON,
  Vcl.ImgList,
  IdAntiFreezeBase,
  Vcl.IdAntiFreeze,
  Vcl.Samples.Spin;

type
  TForm15 = class(TForm)
    Memo1: TMemo;
    Img: TImageList;
    OpenDialog1: TOpenDialog;
    Button7: TButton;
    IdAntiFreeze1: TIdAntiFreeze;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lblAccountID: TLabel;
    lblEmail: TLabel;
    lblDisplayName: TLabel;
    lblgName: TLabel;
    lblsName: TLabel;
    lblCountry: TLabel;
    lblLocale: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressBar1: TProgressBar;
    edtArquivo: TEdit;
    Button3: TButton;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    Button8: TButton;
    Button4: TButton;
    Button5: TButton;
    edtAcessCode: TLabeledEdit;
    edtAcessToken: TLabeledEdit;
    Button6: TButton;
    Label11: TLabel;
    GetFolderList: TButton;
    Button2: TButton;
    Button9: TButton;
    TreeView1: TTreeView;
    edtPasta: TEdit;
    Label1: TLabel;
    Label13: TLabel;
    ProgressBar2: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure GetFolderListClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    procedure AddPath(Tree: TTreeView; List: TStringList);
    procedure PreencherAccountInfo(s: string);
    procedure DropBOxOnChange(Sender: TObject);
    { Private declarations }
  public
    DropBox: TDropBox;
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

procedure TForm15.Button1Click(Sender: TObject);
begin
  if FileExists(edtArquivo.Text) then begin
    DropBox.Upload(edtArquivo.Text);
  end else
    ShowMessage('Selecione um arquivo válido!');
end;

procedure TForm15.Button4Click(Sender: TObject);
begin
  DropBox.GetAcessCode;
  edtAcessCode.Text := DropBox.AcessCode;
end;

procedure TForm15.Button5Click(Sender: TObject);
begin
  DropBox.GetAcessToken;
  edtAcessToken.Text := DropBox.AcessToken;
end;

procedure TForm15.Button6Click(Sender: TObject);
begin
  DropBox.AcessToken := edtAcessToken.Text;
end;

procedure TForm15.Button7Click(Sender: TObject);
begin
  DropBox.GetAccountInfo;
end;

procedure TForm15.Button8Click(Sender: TObject);
begin
  DropBox.GetAcessCode;
  edtAcessCode.Text := DropBox.AcessCode;
  if DropBox.AcessCode <> '' then
  begin
    DropBox.GetAcessToken;
    edtAcessToken.Text := DropBox.AcessToken;
  end
  else
    ShowMessage('Acess Code inválido!');

  if DropBox.AcessToken <> '' then
  begin
    DropBox.GetAccountInfo;
  end
  else
  begin
    ShowMessage('Acess Token inválido!');
  end;

end;

procedure TForm15.Button9Click(Sender: TObject);
var
  sPath: string;
  node: TTreeNode;
begin
  if Assigned(TreeView1.Selected) then
  begin
    node := TreeView1.Selected;

    //if node.ImageIndex = 0 then
    sPath := '/' + TreeView1.Selected.Text;

    while Assigned(node.Parent) do
    begin
      node := node.Parent;
      sPath := '/' + node.Text + sPath;
    end;

    if sPath <> '' then
      DropBox.Download(sPath, 'c:' + sPath);

    //DropBox.DefaultFolder := sPath;
    //edtPasta.Text := DropBox.DefaultFolder;
  end
  else
  begin
    //DropBox.DefaultFolder := '/';
    //edtPasta.Text := DropBox.DefaultFolder;
  end;
end;

procedure TForm15.PreencherAccountInfo(s: string);
begin
  lblAccountID.Caption := DropBox.AccountID;
  lblEmail.Caption := DropBox.Email;
  lblDisplayName.Caption := DropBox.DisplayName;
  lblgName.Caption := DropBox.GivenName;
  lblsName.Caption := DropBox.Surname;
  lblLocale.Caption := DropBox.Locale;
  lblCountry.Caption := DropBox.Country;
end;

procedure TForm15.DropBOxOnChange(Sender: TObject);
var
  QtDOwnloaded: integer;
begin
  if TDropBox(Sender).QtdSent+1 > TDropBox(Sender).QtdParts then begin
    label3.Caption := 'Processo Finalizado!';
    exit;
  end;

  QtDOwnloaded := TDropBox(Sender).QtdSent + 1;

  if (TDropBox(Sender).TransferedBytes <> 0) and (TDropBox(Sender).BytesToTransfer <> 0) then
  begin
    begin
      ProgressBar1.Max := TDropBox(Sender).FullFileSize;
      ProgressBar1.Position := TDropBox(Sender).TransferedBytes + TDropBox(Sender).TotalBytesSent;

      ProgressBar2.Max := TDropBox(Sender).QtdParts;
      ProgressBar2.Position := QtDOwnloaded;

      label3.Caption := {'Parte ' + inttostr(QtDOwnloaded) + ' de ' + inttostr(ProgressBar2.Max) + ' - ' +} FormatFloat('###0.####', ((ProgressBar1.Position / (1024 * 1024)))) + 'MBs ' + '/' + FormatFloat('###0.####', ((ProgressBar1.Max / (1024 * 1024)))) + 'MBs  - Velocidade: '+Format(' %d b/s', [TDropBox(Sender).speedBytesPerSeconds ] );
    end

  end;

  Application.ProcessMessages;
end;

procedure TForm15.FormCreate(Sender: TObject);
begin
  DropBox := TDropBox.Create;
  DropBox.MemoLog := Memo1;
  DropBox.OnGetAccountInfo := PreencherAccountInfo;
  DropBox.OnChange := DropBOxOnChange;
  edtPasta.Text := DropBox.DefaultFolder;
end;

procedure TForm15.GetFolderListClick(Sender: TObject);
var
  FolderList: TStringList;
  i: Integer;
begin
  TreeView1.Items.Clear;
  FolderList := DropBox.GetFoldersAsList(true);
  AddPath(TreeView1, FolderList);

end;

procedure TForm15.SpinEdit1Change(Sender: TObject);
begin
  DropBox.MaxFileSize := SpinEdit1.Value;
end;

procedure TForm15.TreeView1DblClick(Sender: TObject);
var
  sPath: string;
  node: TTreeNode;
begin
  if Assigned(TreeView1.Selected) then
  begin
    node := TreeView1.Selected;

    if node.ImageIndex = 0 then
      sPath := '/' + TreeView1.Selected.Text;

    while Assigned(node.Parent) do
    begin
      node := node.Parent;
      sPath := '/' + node.Text + sPath;
    end;

    if sPath = '' then
      sPath := '/';

    DropBox.DefaultFolder := sPath;
    edtPasta.Text := DropBox.DefaultFolder;
  end
  else
  begin
    DropBox.DefaultFolder := '/';
    edtPasta.Text := DropBox.DefaultFolder;
  end;
end;

procedure TForm15.Button2Click(Sender: TObject);
var
  FileList: TStringList;
  i: Integer;
begin
  TreeView1.Items.Clear;
  FileList := DropBox.GetFilesAsList(true);
  AddPath(TreeView1, FileList);

end;

procedure TForm15.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtArquivo.Text := OpenDialog1.FileName;
end;

procedure TForm15.AddPath(Tree: TTreeView; List: TStringList);
var
  ANode, ALevelNode: TTreeNode;
  ANodeCaption, ACaptionAnterior, buffer, s: string;
  i, j: Integer;

  function NodeAsPath(Node: TTreeNode): string;
  var
    anode: TTreeNode;
  begin
    result := '';

    anode := Node;
    while anode <> nil do
    begin
      if result <> '' then
        result := anode.Text + '\' + result
      else
        result := anode.Text;

      anode := anode.Parent;
    end;
  end;

  function PathToNode(const Path: string; Tree: TTreeView): TTreeNode;
  begin
    result := nil;

    if Tree.Items.Count > 0 then
    begin
      result := Tree.Items[0];
      while (result <> nil) and (AnsiCompareText(NodeAsPath(result), Path) <> 0) do
        result := result.GetNext;
    end;
  end;

begin

  Tree.Items.Clear;

  for i := 0 to List.Count - 1 do
  begin
    begin
      { NOVA ROTINA PARA ADICIONAR - CORRIGE PROBLEMA QUE ESTAVA DANDO AO ADICIONAR ITENS COM O MESMO NOME
      06/02/2018 - #84722 }

      buffer := ExcludeTrailingBackSlash(List[i]);
      if (buffer <> '') and (buffer[1] = '\') then
        Delete(buffer, 1, 1);

      if buffer <> '' then
      begin
        s := buffer;
        ANode := PathToNode(s, Tree);

        while (s <> '') and (ExtractFilePath(s) <> s) and (ANode = nil) do
        begin
          s := ExcludeTrailingBackSlash(ExtractFilePath(s));
          ANode := PathToNode(s, Tree);
        end;

        if ANode <> nil then
          Delete(buffer, 1, Length(s));

        if (buffer <> '') and (buffer[1] = '\') then
          Delete(buffer, 1, 1);

        if (buffer <> '') and (buffer[Length(buffer)] <> '\') then
          buffer := buffer + '\';

        while buffer <> '' do
        begin
          j := Pos('\', buffer);
          if j > 1 then
          begin
            s := Copy(buffer, 1, j - 1);
            Delete(buffer, 1, j);

            if ANode = nil then
              ANode := Tree.Items.Add(nil, s)
            else
              ANode := Tree.Items.AddChild(ANode, s);

            //ANode.SelectedIndex := 10;
            ANode.ImageIndex := 2;

            if ExtractFileExt(ANode.Text) = '' then
              ANode.ImageIndex := 0
            else if ExtractFileExt(ANode.Text) = '.rar' then
              ANode.ImageIndex := 5
            else if ExtractFileExt(ANode.Text) = '.bk' then
              ANode.ImageIndex := 5
            else if ExtractFileExt(ANode.Text) = '.tar' then
              ANode.ImageIndex := 5
            else if ExtractFileExt(ANode.Text) = '.zip' then
              ANode.ImageIndex := 4
            else if ExtractFileExt(ANode.Text) = '.gbk' then
              ANode.ImageIndex := 5
            else if ExtractFileExt(ANode.Text) = '.pdf' then
              ANode.ImageIndex := 9
            else if ExtractFileExt(ANode.Text) = '.doc' then
              ANode.ImageIndex := 7
            else if ExtractFileExt(ANode.Text) = '.docx' then
              ANode.ImageIndex := 7
            else if ExtractFileExt(ANode.Text) = '.odt' then
              ANode.ImageIndex := 7
            else if ExtractFileExt(ANode.Text) = '.xls' then
              ANode.ImageIndex := 8
            else if ExtractFileExt(ANode.Text) = '.txt' then
              ANode.ImageIndex := 3
            else if ExtractFileExt(ANode.Text) = '.rtf' then
              ANode.ImageIndex := 3
            else if ExtractFileExt(ANode.Text) = '.wpd' then
              ANode.ImageIndex := 3
            else if ExtractFileExt(ANode.Text) = '.exe' then
              ANode.ImageIndex := 11
            else if ExtractFileExt(ANode.Text) = '.mp3' then
              ANode.ImageIndex := 13
            else
              ANode.ImageIndex := 2;

            ANode.SelectedIndex := ANode.ImageIndex;

          end;
        end;
      end;
    end;
  end;

end;

end.

