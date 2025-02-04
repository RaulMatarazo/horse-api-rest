unit Controller.Cliente;

interface

uses System.SysUtils, Horse, Model.Cliente, FireDAC.Comp.Client, Data.DB,
  DataSet.Serialize, System.JSON;

procedure Registry;

implementation

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse);
var
  cliente: TCliente;
  query: TFDQuery;
  erro: string;
  JSONRetorno: TJSONArray;
begin
  try
    cliente := TCliente.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    query := cliente.ListarCliente('', erro);
    JSONRetorno := query.ToJSONArray();
    Res.Send<TJSONArray>(JSONRetorno).Status(200);
  finally
    query.Free;
    cliente.Free;
  end;
end;

procedure ListarClienteId(Req: THorseRequest; Res: THorseResponse);
var
  cliente: TCliente;
  query: TFDQuery;
  erro: string;
  JSONRetorno: TJSONObject;
begin
  try
    cliente := TCliente.Create;
    cliente.id_cliente := Req.Params['id'].ToInteger();
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    query := cliente.ListarCliente('', erro);
    if query.RecordCount > 0 then
    begin
      JSONRetorno := query.ToJSONObject();
      Res.Send<TJSONObject>(JSONRetorno).Status(200);
    end
    else
      Res.Send('Cliente n�o encontrado').Status(404);

  finally
    query.Free;
    cliente.Free;
  end;
end;

procedure CadastrarClientes(Req: THorseRequest; Res: THorseResponse);
var
  cliente: TCliente;
  objCliente: TJSONObject;
  erro: string;
  body: TJSONValue;
begin
  try
    cliente := TCliente.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;
  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;
      cliente.nome := body.GetValue<string>('nome', '');
      cliente.email := body.GetValue<string>('email', '');
      cliente.telefone := body.GetValue<string>('telefone', '');
      cliente.Inserir(erro);
      body.Free;
      if erro <> '' then
        raise Exception.Create(erro);
    except on ex:exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;
    objCliente := TJSONObject.Create;
    objCliente.AddPair('id_cliente', cliente.id_cliente.ToString);
    Res.Send('Cliente cadastrado com sucesso').Status(201);
  finally
    cliente.Free;
    objCliente.Free;
    body.Free;
  end;
end;

procedure DeletarClientes(Req: THorseRequest; Res: THorseResponse);
var
  cliente: TCliente;
  objCliente: TJSONObject;
  erro: string;
begin
  try
    cliente := TCliente.Create;
  except
    Res.Send('Erro ao conectar com o banco de dados').Status(500);
    exit;
  end;

  try
    try
      cliente.id_cliente := Req.Params['id'].ToInteger;
      if not cliente.Excluir(erro) then
        raise Exception.Create(erro);
    except on ex:exception do
    begin
      Res.Send(ex.Message).Status(400);
      exit;
    end;

    end;

    objCliente := TJSONObject.Create;
    objCliente.AddPair('id_cliente', cliente.id_cliente.ToString);

    Res.Send<TJSONObject>(objCliente);
  finally
    cliente.Free;
    objCliente.Free;
  end;
end;

procedure EditarClientes(Req: THorseRequest; Res: THorseResponse);
var
  cliente: TCliente;
  objCliente: TJSONObject;
  erro: string;
  body: TJSONValue;
begin
  try
    cliente := TCliente.Create;
  except
    Res.Send('Erro ao conectar com o banco de dados').Status(500);
    exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;
      cliente.id_cliente := body.GetValue<Integer>('id_cliente', 0);
      cliente.nome := body.GetValue<string>('nome', '');
      cliente.email := body.GetValue<string>('email', '');
      cliente.telefone := body.GetValue<string>('telefone', '');
      cliente.Editar(erro);
      body.Free;
      if erro <> '' then
        raise Exception.Create(erro);
    except on ex:exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;
    objCliente := TJSONObject.Create;
    objCliente.AddPair('id_cliente', cliente.id_cliente.ToString);
    Res.Send('Cliente cadastrado com sucesso').Status(200);
  finally
    cliente.Free;
    objCliente.Free;
    body.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/clientes', ListarClientes);
  THorse.Get('/clientes/:id', ListarClienteId);
  THorse.Post('/clientes', CadastrarClientes);
  THorse.Delete('/clientes/:id', DeletarClientes);
  THorse.Put('/clientes/:id', EditarClientes);
end;

end.
