; Script made with Inno Setup v6.05
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; These are example scripts for VCLStyles.If you want to use a script for your own setup,
; you have to save the scriptfile to your own folder,
; and change '..\' to 'C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\' if installed into default location.

#define VCLStyle "IcebergClassico.vsf"

[Setup]
AllowNoIcons=yes
AppName=VCL Components
AppVersion=1.5
Compression=lzma2/Ultra64
SolidCompression=yes
DefaultDirName={pf}\VCL Components
DefaultGroupName=VCL Components
DisableWelcomePage=no
OutputDir=userdocs:Inno Setup Examples Output
OutputBaseFilename=VCL Components
SetupIconFile=..\images\icon.ico
WizardImageFile=..\images\WizModernImage-IS.bmp
WizardSmallImageFile=..\images\WizModernSmallImage-IS.bmp
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Types]
Name: full; Description: Full installation
Name: compact; Description: Compact installation
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
Name: program; Description: Program Files; Types: full compact custom; Flags: fixed
Name: help; Description: Help File; Types: full
Name: readme; Description: Readme File; Types: full
Name: readme\en; Description: English; Flags: exclusive
Name: readme\de; Description: German; Flags: exclusive

[Files]
Source: ..\VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: ..\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
Source: MyProg.exe; DestDir: {app}; Components: program
Source: MyProg.chm; DestDir: {app}; Components: help
Source: Readme.txt; DestDir: {app}; Components: readme\en; Flags: isreadme
Source: Readme-German.txt; DestName: Liesmich.txt; DestDir: {app}; Components: readme\de; Flags: isreadme

[Icons]
Name: {group}\VCL Components; Filename: {app}\MyProg.exe
Name: "{group}\{cm:UninstallProgram,}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\VCL Components"; Filename: "{app}\MyProg.exe"; Tasks: desktopicon

[Languages]
;If you want to use this language for your own setup change to:
;"C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Samples\VCLDefault.isl" if installed into default location.
Name: "english"; MessagesFile: "VCLDefault.isl"

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

procedure CreateCancelButton(ParentForm: TSetupForm; CancelButton: TNewButton);
begin
  CancelButton.Top := CancelButton.Top + 3;
end;
procedure InitializeWizard();
begin
  {Custom control}
  CreateCancelButton(WizardForm, WizardForm.CancelButton);
  {DiskSpaceLabel show or do not show space required,often not correct}
  WizardForm.DiskSpaceLabel.Visible := false;
  WizardForm.ComponentsDiskSpaceLabel.Visible := false;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;
