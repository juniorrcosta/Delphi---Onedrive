program Project8;

uses
  Vcl.Forms,
  Unit15 in 'Unit15.pas' {Form15},
  uDropbox in 'uDropbox.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
