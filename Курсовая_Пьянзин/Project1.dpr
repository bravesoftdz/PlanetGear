program Project1;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  Planet_Gear_2KH in 'Planet_Gear_2KH.pas',
  Vneshn in 'Vneshn.pas',
  Vnut in 'Vnut.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
