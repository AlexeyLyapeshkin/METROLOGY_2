unit uDictionary;

interface

type
  TLexem = String;
  TLexems = array of TLexem;

  TLexInf = record
    name: TLexem;
    count: Integer;
  end;
  TLexemsInf = array of TLexInf;


const
  py_identifier = ['A'..'Z', 'a'..'z', '_', '0'..'9'];

  py_keywords: array[1..33] of string = (
                'False', 'None', 'True', 'and', 'as', 'assert', 'break',
                'class', 'continue', 'def', 'del', 'elif', 'else', 'except',
                'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is',
                'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return',
                'try', 'while', 'with', 'yield'
                );

  py_statements: array[1..28] of string = (
                  '+', '-', '*', '**', '/', '//', '%', '@', '<<',
                  '>>', '&', '|', '^', '~', '<', '>', '<=', '>=',
                  '==', '!=', '=', '+=', '*=', '/=', '-=', '%=',
                  '**=', '//='
                  );

function lexem_in_py_keywords(const lexem: TLexem): Boolean;
function lexem_in_py_statements(const lexem: TLexem): Boolean;
function lexem_in_list(const lexems: TLexemsInf; const lexem: TLexem): Integer;

implementation

function lexem_in_list(const lexems: TLexemsInf; const lexem: TLexem): Integer;
{
Лексема уже в списке лексем: Да - индекс/ нет - (-1)
}
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while (i <= length(lexems) - 1) and (Result = - 1) do
  begin
    if lexem = lexems[i].name then
      Result := i;
    i := i + 1;
  end;
end;

function lexem_in_py_statements(const lexem: TLexem): Boolean;
{Лехема в списке операторов: да - True; нет - False}
var
  i: Integer;
begin
  Result := False;
  i := 1;
  while (i <= length(py_statements)) and (not Result) do
  begin
    if lexem = py_statements[i] then
    begin
      Result := True;
    end;
    Inc(i);
  end;
end;

function lexem_in_py_keywords(const lexem: TLexem): Boolean;
{Лехема в списке ключевых слов: да - True; нет - False}
var
  i: Integer;
begin
  Result := False;
  i := 1;
  while (i <= length(py_keywords)) and (not Result) do
  begin
    if lexem = py_keywords[i] then
    begin
      Result := True;
    end;
    Inc(i);
  end;
end;

end.
