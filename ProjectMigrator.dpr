program ProjectMigrator;

uses
  Vcl.Forms,
  ProjectMigrator.Main in 'ProjectMigrator.Main.pas' {ProjectMigratorMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TProjectMigratorMainForm, ProjectMigratorMainForm);
  Application.Run;
end.
