unit UI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, uLexer, uDictionary, Math;

type
  TForm1 = class(TForm)
    mainmenu: TMainMenu;
    N1: TMenuItem;
    Open: TMenuItem;
    SG1: TStringGrid;
    dlgOpen1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure ShowClick(Sender: TObject);
    procedure ShowClick2(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lexems: TLexems;
  operands, operators: TLexems;
  operands_info: TLexemsInf;
  operators_info: TLexemsInf;
  tempOperandsCount, tempOperatorsCount,programDictionary, programLength: Integer;
  programVolume, cl_otn: real;
  cl_abs,deep: Integer;


implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SG1.Visible := False;
SG1.Cells[0,0]:= '                         J';
SG1.Cells[1,0]:= '                  Оператор';
SG1.Cells[2,0]:= '                     F(1j)';
SG1.Cells[3,0]:= '                         I';
SG1.Cells[4,0]:= '                   Операнд';
SG1.Cells[5,0]:= '                     F(2j)';


end;

procedure TForm1.ShowClick(Sender: TObject);
begin
    ShowMessage('Объем программы: '+floattostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary));
end;
procedure TForm1.ShowClick2(Sender: TObject);
begin
    ShowMessage('cl: '+inttostr(cl_abs)+#10+#13+'CL: '+floattostr(cl_otn)+#10+#13+'CLs: '+inttostr(deep));
end;

procedure AddMainItem(s1,s2: string);
var
  newitem: Tmenuitem;
begin
  newitem := tmenuitem.create(Form1.mainmenu);
  newitem.caption := s1;
  newitem.onclick:= Form1.ShowClick;
  Form1.mainmenu.items.insert(Form1.mainmenu.items.count, newitem);
  newitem := tmenuitem.create(Form1.mainmenu);
  newitem.caption := s2;
  newitem.onclick:= Form1.ShowClick2;
  Form1.mainmenu.items.insert(Form1.mainmenu.items.count, newitem);
end;


procedure Djilbo_Metrix(filename: string);
var temp_arr : TLexemsInf;
i,j,temp_count: integer;
begin
  j:=0;
  SetLength(temp_arr,Length(temp_arr)+1);
  for i:=0 to Length(operators_info)-1 do
  begin
     if (operators_info[i].name = 'if') or (operators_info[i].name = 'while') or (operators_info[i].name = 'for') or (operators_info[i].name = 'elif')  then
     begin
         temp_arr[j].name := operators_info[i].name;
         temp_arr[j].count := operators_info[i].count;
         SetLength(temp_arr,Length(temp_arr)+1);
         Inc(j);
     end;
  end;
  temp_count := 0;
  //ShowMessage(IntToStr(temp_arr[0].count)+' '+IntToStr(temp_arr[1].count)+' '+IntToStr(temp_arr[2].count));
  for i:=0 to Length(temp_arr)-1 do
  begin
     //ShowMessage(temp_arr[i].name+'-'+inttostr(temp_arr[i].count));
     temp_count := temp_count + temp_arr[i].count;
  end;
  cl_abs := temp_count;
  cl_otn := temp_count / tempOperatorsCount;
  ShowMessage('cl: '+inttostr(cl_abs)+#10+#13+'CL: '+floattostr(cl_otn));
end;

function if_in_line(line :string):Boolean;
var temp: TLexems;
    i:integer;
begin
  temp := lexems_from_line(line);
  Result:=False;
  for i:=0 to Length(temp)-1 do
  begin
    if (temp[i] = 'if') then
    begin
        Result := True;
        Break;
    end;
  end;
end;


function elif_in_line(line :string):Boolean;
var temp: TLexems;
    i:integer;
begin
  temp := lexems_from_line(line);
  Result:=False;
  for i:=0 to Length(temp)-1 do
  begin
    if (temp[i] = 'elif') then
    begin
        Result := True;
        Break;
    end;
  end;
end;

function binary_ex_in_line(line:string): Boolean;
var temp: TLexems;
    i:integer;
begin
  temp := lexems_from_line(line);
  Result:=False;
  for i:=0 to Length(temp)-1 do
  begin
    if (temp[i] = 'if') or (temp[i] = 'for') or (temp[i] = 'while') or (temp[i] = 'elif') then
    begin
        Result := True;
        Break;
    end;
  end;
end;

procedure Extended_djilbo(filename: string);
var f: TextFile;
    temp_str: string;
    temp_deep,i: Integer;
    temp_if: Integer;
    temp_elif : Integer;
    first: Boolean;

begin
   AssignFile(F, filename);
   Reset(F);
   temp_str := '';
   temp_deep := 0;
   deep := 0;
   first := False;
   temp_elif:=0;

   while not(Eof(F)) do
   begin
      readln(f,temp_str);


      for i:=1 to Length(temp_str) do
      begin
        if (temp_str[i] = ' ') and binary_ex_in_line(temp_str) then
        begin
          Inc(temp_deep);
        end
        else Break;
      end;



      if if_in_line(temp_str) then
      begin
        if not(first) then
        begin
          temp_if := temp_deep;
          first := True;
        end;

        if temp_deep <= temp_if then
        begin
          temp_if := temp_deep;
          temp_elif:= 0;
        end;
      end;

      if elif_in_line(temp_str) then
      begin

         Inc(temp_elif);
         temp_deep:= temp_deep + 4*temp_elif;

      end;

      if (temp_deep > deep) and (temp_deep mod 4 = 0) then
      begin
        deep := temp_deep;
      end;

      temp_str := '';
      temp_deep := 0;

   end;
   deep := deep div 4;
   ShowMessage('CLs: '+floatToStr(deep));
end;

procedure generateTable(filename : string);
var
    i,mem,kek: Integer;

begin
  Form1.SG1.Visible := true;

  lexems := lexems_from_file(filename);
  lex_alloc(operands, operators, lexems);
  operands_info := get_lexem_info(operands);
  operators_info := get_lexem_info(operators);
  //ShowMessage(intToStr(programDictionary));

  programDictionary := length(operands_info)  + Length(operators_info);
  tempOperandsCount := 0;
  tempOperatorsCount := 0;
  for i:= 0 to Length(operands_info)-1 do
      inc(tempOperandsCount, operands_info[i].count);
  for i:= 0 to Length(operators_info)-1 do
      inc(tempOperatorsCount, operators_info[i].count);
  programLength := tempOperandsCount + tempOperatorsCount;
  if programDictionary <> 0 then
  programVolume := programLength * log2(programDictionary);

  if programLength <> 0 then
  begin
    for i:=0 to Length(operators_info)-1 do
    begin
      Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
      Form1.SG1.Cells[0,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[1,i+1] := operators_info[i].name;
      Form1.SG1.Cells[2,i+1] := IntToStr(operators_info[i].count);
    end;
    //ShowMessage(IntToStr(i));
    mem := i;
    for i:=0 to Length(operands_info)-1 do
    begin
      if i >= mem+1 then
      begin
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' :))';
        Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' :))';
      end;
      Form1.SG1.Cells[3,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[4,i+1] := operands_info[i].name;
      Form1.SG1.Cells[5,i+1] := IntToStr(operands_info[i].count);
    end;

    kek := i;
    Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
    Form1.SG1.Cells[0,Form1.SG1.RowCount] := 'Уникальных операторов';
    Form1.SG1.Cells[1,Form1.SG1.RowCount] := 'Вхождения операторв (N1)';
    Form1.SG1.Cells[2,Form1.SG1.RowCount] := 'Уникальных операндов ';
    Form1.SG1.Cells[3,Form1.SG1.RowCount] := 'Вхождения операндов (N2)';
    Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
    Form1.SG1.Cells[0,Form1.SG1.RowCount] := IntToStr(mem);
    Form1.SG1.Cells[2,Form1.SG1.RowCount] := IntToStr(kek);
    Form1.SG1.Cells[1,Form1.SG1.RowCount] := IntToStr(tempOperatorsCount);
    Form1.SG1.Cells[3,Form1.SG1.RowCount] := IntToStr(tempOperandsCount);


    ShowMessage('Объем программы: '+floattostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary));

     AddMainItem('Расширенные','Джилбо');
     Djilbo_Metrix(filename);
     Extended_djilbo(filename);
   end
   else ShowMessage('К сожалению, файл пуст :(');
end;


procedure TForm1.OpenClick(Sender: TObject);
begin
    if dlgOpen1.Execute then
      generateTable(dlgOpen1.filename);
   SG1.RowCount := SG1.RowCount + 1;
   Repaint;
end;

end.
