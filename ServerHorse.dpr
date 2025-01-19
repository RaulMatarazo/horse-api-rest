program ServerHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Controller.Cliente in 'Controller\Controller.Cliente.pas',
  Model.connection in 'Model\Model.connection.pas',
  Model.Cliente in 'Model\Model.Cliente.pas';

begin
  THorse.Use(Jhonson());
  Controller.Cliente.Registry;
  THorse.Listen(9000);
end.
