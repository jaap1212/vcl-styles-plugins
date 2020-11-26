; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define VCLStyle "ModernRed.vsf"
;These are MyWelcome page Settings Select in [Code] URL or MsgBox
#Define BitmapURL "https://theroadtodelphi.files.wordpress.com/2014/12/output_qkrcra.gif?w=820"
#Define MsgBox "You clicked the image!"
#Define Bitmap "MyWelcome.bmp"
#Define Welcome "Welcome to this SetUp"
#Define WelcomeMessage "This will install VCL MyWelcome click Continue."

[Setup]
AllowNoIcons=yes
AppName=VCL MyWelcome
AppVersion=1.5
DefaultDirName={autopf}\VCL MyWelcome
DefaultGroupName=VCL MyWelcome
DisableWelcomePage=yes
Compression=lzma2/Ultra64
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename=VCL MyWelcome
SetupIconFile=..\images\icon.ico
WizardImageFile=..\images\WizModernImage-IS_Red.bmp
WizardSmallImageFile=..\images\WizModernSmallImage-IS_Red.bmp
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: ..\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
Source: ..\Images\{#Bitmap}; DestDir: "{tmp}"; Flags: dontcopy
Source: MyProg.exe; DestDir: "{app}"

[Icons]
Name: "{group}\VCL MyWelcome"; Filename: "{app}\MyProg.exe"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\VCL MyWelcome"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

[Languages]
;If you want to use this language for your own setup change to:
;"C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Samples\VCLDefault.isl" if installed into default location.
Name: "english"; MessagesFile: "VCLDefault.isl"

[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
	Result := True;
end;

procedure CreateCancelButton(ParentForm: TSetupForm; CancelButton: TNewButton);
begin
  CancelButton.Top := CancelButton.Top + 3;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;

{These are MyWelcome page Settings Either MsgBox or URL}
{procedure BitmapImageOnClick(Sender: TObject);
var
  ErrorCode : Integer;
begin
  ShellExec('open', '{#BitmapURL}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;}

procedure BitmapImageOnClick(Sender: TObject);
begin
  MsgBox('{#MsgBox}', mbInformation, mb_Ok);
end;

procedure CreateWizardPages;
var
  Page: TWizardPage;
  BitmapImage: TBitmapImage;
  BitmapFileName: String;
begin
  BitmapFileName := ExpandConstant('{tmp}\{#Bitmap}');
  ExtractTemporaryFile(ExtractFileName(BitmapFileName));

  {TBitmapImage}
  {wpInstalling=After installpage, wpLicense=After LicensePage, wpWelcome=After welcomepage}
  Page := CreateCustomPage(wpWelcome, '{#Welcome}', 
  '{#WelcomeMessage}');

  BitmapImage := TBitmapImage.Create(Page);
  BitmapImage.AutoSize := True;
  BitmapImage.Left := 0;
  BitmapImage.Top  := 0;
  BitmapImage.Bitmap.LoadFromFile(BitmapFileName);
  BitmapImage.Cursor := crHand;
  BitmapImage.OnClick := @BitmapImageOnClick;
  BitmapImage.Parent := Page.Surface;
  BitmapImage.Align:=alCLient;
  BitmapImage.Stretch:=True;
end;

procedure InitializeWizard();
begin
  {MyWelcome page}
  CreateWizardPages
  {Custom controls}
  CreateCancelButton(WizardForm, WizardForm.CancelButton);
  {DiskSpaceLabel show or do not show space required,often not correct}
  WizardForm.DiskSpaceLabel.Visible := false;
end;
