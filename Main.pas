unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxTextEdit, cxContainer, cxEdit, cxImage, cxDBEdit,
  cxClasses, cxStyles, cxGridTableView, ExtCtrls, StdCtrls, WallPaper,
  cxControls, dxStatusBar, AdvToolBtn, DB, ADODB, cxCurrencyEdit, IniFiles;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    KapatButton: TAdvToolButton;
    GuncelleButton: TButton;
    Panel4: TPanel;
    RaporGosterButton: TAdvToolButton;
    SayfayiKucultButton: TAdvToolButton;
    StatusBar: TdxStatusBar;
    WallPaperClient: TWallPaper;
    PanelClient: TPanel;
    PanelWaybill: TPanel;
    Panel5: TPanel;
    GridPanel: TPanel;
    ServerMsgLabel: TWallPaper;
    HeaderLabel: TLabel;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle12: TcxStyle;
    cxStyle13: TcxStyle;
    cxStyle14: TcxStyle;
    cxStyle15: TcxStyle;
    GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
    Panel7: TPanel;
    BarkoEdit: TcxTextEdit;
    ADOConnection1: TADOConnection;
    UrunBul: TADOQuery;
    Label1: TLabel;
    UrunTanimiEdit: TEdit;
    UrunBulSiraNo: TAutoIncField;
    UrunBulUrunTanimi: TStringField;
    UrunBulUrunKodu: TStringField;
    UrunBulSonBarkodNo: TStringField;
    UrunBulKalori: TStringField;
    KCalEdi: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    AdvToolButton1: TAdvToolButton;
    BoyEdit: TcxCurrencyEdit;
    KiloEdit: TcxCurrencyEdit;
    UyariPanel: TPanel;
    TuketimPanel: TPanel;
    Panel3: TPanel;
    procedure BarkoEditKeyPress(Sender: TObject; var Key: Char);
    procedure KapatButtonClick(Sender: TObject);
    procedure AdvToolButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ComputerName, Database, KullaniciKodu, KullaniciSifresi : string;

implementation

{$R *.dfm}

procedure TMainForm.BarkoEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin

    UrunTanimiEdit.Text := '';
    KCalEdi.Text := '';
    BoyEdit.Value := 0;
    KiloEdit.Value := 0;
    TuketimPanel.Caption := '';
    UyariPanel.Caption := '';


    if UrunBul.Active then UrunBul.Close;
    UrunBul.Parameters.ParamByName('Kodu').Value := Copy(Trim(BarkoEdit.Text),1, 7);
    UrunBul.Open;

    if UrunBul.RecordCount = 0 then begin
      ShowMessage('BU ÜRÜN SİSTEMDE KAYITLI DEĞİLDİR');
      UrunTanimiEdit.Text := '';
      KCalEdi.Text := '';
      BoyEdit.Value := 0;
      KiloEdit.Value := 0;
      Exit;
    end;

    UrunTanimiEdit.Text := UrunBulUrunTanimi.AsString;
    KCalEdi.Text := UrunBulKalori.Value;
    UrunTanimiEdit.SelectAll;


  end;



end;

procedure TMainForm.KapatButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.AdvToolButton1Click(Sender: TObject);
var
  Hesap : double;
  Boy : double;
  Tanimi : string;

begin

    if KiloEdit.Value = 0 then begin
      ShowMessage('Kilo Girmeden Hesaplama Yapamazsınız');
      Exit;
    end;

    if BoyEdit.Value = 0 then begin
      ShowMessage('Boy Girmeden Hesaplama Yapamazsınız');
      Exit;
    end;

    Boy := (BoyEdit.Value/100);

    Hesap :=  KiloEdit.Value /(Boy * Boy);


    if (Hesap >= 0) and (Hesap <= 18.4) then begin
      UyariPanel.Caption := 'ZAYIF = ' + FloatToStr(Hesap);
      Tanimi := 'ZAYIF';
    end;

    if (Hesap >= 18.5) and (Hesap <= 24.9) then begin
      UyariPanel.Caption := 'NORMAL = ' + FloatToStr(Hesap);
      Tanimi := 'NORMAL';
    end;


    if (Hesap >= 25) and (Hesap <= 29.9) then begin
      UyariPanel.Caption := 'KİLOLU = ' + FloatToStr(Hesap);
      Tanimi := 'KİLOLU';
    end;


    if Hesap >= 30 then begin
      UyariPanel.Caption := 'OBEZ = ' + FloatToStr(Hesap);
      Tanimi := 'OBEZ';
    end;

    if (Tanimi = 'NORMAL') then begin
      if strToInt(KCalEdi.Text) > 350 then begin
        TuketimPanel.Caption := 'TÜKETİLMESİ SAKINCALI ÜRÜN';
      end else begin
        TuketimPanel.Caption := 'TÜKETİLMESİNDE SAKINCA YOKTUR';
      end;
    end;

    if (Tanimi = 'ZAYIF') then begin
        TuketimPanel.Caption := 'TÜKETİLMESİNDE SAKINCA YOKTUR';
    end;



    if (Tanimi = 'OBEZ') then begin
      if strToInt(KCalEdi.Text) > 150 then begin
        TuketimPanel.Caption := 'TÜKETİLMESİ SAKINCALI ÜRÜN';
      end else begin
        TuketimPanel.Caption := 'TÜKETİLMESİNDE SAKINCA YOKTUR';
      end;
    end;

    if (Tanimi = 'KİLOLU') then begin
      if strToInt(KCalEdi.Text) > 250 then begin
        TuketimPanel.Caption := 'TÜKETİLMESİ SAKINCALI ÜRÜN';
      end else begin
        TuketimPanel.Caption := 'TÜKETİLMESİNDE SAKINCA YOKTUR';
      end;
    end;







  {

  0 - 18.4 // Zayıf
  18.5 - 24.9 // Normal
  25 - 29.9 // fazla kilolu
  30 - 34.9 // Obez

   }

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  BarkoEdit.SetFocus;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  str, str1, str2, str3 : string;
  IniFile : TIniFile;
begin

    IniFile := TIniFile.Create('c:\ServerAdi.ini');
    ComputerName := IniFile.ReadString('ServerAdi','BilgisayarAdi','1');
    Database := IniFile.ReadString('ServerAdi','Database','2');
    KullaniciKodu := IniFile.ReadString('ServerAdi','KullaniciKodu','3');
    KullaniciSifresi  := IniFile.ReadString('ServerAdi','KullaniciSifresi','4');
    if ComputerName = '7' then ComputerName := '.';



   Str := 'Provider=SQLOLEDB.1;Password='+KullaniciSifresi+';Persist Security Info=True;User ID='+KullaniciKodu+';Initial Catalog='+Database+';Data Source=';
   str1 := ';Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=';
   str2 := ';Use Encryption for Data=False;Tag with column collation when possible=False';
   ADOConnection1.ConnectionString ;=str + ComputerName + str1 + ComputerName + str2 ;
   
   end;
   
   end;
