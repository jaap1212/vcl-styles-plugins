; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define VCLStyle "ModernDarkBlue.vsf"

[Setup]
AllowNoIcons=yes
AppName=VCL Aboutbutton_URL
AppVersion=1.5
DefaultDirName={autopf}\VCL Aboutbutton_URL
DefaultGroupName=VCL Aboutbutton_URL
DisableWelcomePage=no
Compression=lzma2/Ultra64
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename=VCL Aboutbutton_URL
SetupIconFile=..\images\icon.ico
WizardImageFile=..\images\WizModernImage-IS.bmp
WizardSmallImageFile=..\images\WizModernSmallImage-IS.bmp
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: ..\Images\MyWelcome.bmp; Flags: dontcopy
Source: ..\\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
Source: MyProg.exe; DestDir: "{app}"

[Icons]
Name: "{group}\Testing Bitmap"; Filename: "{app}\MyProg.exe"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Testing Bitmap"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

[Languages]
;If you want to use this language for your own setup change to:
;"C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Samples\VCLDefault.isl" if installed into default location.
Name: "english"; MessagesFile: "VCLDefault.isl"

[CustomMessages]
english.About=About
english.AboutMsgBox=Put your message here.
;Enter URLLabel website and discription
english.Website=www.innosetup.com
english.WebsiteCaption=InnoSetup on the web

[Code]
//Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
	Result := True;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;

procedure AboutButtonOnClick(Sender: TObject);
begin
  MsgBox(ExpandConstant('{cm:AboutMsgBox}'), mbInformation, mb_Ok);
end;

procedure URLLabelOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', ExpandConstant('{cm:Website}'), '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
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
  AboutButton.Width := CancelButton.Width;
  AboutButton.Height := CancelButton.Height;
  AboutButton.Anchors := [akLeft, akBottom];
  AboutButton.Caption := ExpandConstant('{cm:About}');
  AboutButton.OnClick := @AboutButtonOnClick;
  AboutButton.Parent := ParentForm;

  URLLabel := TNewStaticText.Create(ParentForm);
  URLLabel.Caption := ExpandConstant('{cm:WebsiteCaption}');
  URLLabel.Cursor := crHand;
  URLLabel.OnClick := @URLLabelOnClick;
  URLLabel.Parent := ParentForm;
  {Alter Font *after* setting Parent so the correct defaults are inherited first}
  URLLabel.Font.Style := URLLabel.Font.Style + [fsUnderline];
  URLLabel.Font.Color := clHotLight
  URLLabel.Top := AboutButton.Top + AboutButton.Height - URLLabel.Height - 2;
  URLLabel.Left := AboutButton.Left + AboutButton.Width + ScaleX(20);
  URLLabel.Anchors := [akLeft, akBottom];
end;

procedure InitializeWizard();
begin
  {Custom controls}
  CreateAboutButtonAndURLLabel(WizardForm, WizardForm.CancelButton);
end;

