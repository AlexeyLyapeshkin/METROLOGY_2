program Project1;

uses
  Forms,
  UI in 'UI.pas' {Form1},
  uDictionary in 'uDictionary.pas',
  uLexer in 'uLexer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
