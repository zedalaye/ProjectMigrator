unit ProjectMigrator.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ActiveX,
  System.SysUtils, System.Types, System.UITypes, System.Variants,
  System.Classes, System.ImageList, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.Menus, Vcl.Buttons, Vcl.ImgList, Vcl.ComCtrls,
  Vcl.Imaging.pngimage,
  JvExMask, JvToolEdit,
  VirtualTrees;

type
  TFileState = (fsUnmapped, fsMoved, fsDeleted, fsMarked);

  PFileNode = ^TFileNode;

  TFileNode = record
    Name, FullPath: string;
    Directory: Boolean;
    State: TFileState;
    OldName, OldPath: string;
  end;

type
  TProjectMigratorMainForm = class(TForm)
    pSource: TPanel;
    pSourceToolbar: TPanel;
    vstSource: TVirtualStringTree;
    pDestination: TPanel;
    pDestinationToolbar: TPanel;
    vstDestination: TVirtualStringTree;
    lbSource: TLabel;
    deSource: TJvDirectoryEdit;
    lbDestination: TLabel;
    deDestination: TJvDirectoryEdit;
    pScript: TPanel;
    mScript: TMemo;
    pmActions: TPopupMenu;
    miDelete: TMenuItem;
    ilIcons: TImageList;
    miUnmark: TMenuItem;
    N1: TMenuItem;
    miMarkMoved: TMenuItem;
    miMarkDeleted: TMenuItem;
    pScriptToolbar: TPanel;
    btnSourceRefresh: TSpeedButton;
    btnDestinationRefresh: TSpeedButton;
    btnCheck: TSpeedButton;
    lbScript: TLabel;
    pbCheckProgress: TProgressBar;
    btnSave: TSpeedButton;
    btnCreateTree: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure TreeInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSourceDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSourceDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure vstDestinationDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure vstDestinationDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure TreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure miDeleteClick(Sender: TObject);
    procedure TreeSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TreeLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure btnSourceRefreshClick(Sender: TObject);
    procedure btnDestinationRefreshClick(Sender: TObject);
    procedure miUnmarkClick(Sender: TObject);
    procedure miMarkMovedClick(Sender: TObject);
    procedure miMarkDeletedClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCreateTreeClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure LoadFiles(const Path: string; Tree: TVirtualStringTree);
    function GetRelativePath(const FullPath, RootPath: string): string;
    function GetLastPathElement(const Path: string): string;
    function LinuxPath(const Path: string): string;
    function WindowsPath(const Path: string): string;
    procedure AddScript(const Fmt: string; const Args: array of const);
    procedure ProcessMove(SourceNode, DestinationNode: PVirtualNode);
    procedure ProcessDelete(Node: PFileNode);
    procedure ResetMarks(Tree: TVirtualStringTree);
    function Q(const S: string): string;
    procedure CheckScript;
    procedure CheckScriptLine(const L: string; LineIndex: Integer;
      Errors: TStrings);
    function CheckRM(const Target: string; var Error: string): Boolean;
    function CheckRMR(const Target: string; var Error: string): Boolean;
    function CheckMV(const Source, Destination: string;
      var Error: string): Boolean;
    function AppStateFileName: string;
    function AppScriptFileName: string;
    procedure DoSaveCurrentState;
    procedure DoLoadLastState;
  public
    { Déclarations publiques }
  end;

var
  ProjectMigratorMainForm: TProjectMigratorMainForm;

implementation

uses
  System.IOUtils;

{$R *.dfm}

type
  TStringInStreamHelper = class helper for TStream
  public
    procedure WriteString(const S: string);
    function ReadString: string;
  end;

const
  APP_NAME = 'ProjectMigrator';

  {
    Returns the path to the current user's AppData folder on Windows and to the
    current user's home directory on Mac OS X.
    Example:  c:\Documents and Settings\Bere\Application Data\AppName\
  }

function GetAppDataFolder: string;
begin
  Result := TPath.Combine(System.SysUtils.GetHomePath, APP_NAME);
end;

function TProjectMigratorMainForm.AppScriptFileName: string;
begin
  Result := TPath.Combine(GetAppDataFolder, 'script.sh')
end;

function TProjectMigratorMainForm.AppStateFileName: string;
begin
  Result := TPath.Combine(GetAppDataFolder, 'state.bin')
end;

procedure TProjectMigratorMainForm.FormCreate(Sender: TObject);
begin
  ilIcons.GetBitmap(0, btnSourceRefresh.Glyph);
  ilIcons.GetBitmap(0, btnDestinationRefresh.Glyph);
  ilIcons.GetBitmap(1, btnCheck.Glyph);
  ilIcons.GetBitmap(2, btnSave.Glyph);
  ilIcons.GetBitmap(3, btnCreateTree.Glyph);

  vstSource.NodeDataSize := SizeOf(TFileNode);
  vstDestination.NodeDataSize := SizeOf(TFileNode);

  mScript.Clear;

  if FileExists(AppStateFileName) then
    DoLoadLastState;
end;

procedure TProjectMigratorMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if MessageDlg('Save actual state ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
    DoSaveCurrentState;
end;

function TProjectMigratorMainForm.GetLastPathElement
  (const Path: string): string;
var
  P: PChar;
begin
  P := PChar(Path);
  P := StrRScan(P, '\');
  if P = nil then
    Result := Path
  else
  begin
    Inc(P);
    Result := P;
  end;
end;

function TProjectMigratorMainForm.GetRelativePath(const FullPath,
  RootPath: string): string;
begin
  Result := StringReplace(FullPath,
    IncludeTrailingPathDelimiter(RootPath), '', []);
end;

function TProjectMigratorMainForm.LinuxPath(const Path: string): string;
begin
  Result := StringReplace(Path, '\', '/', [rfReplaceAll]);
end;

procedure TProjectMigratorMainForm.LoadFiles(const Path: string;
  Tree: TVirtualStringTree);

  procedure WalkFiles(const Path: string; Node: PVirtualNode);
  var
    R: TSearchRec;
    N: PVirtualNode;
    F: PFileNode;
  begin
    if FindFirst(Path + '\*', faAnyFile, R) = 0 then
      try
        repeat
          if (R.Name = '.') or (R.Name = '..') then
            Continue;

          if (R.Attr and faDirectory <> 0) then
          begin
            if (R.Name <> '.git') and (R.Name <> '__history') and
              (R.Name <> '__recovery') then
            begin
              N := Tree.AddChild(Node, nil);

              F := Tree.GetNodeData(N);
              F^.Directory := True;
              F^.Name := R.Name;
              F^.FullPath := Path + '\' + R.Name;

              WalkFiles(Path + '\' + R.Name, N);
            end;
          end
          else
          begin
            N := Tree.AddChild(Node, nil);

            F := Tree.GetNodeData(N);
            F^.Directory := False;
            F^.Name := R.Name;
            F^.FullPath := Path + '\' + R.Name;
          end;
        until FindNext(R) <> 0;
      finally
        FindClose(R);
      end;
  end;

begin
  WalkFiles(Path, nil);
end;

procedure TProjectMigratorMainForm.ProcessDelete(Node: PFileNode);
var
  S: string;
begin
  if Node <> nil then
  begin
    S := GetRelativePath(Node^.FullPath, deSource.Directory);
    if Node^.Directory then
      AddScript('git rm -r %s', [Q(S)]) // recursive
    else
      AddScript('git rm %s', [Q(S)]);
    Node^.State := fsDeleted;
  end;
end;

procedure TProjectMigratorMainForm.ProcessMove(SourceNode, DestinationNode
  : PVirtualNode);

  procedure FakeMv(const Source, Destination: string);
  begin
    AddScript('# git mv %s %s', [Q(Source), Q(Destination)]);
  end;

  procedure Mv(const Source, Destination: string);
  begin
    AddScript('git mv %s %s', [Q(Source), Q(Destination)]);
  end;

var
  Source, Destination: PFileNode;
  RelSource, RelDest: string;
  Child: PVirtualNode;
  ChildFile: PFileNode;
  ChildDest: string;
  Moved: Boolean;
begin
  Source := vstSource.GetNodeData(SourceNode);
  Destination := vstDestination.GetNodeData(DestinationNode);

  if (Source = nil) or (Destination = nil) then
    Exit;

  RelSource := GetRelativePath(Source^.FullPath, deSource.Directory);
  RelDest := GetRelativePath(Destination^.FullPath, deDestination.Directory);

  { Both directories }
  if Source^.Directory and Destination^.Directory then
  begin
    if RelSource = RelDest then
      FakeMv(RelSource, RelDest)
    else if SameText(RelSource, RelDest) then
    begin
      Mv(RelSource, RelDest + '_tmp');
      Mv(RelDest + '_tmp', RelDest);
    end
    else
      Mv(RelSource, RelDest);

    Source^.State := fsMoved;
    Destination^.State := fsMarked;
  end;

  { Both files }
  if (not Source^.Directory) and (not Destination^.Directory) then
  begin
    if RelSource = RelDest then
      FakeMv(RelSource, RelDest)
    else if SameText(RelSource, RelDest) then
    begin
      Mv(RelSource, RelDest + '_tmp');
      Mv(RelDest + '_tmp', RelDest);
    end
    else
      Mv(RelSource, RelDest);

    Source^.State := fsMoved;
    Destination^.State := fsMarked;
  end;

  { Source is a file, Destination is a directory }
  if (not Source^.Directory) and Destination^.Directory then
  begin
    Moved := False;
    Child := vstDestination.GetFirstChild(DestinationNode);
    while Child <> nil do
    begin
      ChildFile := vstDestination.GetNodeData(Child);
      if Source^.Name = ChildFile^.Name then
      begin
        ChildDest := GetRelativePath(ChildFile^.FullPath,
          deDestination.Directory);
        Mv(RelSource, ChildDest);
        Source^.State := fsMoved;
        ChildFile^.State := fsMarked;
        Moved := True;
        Break;
      end;
      Child := vstDestination.GetNextSibling(Child);
    end;

    if not Moved then
    begin
      Mv(RelSource, RelDest + '\' + Source^.Name);

      Source^.State := fsMoved;
      Destination^.State := fsMarked;
    end;
  end;
end;

function TProjectMigratorMainForm.Q(const S: string): string;
var
  QuotedPath: string;
begin
  if Pos(' ', S) > 0 then
    QuotedPath := '''' + S + ''''
  else
    QuotedPath := S;
  Result := LinuxPath(QuotedPath);
end;

procedure TProjectMigratorMainForm.ResetMarks(Tree: TVirtualStringTree);
var
  N: PVirtualNode;
  F: PFileNode;
begin
  Tree.BeginUpdate;
  try
    N := Tree.GetFirst;
    while N <> nil do
    begin
      F := Tree.GetNodeData(N);
      F^.State := fsUnmapped;
      N := Tree.GetNext(N);
    end;
  finally
    Tree.EndUpdate;
  end;
end;

procedure TProjectMigratorMainForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  F: PFileNode;
begin
  F := Sender.GetNodeData(Node);
  Finalize(F^);
end;

procedure TProjectMigratorMainForm.TreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  F: PFileNode;
begin
  if not(vsInitialized in Node^.States) then
  begin
    F := Sender.GetNodeData(Node);
    Initialize(F^);
  end;
end;

procedure TProjectMigratorMainForm.vstDestinationDragDrop
  (Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);
var
  SrcNode, DestNode: PVirtualNode;
begin
  if (Source = vstSource) and (vstSource.SelectedCount > 0) then
  begin
    DestNode := vstDestination.GetNodeAt(Pt);

    SrcNode := vstSource.GetFirstSelected;
    while SrcNode <> nil do
    begin
      ProcessMove(SrcNode, DestNode);

      vstSource.InvalidateNode(SrcNode);
      SrcNode := vstSource.GetNextSelected(SrcNode);
    end;

    vstDestination.InvalidateChildren(DestNode, True);
  end;
end;

procedure TProjectMigratorMainForm.vstDestinationDragOver
  (Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
  if (Source = vstSource) then
    Accept := True;
end;

procedure TProjectMigratorMainForm.vstSourceDragAllowed
  (Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TProjectMigratorMainForm.vstSourceDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := False;
end;

function TProjectMigratorMainForm.WindowsPath(const Path: string): string;
begin
  Result := StringReplace(Path, '/', '\', [rfReplaceAll]);
end;

procedure TProjectMigratorMainForm.TreeLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  F: PFileNode;
  V: Byte;
  Dummy: Integer;
begin
  F := Sender.GetNodeData(Node);

  Stream.Read(V, SizeOf(V));

  F^.Name := Stream.ReadString;
  F^.FullPath := Stream.ReadString;
  Stream.Read(F^.Directory, SizeOf(Boolean));
  if V = 1 then
    Stream.Read(Dummy, SizeOf(Integer));
  Stream.Read(F^.State, SizeOf(TFileState));
end;

procedure TProjectMigratorMainForm.TreeSaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  F: PFileNode;
  V: Byte;
begin
  F := Sender.GetNodeData(Node);

  V := 2;
  Stream.Write(V, SizeOf(Byte));
  Stream.WriteString(F^.Name);
  Stream.WriteString(F^.FullPath);
  Stream.Write(F^.Directory, SizeOf(Boolean));
  Stream.Write(F^.State, SizeOf(TFileState));
end;

procedure TProjectMigratorMainForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  F: PFileNode;
begin
  F := Sender.GetNodeData(Node);
  case F^.State of
    fsUnmapped:
      ;
    fsMoved:
      TargetCanvas.Font.Color := clGreen;
    fsDeleted:
      TargetCanvas.Font.Color := clRed;
    fsMarked:
      TargetCanvas.Font.Color := clDkGray;
  end;
end;

procedure TProjectMigratorMainForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  F: PFileNode;
begin
  F := Sender.GetNodeData(Node);
  CellText := F^.Name;
end;

procedure TProjectMigratorMainForm.AddScript(const Fmt: string;
  const Args: array of const);
begin
  mScript.Lines.Append(Format(Fmt, Args));
end;

procedure TProjectMigratorMainForm.btnCheckClick(Sender: TObject);
begin
  ResetMarks(vstSource);
  ResetMarks(vstDestination);
  Application.ProcessMessages;
  CheckScript;
end;

procedure TProjectMigratorMainForm.btnCreateTreeClick(Sender: TObject);

  procedure ProcessFolder(const Path: string; N: PVirtualNode);
  var
    C: PVirtualNode;
    F: PFileNode;
  begin
    AddScript('mkdir %s', [Q(Path)]);
    C := vstDestination.GetFirstChild(N);
    while C <> nil do
    begin
      F := vstDestination.GetNodeData(C);
      if F^.Directory then
        ProcessFolder(TPath.Combine(Path, F^.Name), C)
      else if F^.Name = '.keep' then
        AddScript('touch %s', [Q(TPath.Combine(Path, '.keep'))]);
      C := vstDestination.GetNextSibling(C);
    end;
  end;

var
  N: PVirtualNode;
  F: PFileNode;
begin
  N := vstDestination.GetFirst;
  while N <> nil do
  begin
    F := vstDestination.GetNodeData(N);
    if F^.Directory then
      ProcessFolder(F^.Name, N);
    N := vstDestination.GetNextSibling(N);
  end;
end;

procedure TProjectMigratorMainForm.btnDestinationRefreshClick(Sender: TObject);
begin
  if vstDestination.RootNodeCount > 0 then
    if MessageDlg('Source trees are not empty.' + #13#10 + 'Continue?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

  vstDestination.BeginUpdate;
  try
    vstDestination.Clear;
    LoadFiles(deDestination.Directory, vstDestination);
  finally
    vstDestination.EndUpdate;
  end;
end;

procedure TProjectMigratorMainForm.btnSaveClick(Sender: TObject);
begin
  DoSaveCurrentState;
end;

procedure TProjectMigratorMainForm.btnSourceRefreshClick(Sender: TObject);
begin
  if vstSource.RootNodeCount > 0 then
    if MessageDlg('Source trees are not empty.' + #13#10 + 'Continue?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

  vstSource.BeginUpdate;
  try
    vstSource.Clear;
    LoadFiles(deSource.Directory, vstSource);
  finally
    vstSource.EndUpdate;
  end;
end;

function TProjectMigratorMainForm.CheckMV(const Source, Destination: string;
  var Error: string): Boolean;
var
  SN, DN: PVirtualNode;
  SF, DF: PFileNode;
  SRelPath, DRelPath: string;
  SFound, DFound: Boolean;
begin
  SFound := False;
  SF := nil;
  SN := vstSource.GetFirst;
  while SN <> nil do
  begin
    SF := vstSource.GetNodeData(SN);
    SRelPath := GetRelativePath(SF^.FullPath, deSource.Directory);
    if (Source = SRelPath) then
    begin
      if SF^.State = fsUnmapped then
      begin
        SF^.State := fsMoved;
        SFound := True;
        Break;
      end
      else
      begin
        Error := 'source has already been moved or deleted';
        Exit(False);
      end;
    end;
    SN := vstSource.GetNext(SN);
  end;

  if (not SFound) or (SF = nil) then
  begin
    Error := 'source target not found';
    Exit(False);
  end;

  if (Pos('_tmp', Source) > 0) or (Pos('_tmp', Destination) > 0) then
  begin
    { a directory is renamed inplace }
    if Pos('_tmp', Destination) > 0 then
    begin
      { 1st pass : save name/path and rename to temp directory }
      SF^.OldName := SF^.Name;
      SF^.OldPath := SF^.FullPath;
      SF^.Name := GetLastPathElement(Destination);
      SF^.FullPath := TPath.Combine(deSource.Directory, Destination);
      { ... but keep "unmapped", so we can pass here twice }
      SF^.State := fsUnmapped;
    end
    else if (SF^.OldName <> '') and (SF^.OldPath <> '') then
    begin
      { 2nd pass : restore name/path }
      SF^.Name := SF^.OldName;
      SF^.FullPath := SF^.OldPath;
    end;
    vstSource.RepaintNode(SN);
    Result := True;
  end
  else
  begin
    DFound := False;
    DF := nil;
    DN := vstDestination.GetFirst;
    while DN <> nil do
    begin
      DF := vstDestination.GetNodeData(DN);
      DRelPath := GetRelativePath(DF^.FullPath, deDestination.Directory);
      if Destination = DRelPath then
      begin
        if DF^.Directory or (DF^.State = fsUnmapped) then
        begin
          DF^.State := fsMarked;
          DFound := True;
          Break;
        end
        else
        begin
          Error := 'another file has been moved here';
          Exit(False);
        end;
      end;
      DN := vstDestination.GetNext(DN);
    end;

    if DFound and (DF <> nil) then
    begin
      vstSource.RepaintNode(SN);
      vstDestination.RepaintNode(DN);
      Result := True;
    end
    else
    begin
      Error := 'destination target not found';
      Result := False;
    end;

  end;

end;

function TProjectMigratorMainForm.CheckRM(const Target: string;
  var Error: string): Boolean;
var
  N: PVirtualNode;
  F: PFileNode;
  RelPath: string;
begin
  N := vstSource.GetFirst;
  while N <> nil do
  begin
    F := vstSource.GetNodeData(N);
    RelPath := GetRelativePath(F^.FullPath, deSource.Directory);
    if (Target = RelPath) then
    begin
      if F^.State = fsUnmapped then
        if F^.Directory = False then
        begin
          F^.State := fsDeleted;
          vstSource.RepaintNode(N);
          Exit(True);
        end
        else
        begin
          Error := 'missing -r, git rm will fail if directory is not empty';
          Exit(False);
        end
      else
      begin
        Error := 'target has already been moved or deleted';
        Exit(False);
      end;
    end;
    N := vstSource.GetNext(N);
  end;

  Error := 'target not found';
  Result := False;
end;

function TProjectMigratorMainForm.CheckRMR(const Target: string;
  var Error: string): Boolean;
var
  N: PVirtualNode;
  F: PFileNode;
  RelPath: string;
begin
  N := vstSource.GetFirst;
  while N <> nil do
  begin
    F := vstSource.GetNodeData(N);
    RelPath := GetRelativePath(F^.FullPath, deSource.Directory);
    if (Target = RelPath) then
    begin
      if F^.Directory then
      begin
        F^.State := fsDeleted;
        vstSource.RepaintNode(N);
        Exit(True);
      end
      else
      begin
        Error := 'superfluous -r, target is a file';
        Exit(False);
      end;
    end;
    N := vstSource.GetNext(N);
  end;

  Error := 'target not found';
  Result := False;
end;

procedure TProjectMigratorMainForm.CheckScript;
var
  I: Integer;
  Errors: TStringList;
begin
  Errors := TStringList.Create;
  try
    pbCheckProgress.Min := 0;
    pbCheckProgress.Max := mScript.Lines.Count - 1;
    pbCheckProgress.Step := 1;
    pbCheckProgress.Position := 0;

    for I := 0 to mScript.Lines.Count - 1 do
    begin
      CheckScriptLine(mScript.Lines[I], I, Errors);
      pbCheckProgress.StepIt;
    end;

    pbCheckProgress.Position := 0;

    if Errors.Count > 0 then
      MessageDlg(Format('Script verification failed. %d errors found.' + #13#10
        + #13#10 + '%s', [Errors.Count, Errors.Text]), mtWarning, [mbOK], 0)
    else
      MessageDlg('Nice job. No errors found.', mtInformation, [mbOK], 0);
  finally
    Errors.Free;
  end;
end;

procedure TProjectMigratorMainForm.CheckScriptLine(const L: string;
  LineIndex: Integer; Errors: TStrings);

  function NextToken(var S: PChar): string;
  var
    P: PChar;
    Sep: Char;
  begin
    P := S;

    while S^ = ' ' do
      Inc(S);

    if CharInSet(P^, ['''', '"']) then
    begin
      Sep := P^;
      Inc(S);
      Inc(P);
    end
    else
      Sep := ' ';

    if P^ = '#' then
      Inc(P)
    else
      while not CharInSet(P^, [Sep, #0]) do
        Inc(P);

    SetString(Result, S, P - S);

    if P^ = Sep then
      Inc(P);

    while P^ = ' ' do
      Inc(P);

    S := P;
  end;

type
  TGitAction = (gitUKN, gitRM, gitRMR, gitMV, gitTOUCH, gitMKDIR);
var
  P: PChar;
  Tok: string;
  Action: TGitAction;
  Src, Dst: string;
  Error: string;
  CheckResult: Boolean;
begin
  if Trim(L) = '' then
    Exit;

  Action := gitUKN;
  Src := '';
  Dst := '';

  P := PChar(L);
  Tok := NextToken(P);
  if Tok = '#' then
  begin
    Tok := NextToken(P);
    if Tok[1] = '!' then { #!/env/bin bash... }
      Exit;
  end;

  if Tok = 'git' then
  begin
    Tok := NextToken(P);
    if Tok = 'rm' then
      Action := gitRM
    else if Tok = 'mv' then
      Action := gitMV
    else
      Assert(False, 'Unknown git action ' + Tok);

    Tok := NextToken(P);
    if (Tok = '-r') then
    begin
      if Action = gitRM then
        Action := gitRMR
      else
        Assert(False, 'Flag -r unexpected here');

      Tok := NextToken(P);
    end;
    Src := Tok;

    if Action = gitMV then
    begin
      Tok := NextToken(P);
      Dst := Tok;
    end;
  end
  else if Tok = 'touch' then
  begin
    Action := gitTOUCH;
    Tok := NextToken(P);
    Src := Tok;
  end
  else if Tok = 'mkdir' then
  begin
    Action := gitMKDIR;
    Tok := NextToken(P);
    Src := Tok;
  end
  else
    Assert(False, 'Unsupported command ' + Tok);

  Error := '';
  case Action of
    gitRM:
      CheckResult := CheckRM(WindowsPath(Src), Error);
    gitRMR:
      CheckResult := CheckRMR(WindowsPath(Src), Error);
    gitMV:
      CheckResult := CheckMV(WindowsPath(Src), WindowsPath(Dst), Error);
  else
    CheckResult := True;
  end;

  if not CheckResult then
    Errors.Append(Format('Line %d: %s', [LineIndex, Error]));
end;

procedure TProjectMigratorMainForm.DoLoadLastState;
var
  F: TFileStream;
begin
  F := TFileStream.Create(AppStateFileName, fmOpenRead);
  try
    deSource.Directory := F.ReadString;
    vstSource.LoadFromStream(F);
    deDestination.Directory := F.ReadString;
    vstDestination.LoadFromStream(F);
  finally
    F.Free;
  end;

  mScript.Lines.LoadFromFile(AppScriptFileName);
end;

procedure TProjectMigratorMainForm.DoSaveCurrentState;
var
  F: TFileStream;
begin
  if not TDirectory.Exists(GetAppDataFolder) then
    TDirectory.CreateDirectory(GetAppDataFolder);

  F := TFileStream.Create(AppStateFileName, fmOpenReadWrite + fmCreate);
  try
    F.WriteString(deSource.Directory);
    vstSource.SaveToStream(F);
    F.WriteString(deDestination.Directory);
    vstDestination.SaveToStream(F);
  finally
    F.Free;
  end;

  mScript.Lines.SaveToFile(AppScriptFileName);
end;

procedure TProjectMigratorMainForm.miDeleteClick(Sender: TObject);
var
  N: PVirtualNode;
  F: PFileNode;
begin
  if vstSource.Focused then
  begin
    N := vstSource.GetFirstSelected;
    while N <> nil do
    begin
      F := vstSource.GetNodeData(N);
      ProcessDelete(F);
      vstSource.InvalidateNode(N);
      N := vstSource.GetNextSelected(N);
    end;
  end;
end;

procedure TProjectMigratorMainForm.miMarkDeletedClick(Sender: TObject);
var
  N: PVirtualNode;
  F: PFileNode;
begin
  if vstSource.Focused then
  begin
    N := vstSource.GetFirstSelected;
    while N <> nil do
    begin
      F := vstSource.GetNodeData(N);
      F^.State := fsDeleted;
      vstSource.InvalidateNode(N);
      N := vstSource.GetNextSelected(N);
    end;
  end;
end;

procedure TProjectMigratorMainForm.miMarkMovedClick(Sender: TObject);
var
  N: PVirtualNode;
  F: PFileNode;
begin
  if vstSource.Focused then
  begin
    N := vstSource.GetFirstSelected;
    while N <> nil do
    begin
      F := vstSource.GetNodeData(N);
      F^.State := fsMoved;
      vstSource.InvalidateNode(N);
      N := vstSource.GetNextSelected(N);
    end;
  end;
end;

procedure TProjectMigratorMainForm.miUnmarkClick(Sender: TObject);
var
  N: PVirtualNode;
  F: PFileNode;
begin
  if vstSource.Focused then
  begin
    N := vstSource.GetFirstSelected;
    while N <> nil do
    begin
      F := vstSource.GetNodeData(N);
      F^.State := fsUnmapped;
      vstSource.InvalidateNode(N);
      N := vstSource.GetNextSelected(N);
    end;
  end;
end;

{ TStringInStreamHelper }

function TStringInStreamHelper.ReadString: string;
var
  N: Integer;
  B: TBytes;
begin
  Self.Read(N, SizeOf(N));
  SetLength(B, N);
  Self.Read(B, N);
  Result := TEncoding.UTF8.GetString(B);
end;

procedure TStringInStreamHelper.WriteString(const S: string);
var
  B: TBytes;
  N: Integer;
begin
  B := TEncoding.UTF8.GetBytes(S);
  N := Length(B);
  Self.Write(N, SizeOf(N));
  Self.Write(B, N);
end;

end.
