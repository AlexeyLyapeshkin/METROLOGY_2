unit uLexer;

interface

uses
  uDictionary; {словарь ключевых слов и операторов python}

function lexems_from_line(const line_str: String): TLexems;
procedure lex_alloc(var operands, operators: TLexems; const lexems: TLexems);
function lexems_from_file(const filename: String): TLexems;
function get_lexem_info(const lexems: TLexems): TLexemsInf;


implementation

function get_lexem_info(const lexems: TLexems): TLexemsInf;
{
*подсчет лексем
}
var
  i, index: Integer;
begin
  SetLength(Result, 0);
  for i := 0 to length(lexems) - 1 do
  begin
    index := lexem_in_list(Result, lexems[i]);
    if index = -1 then
    begin  //добавление нового элемента
      SetLength(Result, length(Result) + 1);
      Result[length(Result) - 1].name := lexems[i];
      Result[length(Result) - 1].count := 1;
    end
    else  //увеличение счетчика
    begin
      with Result[index] do
        count := count + 1;
    end;
  end;
end;

function lexems_from_file(const filename: String): TLexems;
{
*чтение построчно файл, парсинг на лексемы
*возвращает ВСЕ лексемы из файла
}
var
  F: TextFile;
  line: String;
  lexems_in_line: TLexems;
  i: Integer;
  index: Integer;
  len: Integer;
begin
  AssignFile(F, filename);

    
  Reset(F);
  
  line := '';
  SetLength(Result, 0);
  while not (EOF(F)) do
  begin
    readln(F, line);
    SetLength(lexems_in_line, 0);
    lexems_in_line := lexems_from_line(line);
    index := length(Result); //индекс, с которого заполнять массив
    len := length(Result) + length(lexems_in_line); //количество лексем
    SetLength(Result, len);
    for i := 0 to length(lexems_in_line) - 1 do
    begin
      Result[index] := lexems_in_line[i];
      index := index + 1;
    end;
  end;
  CloseFile(F);
end;

procedure lex_alloc(var operands, operators: TLexems; const lexems: TLexems);
{
*распределение лексем по массивам операндов, операторов
*операнды - переменные, константы
*операторы - ост.
*возвращает два массива
}
var
  i: Integer;
begin
  SetLength(operators, 0);
  SetLength(operands,0);
  for i := 0 to length(lexems) - 1 do
  begin
    if (lexem_in_py_statements(lexems[i])) or (lexem_in_py_keywords(lexems[i])) then
    begin  //если ключевое слово/оператор
      SetLength(operators, length(operators) + 1);
      operators[length(operators) - 1] := lexems[i];
    end
    else
    begin
      if pos('( )', lexems[i]) <> 0 then
      begin //если функция
        SetLength(operators, length(operators) + 1);
        operators[length(operators) - 1] := lexems[i];
      end
      else
      begin //операнд
        SetLength(operands, length(operands) + 1);
        operands[length(operands) - 1] := lexems[i];
      end;
    end;
  end;
end;

function lexems_from_line(const line_str: String): TLexems;
{
*парсинг строки кода на лексемы
}
var
  i: Integer;
  lexem_pos: Integer;
  lexem: TLexem;
begin
  SetLength(Result, 0);
  lexem_pos := 1;

  lexem := '';

  while lexem_pos <= length(line_str) do
  begin
    while line_str[lexem_pos] = ' ' do
      lexem_pos := lexem_pos + 1;

    if line_str[lexem_pos] = '#' then //однострочный комментарий  - выход
    begin
      Break;
    end;

    i := lexem_pos;

    while (line_str[i] in py_identifier) do
      i := i + 1;
    //если дробное ЧИСЛО(!) - продолжаем
    if (line_str[lexem_pos] in ['0'..'9']) and (line_str[i] = '.') then
    begin
      i := i + 1;
      while (line_str[i] in py_identifier) do
        i := i + 1;
    end;
    //если константа строка
    if ((line_str[i] = '"') or (line_str[i] = '''')) then
    begin
      i := i + 1;  // включить открывающую скобку
      while not ((line_str[i] = '"') or (line_str[i] = '''')) do
        i := i + 1;  // включить текст
      i := i + 1; // включить закрываюущую скобку
    end;
    //если не идентефикатор
    if i = lexem_pos then
      while lexem_in_py_statements(line_str[i]) do
        i := i + 1;

    lexem := copy(line_str, lexem_pos, i - lexem_pos);

    if ((line_str[i] = '(')) and (not (lexem_in_py_statements(lexem))) then //если функция или оператор-СКОБКА
    begin
      lexem := lexem + '( )';
      i := i + 1;
    end;

    if (line_str[i] = ')') then
      i := i + 1;

    if lexem <> '' then //если символ/лексема не определены - ничего не добавляется
    begin
      SetLength(Result, length(Result) + 1);
      Result[length(result) - 1] := lexem;
    end;

    //переход на следующую лексему
    if lexem_pos < i then
      lexem_pos := i
    else //если никакой символ не определен - переход на новый символ
      lexem_pos := i + 1;
  end;
end;



end.
