unit about1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lclintf, ExtCtrls,Windows;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private

  public

  end;

var
  AboutForm: TAboutForm;

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

{ TAboutForm }

procedure TAboutForm.Label3Click(Sender: TObject);
begin
  OpenURL('http://www.appsgoods.com');
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var
    AppDir: String;
begin
  AppDir := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
  Memo1.Lines.LoadFromFile(AppDir +'Readme.txt');

  If FileExists(AppDir+'font\THSarabunNew.ttf')
  Then
   If AddFont(PAnsiChar(AppDir+'font\THSarabunPali.ttf'), $10)
   Then
    begin
      AboutForm.Font.Name:= 'TH Sarabun Pali';
      AboutForm.Font.Size:=14;
      Memo1.Font.Name:= 'TH Sarabun Pali';
      Memo1.Font.Size:=14;
    end;

  Image1.Picture.LoadFromFile(AppDir+'img\BuddhaFace180.png');
  Image1.Stretch:=True;

  Image2.Picture.LoadFromFile(AppDir+'img\appsgoods_1inch_180pix.png');
  Image2.Stretch:=True;

end;

procedure TAboutForm.Image2Click(Sender: TObject);
begin
  OpenURL('http://www.appsgoods.com');
end;

procedure TAboutForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   strAppPath: String;
begin
  strAppPath:= IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
    If FileExists(strAppPath+'font\THSarabunNew.ttf')
  Then
   If RemoveFont(PAnsiChar(strAppPath+'font\THSarabunNew.ttf'), $10)
   Then SendMessage(Handle, WM_FONTCHANGE, 0, 0);
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  OpenURL('http://www.bangkokinnovationzystem.com');
end;

procedure TAboutForm.Label6Click(Sender: TObject);
begin
  OpenURL('http://www.getasoftware.com');
end;

procedure TAboutForm.Label7Click(Sender: TObject);
begin
  OpenURL('http://dharma-of-buddha.blogspot.com');
end;

end.

