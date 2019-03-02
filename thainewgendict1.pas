unit ThaiNewGenDict1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, DbCtrls, Buttons, kdbgrids, ZConnection, ZDataset,
  ZSqlUpdate, adminForm1, LConvEncoding, LCLType, Windows, about1;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Image1: TImage;
    Label4: TLabel;
    Aboutmnu: TMenuItem;
    AboutRealmnu: TMenuItem;
    Tharn_btn: TBitBtn;
    Ying_btn: TBitBtn;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Edit1: TEdit;
    KDBGrid1: TKDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Filemnu: TMenuItem;
    Exitmnu: TMenuItem;
    LearnSubjectMainmnu: TMenuItem;
    LearnStrPali_mnu: TMenuItem;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZQuery1content: TMemoField;
    ZQuery1Paliword: TMemoField;
    ZUpdateSQL1: TZUpdateSQL;

    procedure AboutRealmnuClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure LearnStrPali_mnuClick(Sender: TObject);
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
  Form1: TForm1;

  Function AddFont    (Dir : PAnsiChar;
                      Flag: DWORD): LongBool; StdCall;
                      External GDI32
                      Name 'AddFontResourceExA';

 Function RemoveFont (Dir : PAnsiChar;
                      Flag: DWORD): LongBool; StdCall;
                      External GDI32
                      Name 'RemoveFontResourceExA';

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ExitmnuClick(Sender: TObject);
begin
  Form1.Close;
  ZConnection1.Connected:=False;
end;

procedure TForm1.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if RadioGroup1.ItemIndex=0 then
 begin
  ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from palithaiNewGen where Paliword LIKE '''+Edit1.Text+'%''');
     ZQuery1.Active:=true;

 end;

if RadioGroup1.ItemIndex=1 then
 begin
     ZQuery1.Active:=false;
     ZQuery1.SQL.Clear;
     ZQuery1.SQL.Append('select * from palithaiNewGen where content LIKE ''%'+Edit1.Text+'%''');
     ZQuery1.Active:=true;

 end;
end;

procedure TForm1.LearnStrPali_mnuClick(Sender: TObject);
begin
  SubjPaliForm.Show;
  Form1.WindowState:= wsMinimized;
end;

procedure TForm1.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
  if DataSource1.State in [dsEdit,dsInsert] then

    Edit1.Text:='';

end;

procedure TForm1.AboutRealmnuClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   strAppPath: String;
begin
    DataSource1.DataSet.Close ;

    strAppPath:= IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
    If FileExists(strAppPath+'font\THSarabunPali.ttf')
  Then
   If RemoveFont(PAnsiChar(strAppPath+'font\THSarabunPali.ttf'), $10)
   Then SendMessage(Handle, WM_FONTCHANGE, 0, 0);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    AppDir: String;
begin
    AppDir := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
    ZConnection1.Database := AppDir + 'DB\palitothai_newgen.db';
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

  Image1.Picture.LoadFromFile(AppDir+'img\BuddhaFace180.png');
  Image1.Stretch:=True;

end;

procedure TForm1.onExcept(sender: TObject; e: Exception);
var
  Reply, BoxStyle: Integer;
begin
  BoxStyle := MB_ICONQUESTION + MB_OK;
  Reply := Application.MessageBox('ผิดพลาดอาจพบข้อมูลซ้ำ', 'พบข้อผิดพลาด', BoxStyle);
  if Reply = IDOK then
   ZQuery1.Refresh;
end;

procedure TForm1.ZQuery1BeforePost(DataSet: TDataSet);
begin
  application.onException := @onExcept;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    AppDir: String;
begin

  DataSource1.DataSet.Open;
  ZQuery1.Active:=false;
  ZQuery1.SQL.Clear;
  ZQuery1.SQL.Append('select * from palithaiNewGen');
  ZQuery1.Active:=true;

end;


procedure TForm1.Tharn_btnClick(Sender: TObject);
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
      ZQuery1.SQL.Append('select * from palithaiNewGen where Paliword LIKE '''+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

    if RadioGroup1.ItemIndex=1 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from palithaiNewGen where content LIKE ''%'+Edit1.Text+'%''');
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

procedure TForm1.Ying_btnClick(Sender: TObject);
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
      ZQuery1.SQL.Append('select * from palithaiNewGen where Paliword LIKE '''+Edit1.Text+'%''');
      ZQuery1.Active:=true;

    end;

    if RadioGroup1.ItemIndex=1 then
    begin
      ZQuery1.Active:=false;
      ZQuery1.SQL.Clear;
      ZQuery1.SQL.Append('select * from palithaiNewGen where content LIKE ''%'+Edit1.Text+'%''');
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

procedure TForm1.ZQuery1AfterDelete(DataSet: TDataSet);
begin

  ZQuery1.ApplyUpdates;
  if Edit1.Text <> '' then
  begin
    Edit1.Text:='';

    if RadioGroup1.ItemIndex=0 then
     begin
       ZQuery1.Active:=false;
       ZQuery1.SQL.Clear;
       ZQuery1.SQL.Append('select * from palithaiNewGen where Paliword LIKE '''+Edit1.Text+'%''');
       ZQuery1.Active:=true;

     end;

     if RadioGroup1.ItemIndex=1 then
     begin
       ZQuery1.Active:=false;
       ZQuery1.SQL.Clear;
       ZQuery1.SQL.Append('select * from palithaiNewGen where content LIKE ''%'+Edit1.Text+'%''');
       ZQuery1.Active:=true;

      end;

    end;
end;



procedure TForm1.ZQuery1AfterPost(DataSet: TDataSet);
begin
    ZQuery1.ApplyUpdates;
end;

end.

