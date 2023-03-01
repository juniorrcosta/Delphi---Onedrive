program OneDrive;

uses
  Vcl.Forms,
  untOneDrive in 'untOneDrive.pas' {frmOneDrive},
  uOneDrive in 'uOneDrive.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmOneDrive, frmOneDrive);
  Application.Run;
end.
