; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define AppName "VCL CodeClasses Setup"
#define AppVerName "VCL CodeClasses Setup 1.5"
#define AppVersion "1.5"
#define AppCopyright "The Road To Delphi"
#define AppURL "https://theroadtodelphi.com/2013/12/11/vcl-styles-for-inno-setup/"
#define DefaultDirName "VCL CodeClasses Setup"
#define LicenseFile "License.txt"
#define SetupIconFile "..\images\icon.ico"
#define VCLStyle "Glossy2.vsf"
#define VersionInfoDescription "VCL Styles Setup"
#define WizardImageFile "..\Images\WizardImage.bmp"
#define WizardSmallImageFile "..\Images\HeaderStretched.bmp"
#define WizardStyle" modern"
;These are GitHub page Settings
#Define DisableWelcomePage "no"
#Define Bitmap "background.bmp"
#Define BitmapAppURL "https://github.com/RRUZ/vcl-styles-plugins"
#Define WelcomePage "Contributions"
#Define WelcomeMessage "If you want to show your appreciation for this project,go to the github page,login with your github account and star the project."

[Setup]
AllowNoIcons=yes
AllowCancelDuringInstall=yes
AppName={#AppName}
AppVerName={#AppVerName}
AppVersion={#AppVersion}
AppCopyright={#AppCopyright}
AppPublisher={#AppCopyright}
AppPublisherURL={#AppURL}
AppSupportURL={#BitmapAppURL}
DefaultDirName={pf}\{#DefaultDirName}
DefaultGroupName={#AppName}
DisableWelcomePage={#DisableWelcomePage}
Compression=lzma2/Ultra64
SolidCompression=yes
LicenseFile={#LicenseFile}
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename={#AppName}
SetupIconFile={#SetupIconFile}
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppCopyright}
VersionInfoDescription={#VersionInfoDescription}
VersionInfoTextVersion={#AppVersion}
WizardStyle={#WizardStyle}
WizardImageFile={#WizardImageFile}
WizardSmallImageFile={#WizardSmallImageFile}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: ..\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
Source: ..\Images\{#Bitmap}; DestDir: {tmp}; Flags: deleteafterinstall dontcopy
Source: MyProg.exe; DestDir: "{app}"

[Icons]
Name: "{group}\VCLCodeClasses Setup"; Filename: "{app}\MyProg.exe"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\VCLCodeClasses Setup"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

[Languages]
;If you want to use this language for your own setup change to:
;"C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Samples\VCLDefault.isl" if installed into default location.
Name: "english"; MessagesFile: "VCLDefault.isl"

[Messages]
BeveledLabel=VclStyles

[CustomMessages]
Website=VclStyles on the web
About=About
Aboutmsgbox=As part of the VCL Styles Utils project, Rodrigo made a plugin (dll) to skin the installers created by Inno setup. The current size of the plugin is about 2.9 mb, but when is included (and compressed) in the script only add ~813 Kb to the final installer.

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

procedure AboutButtonOnClick(Sender: TObject);
begin
  MsgBox(ExpandConstant('{cm:Aboutmsgbox}'), mbInformation, MB_OK);
end;

procedure URLLabelOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', '{#AppURL}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure BitmapImageOnClick(Sender: TObject);
var
  ErrorCode : Integer;
begin
  ShellExec('open', '{#BitmapAppURL}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure CreateAboutButtonAndURLLabel(ParentForm: TSetupForm; CancelButton: TNewButton);
var
  AboutButton: TNewButton;
  URLLabel: TNewStaticText;
begin
  CancelButton.Top := CancelButton.Top + 3;
  AboutButton := TNewButton.Create(ParentForm);
  AboutButton.Left := ParentForm.ClientWidth - CancelButton.Left - CancelButton.Width;
  AboutButton.Top := CancelButton.Top;
  AboutButton.Width := CancelButton.Width + 15;
  AboutButton.Height := CancelButton.Height;
  AboutButton.Anchors := [akLeft, akBottom];
  AboutButton.Caption := ExpandConstant('{cm:About}');
  AboutButton.OnClick := @AboutButtonOnClick;
  AboutButton.Parent := ParentForm;

  URLLabel := TNewStaticText.Create(ParentForm);
  URLLabel.Caption :=ExpandConstant('{cm:Website}');
  URLLabel.Cursor := crHand;
  URLLabel.OnClick := @URLLabelOnClick;
  URLLabel.Parent := ParentForm;
  URLLabel.Font.Style := URLLabel.Font.Style + [fsUnderline];
  URLLabel.Font.Color := clBlack
  URLLabel.Top := AboutButton.Top + AboutButton.Height - URLLabel.Height - 4;
  URLLabel.Left := AboutButton.Left + AboutButton.Width + ScaleX(20);
  URLLabel.Anchors := [akLeft, akBottom];

  {DiskSpaceLabel show or do not show space required,often not correct}
  WizardForm.DiskSpaceLabel.Visible := false;
  WizardForm.ComponentsDiskSpaceLabel.Visible := true;
  {pre-select "accept", to enable "next" button for license page}
  WizardForm.LicenseAcceptedRadio.Checked := True;
  WizardForm.LicenseMemo.Height :=
  WizardForm.LicenseNotAcceptedRadio.Top + WizardForm.LicenseNotAcceptedRadio.Height -
  {Hide radio buttons ScaleY to (0) show only Not accepted ScaleY (20) otherwise ScaleY (40)}
  WizardForm.LicenseMemo.Top - ScaleY(0);

  With WizardForm.WizardSmallBitmapImage do
  SetBounds(Parent.Left, Parent.Top, Parent.Width, Parent.Height);
  WizardForm.WizardSmallBitmapImage.Anchors := [akLeft, akTop, akRight, akBottom];
  WizardForm.WizardSmallBitmapImage.Stretch := True;
  WizardForm.PageDescriptionLabel.Visible := False;
  WizardForm.PageNameLabel.Visible := False;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpLicense then
  begin
    WizardForm.NextButton.Caption := '&I Accept >';
  end;
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
  Page := CreateCustomPage(wpInstalling, '{#WelcomePage}',
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
  {Custom controls}
  CreateAboutButtonAndURLLabel(WizardForm, WizardForm.CancelButton);
  CreateWizardPages;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;

