; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define VCLStyle "Luna.vsf"

[Setup]
AllowNoIcons=yes
AppName=VCLDemo Uninstall
AppVersion=1.5
DefaultDirName={autopf}\VCLDemo Uninstall
DefaultGroupName=VCLDemo Uninstall
DisableWelcomePage=no
Compression=lzma2/Ultra64
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename=VCL Demo Uninstall
SetupIconFile=..\images\icon.ico
WizardImageFile=..\images\WizModernImage-IS_Purple.bmp
WizardSmallImageFile=..\images\WizModernSmallImage-IS_Purple.bmp
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

#define VCLStylesSkinPath "{localappdata}\VCLStylesSkin"
[Files]
Source: ..\VclStylesinno.dll; DestDir: {#VCLStylesSkinPath}; Flags: uninsneveruninstall
Source: ..\Styles\{#VCLStyle}; DestDir: {#VCLStylesSkinPath}; Flags: uninsneveruninstall
Source: MyProg.exe; DestDir: "{app}"

[Icons]
Name: "{group}\VCLDemo Uninstall"; Filename: "{app}\MyProg.exe"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\VCLDemo Uninstall"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

[Languages]
;If you want to use this language for your own setup change to:
;"C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Samples\VCLDefault.isl" if installed into default location.
Name: "english"; MessagesFile: "VCLDefault.isl"
                                            
[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall setuponly';
procedure LoadVCLStyle_UnInstall(VClStyleFile: String); external 'LoadVCLStyleW@{#VCLStylesSkinPath}\VclStylesInno.dll stdcall uninstallonly';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall setuponly';
procedure UnLoadVCLStyles_UnInstall; external 'UnLoadVCLStyles@{#VCLStylesSkinPath}\VclStylesInno.dll stdcall uninstallonly';

procedure CreateCancelButton(ParentForm: TSetupForm; CancelButton: TNewButton);
begin
  CancelButton.Top := CancelButton.Top + 3;
end;
procedure InitializeWizard();
begin
  {Custom controls}
  CreateCancelButton(WizardForm, WizardForm.CancelButton);
  {DiskSpaceLabel show or do not show space required,often not correct}
  WizardForm.DiskSpaceLabel.Visible := false;
end;

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

function InitializeUninstall: Boolean;
begin
  Result := True;
  LoadVCLStyle_UnInstall(ExpandConstant('{#VCLStylesSkinPath}\{#VCLStyle}'));
end;

procedure DeinitializeUninstall();
begin
  UnLoadVCLStyles_UnInstall;
end;
