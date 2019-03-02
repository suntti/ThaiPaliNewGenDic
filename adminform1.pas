unit adminForm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, DbCtrls, kdbgrids, ZConnection, ZDataset, ZSqlUpdate,
  LCLType, Windows;

type

  { TSubjPaliForm }

  TSubjPaliForm = class(TForm)
    DBNavigator1: TDBNavigator;
    KDBGrid1: TKDBGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Filemnu: TMenuItem;
    Exitmnu: TMenuItem;
    Ying_btn: TButton;
    Tharn_btn: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZQuery1Content: TMemoField;
    ZQuery1PaliSubject: TMemoField;
    ZUpdateSQL1: TZUpdateSQL;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ExitmnuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Tharn_btnClick(Sender: TObject);
    procedure Ying_btnClick(Sender: TObject);
    procedure ZQuery1AfterDelete(DataSet: TDataSet);

    procedure ZQuery1AfterPost(DataSet: TDataSet);

    procedure onExcept(sender: TObject; e: Exception);
    procedure ZQuery1BeforePost(DataSet: TDataSet);
  private
   var KeyupTxt : string;
  public

  end;

var
  SubjPaliForm: TSubjPaliForm;

  Function AddFont    (Dir : PAnsiChar;
                      Flag: DWORD): LongBool; StdCall;
                      External GDI32
                      Name 'AddFontResourceExA';

 Function RemoveFont (Dir : PAnsiChar;
                      Flag: DWORD): LongBool; StdCall;
                      External GDI32
                      Name 'RemoveFontResourceExA';


implementation
uses ThaiNewGenDict1;
{$R *.lfm}

{ TSubjPaliForm }

procedure TSubjPaliForm.ExitmnuClick(Sender: TObject);
begin
  SubjPaliForm.Close;
  ZConnection1.Connected:=False;
  Form1.WindowState:= wsMaximized;
end;

procedure TSubjPaliForm.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
var
   strAppPath: String;
begin
  DataSource1.DataSet.Close ;

  DataSource1.DataSet.Close ;

    strAppPath:= IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
    If FileExists(strAppPath+'font\THSarabunPali.ttf')
  Then
   If RemoveFont(PAnsiChar(strAppPath+'font\THSarabunPali.ttf'), $10)
   Then SendMessage(Handle, WM_FONTCHANGE, 0, 0);

end;

procedure TSubjPaliForm.FormCreate(Sender: TObject);
var
    AppDir: String;
begin
    AppDir := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
    ZConnection1.Database := AppDir + 'DB\PaliSubject_main.db';
    ZConnection1.LibraryLocation := AppDir + 'SQLite3.dll';
    ZConnection1.Connected:=True;

    If FileExists(AppDir+'font\THSarabunPali.ttf')
  Then
   If AddFont(PAnsiChar(AppDir+'font\THSarabunPali.ttf'), $10) Then
   begin
     Form1.Font.Name:= 'TH Sarabun Pali';
     Tharn_btn.Font.Name:= 'TH Sarabun Pali';
     Ying_btn.Font.Name:= 'TH Sarabun Pali';
   end;

end;

procedure TSubjPaliForm.onExcept(sender: TObject; e: Exception);
var
  Reply, BoxStyle: Integer;
begin
  BoxStyle := MB_ICONQUESTION + MB_OK;
  Reply := Application.MessageBox('ผิดพลาดอาจพบข้อมูลซ้ำ', 'พบข้อผิดพลาด', BoxStyle);
  if Reply = IDOK then
   ZQuery1.Refresh;
end;

procedure TSubjPaliForm.ZQuery1BeforePost(DataSet: TDataSet);
begin
  application.onException := @onExcept;
end;

procedure TSubjPaliForm.FormShow(Sender: TObject);
begin

  DataSource1.DataSet.Open;
  ZQuery1.Active:=false;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Append('select * from PaliSubject');
  ZQuery1.Active:=true;

end;

procedure TSubjPaliForm.Tharn_btnClick(Sender: TObject);
begin
  if ComboBox1.ItemIndex=0 then
  begin
    //KeyupTxt := Edit1.Text+'';
    KeyupTxt := Edit1.Text+UTF8Encode(string(#63232));
    Edit1.Text:=KeyupTxt;

    if RadioGroup1.ItemIndex=0 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from PaliSubject where PaliSubject LIKE ''%'+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

    if RadioGroup1.ItemIndex=1 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from PaliSubject where content LIKE ''%'+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

  end;

  if ComboBox1.ItemIndex=1 then
  begin
    //KeyupTxt := DBMemo1.Text+'';
    KeyupTxt := DBMemo1.Text+UTF8Encode(string(#63232));
    DBMemo1.Text:=KeyupTxt;
  end;
end;

procedure TSubjPaliForm.Ying_btnClick(Sender: TObject);
begin
  if ComboBox1.ItemIndex=0 then
  begin
    //KeyupTxt := Edit1.Text+'';
    KeyupTxt := Edit1.Text+UTF8Encode(string(#63247));

    Edit1.Text:=KeyupTxt;

    if RadioGroup1.ItemIndex=0 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from PaliSubject where PaliSubject LIKE ''%'+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

    if RadioGroup1.ItemIndex=1 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from PaliSubject where content LIKE ''%'+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

  end;

  if ComboBox1.ItemIndex=1 then
  begin
    //KeyupTxt := DBMemo1.Text+'';
    KeyupTxt := DBMemo1.Text+UTF8Encode(string(#63247));
    DBMemo1.Text:=KeyupTxt;
  end;
end;

procedure TSubjPaliForm.ZQuery1AfterDelete(DataSet: TDataSet);
begin
  ZQuery1.Refresh;
  if Edit1.Text <> '' then
    Edit1.Text:='';

  if RadioGroup1.ItemIndex=0 then
  begin
     ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from PaliSubject where PaliSubject LIKE ''%'+Edit1.Text+'%''');
     ZQuery1.Active:=true;

  end;

  if RadioGroup1.ItemIndex=1 then
   begin
     ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from PaliSubject where content LIKE ''%'+Edit1.Text+'%''');
     ZQuery1.Active:=true;

   end;


end;


procedure TSubjPaliForm.ZQuery1AfterPost(DataSet: TDataSet);
begin
   ZQuery1.ApplyUpdates;
end;

procedure TSubjPaliForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if RadioGroup1.ItemIndex=0 then
 begin
  ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from PaliSubject where PaliSubject LIKE ''%'+Edit1.Text+'%''');
     ZQuery1.Active:=true;

 end;

if RadioGroup1.ItemIndex=1 then
 begin
     ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from PaliSubject where content LIKE ''%'+Edit1.Text+'%''');
     ZQuery1.Active:=true;

 end;
end;

procedure TSubjPaliForm.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if DataSource1.State in [dsEdit,dsInsert] then

    Edit1.Text:='';
end;


end.

