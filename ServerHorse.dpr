program ServerHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Controller.Cliente in 'Controller\Controller.Cliente.pas';

begin
  Controller.Cliente.Registry;
  THorse.Listen(9000);
end.
