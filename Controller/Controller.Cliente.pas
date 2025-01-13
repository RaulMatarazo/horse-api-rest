unit Controller.Cliente;

interface

uses System.SysUtils, Horse;

procedure Registry;

implementation

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Listando clientes');
end;

procedure CadastrarClientes(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Cadastrando clientes');
end;

procedure DeletarClientes(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Excluindo clientes');
end;

procedure Registry;
begin
  THorse.Get('/clientes', ListarClientes);
  THorse.Post('/clientes', CadastrarClientes);
  THorse.Delete('/clientes', DeletarClientes);
end;

end.
