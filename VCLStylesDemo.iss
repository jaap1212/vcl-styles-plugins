; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define VCLStyle "khaki.vsf"

[Setup]
AllowNoIcons=yes
AppName=VCL Demo
AppVersion=1.5
DefaultDirName={autopf}\VCL Demo
DefaultGroupName=VCL Demo
DisableWelcomePage=no
Compression=lzma2/Ultra64
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename=VCL Demo
SetupIconFile=..\images\icon.ico
WizardImageFile=..\images\WizModernImage-IS_Orange.bmp
WizardSmallImageFile=..\images\WizModernSmallImage-IS_Orange.bmp
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: ..\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
Source: MyProg.exe; DestDir: "{app}"

[Icons]
Name: "{group}\VCL Demo"; Filename: "{app}\MyProg.exe"
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\VCL Demo"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

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
procedure InitializeWizard();
begin
  {Custom controls}
  CreateCancelButton(WizardForm, WizardForm.CancelButton);
  {DiskSpaceLabel show or do not show space required,often not correct}
  WizardForm.DiskSpaceLabel.Visible := false;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;
