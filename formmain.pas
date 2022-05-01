unit formmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    CopySecretBtn: TButton;
    CopyUriBtn: TButton;
    IssuerEdt: TEdit;
    AccountNameEdt: TEdit;
    GenerateBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SecretEdt: TEdit;
    UriEdt: TEdit;
    procedure CopySecretBtnClick(Sender: TObject);
    procedure CopyUriBtnClick(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses SynCrypto, SZCodeBaseX, Clipbrd;

{ TMainForm }

function URLEncode(Value: UTF8String): AnsiString;
var
  x: Integer;
begin
  Result := '';
  for x := 1 to Length(Value) do
  case Value[x] of
    'A'..'Z', 'a'..'z', '0'..'9', '-', '.', '_', '~': Result := Result + Value[x];
    else Result := Result + '%' + IntToHex(Ord(Value[x]), 2);
  end;
end;

procedure RaiseError(ErrorMessage: String);
begin
  MessageDlg(ErrorMessage, mtError, [mbOk], 0);
  abort;
end;

procedure TMainForm.GenerateBtnClick(Sender: TObject);
var
  PRNG: TAESPRNG;
  y: AnsiString;
  x: RawByteString;
  URI: String;
  Issuer, AccountName: String;
begin
  Issuer := Trim(IssuerEdt.Text);
  AccountName := Trim(AccountNameEdt.Text);

  if Issuer = '' then
    RaiseError('Please enter an issuer name.');

  if AccountName = '' then
    RaiseError('Please enter an account name.');

  PRNG := TAESPRNG.Create();
  try
    x := PRNG.Fill(10);
  finally
    FreeAndNil(PRNG);
  end;
  SecretEdt.Text := SZEncodeBase32(x);

  URI := 'otpauth://totp/'
       + URLEncode(Issuer) + ':' + URLEncode(AccountName)
       + '?secret=' + SecretEdt.Text
       + '&issuer=' + URLEncode(Issuer)
       + '&algorithm=SHA1'
       + '&digits=6'
       + '&period=30';

  UriEdt.Text := URI;
end;

procedure TMainForm.CopySecretBtnClick(Sender: TObject);
begin
  Clipboard.AsText := SecretEdt.Text;
end;

procedure TMainForm.CopyUriBtnClick(Sender: TObject);
begin
  Clipboard.AsText := UriEdt.Text;
end;


end.

