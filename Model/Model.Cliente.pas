unit Model.Cliente;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.connection;

type
  TCliente = class
    private
      FId_cliente: Integer;
      FNome: string;
      FEmail: string;
      FTelefone: string;
    public
      constructor Create;
      destructor Destroy; override;
      property id_cliente: Integer read FId_cliente write FId_cliente;
      property nome: string read FNome write FNome;
      property email: string read FEmail write FEmail;
      property telefone: string read FTelefone write FTelefone;

      function ListarCliente(order_by: string; out erro: string): TFDQuery;
      function Inserir(out erro: string): Boolean;
      function Excluir(out erro: string): Boolean;
      function Editar(out erro: string): Boolean;
end;

implementation

constructor TCliente.Create;
begin
  Model.connection.Connect;
end;

destructor TCliente.Destroy;
begin
  Model.connection.Disconect;
end;

function TCliente.ListarCliente(order_by: string; out erro: string): TFDQuery;
var
  query: TFDQuery;
begin
  try
    query := TFDQuery.Create(nil);
    query.Connection := Model.connection.FConnection;
    with query do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('SELECT * FROM TAB_CLIENTE WHERE 1 = 1');
      if id_cliente > 0 then
      begin
        SQL.Add('AND ID_CLIENTE = :cliente_id');
        ParamByName('cliente_id').Value := id_cliente;
      end;
      if order_by <> '' then
      begin
        SQL.Add('ORDER BY ' + order_by);
      end
      else
        SQL.Add('ORDER BY NOME');
      Active := true;
    end;
    erro := '';
    Result := query;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar clientes: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TCliente.Inserir(out erro: string): Boolean;
var
  query: TFDQuery;
begin
  // VALIDA��ES
  if nome.IsEmpty then
  begin
    Result := False;
    erro := 'Informe o nome do cliente';
    exit;
  end;

  try
    query := TFDQuery.Create(nil);
    query.Connection := Model.connection.FConnection;

    with query do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('INSERT INTO TAB_CLIENTE(NOME, EMAIL, FONE)');
      SQL.Add('VALUES (:nome, :email, :telefone)');
      ParamByName('nome').Value := nome;
      ParamByName('email').Value := email;
      ParamByName('telefone').Value := telefone;

      ExecSQL;

      // BUSCA ID INSERIDO
      Params.Clear;
      SQL.Clear;
      SQL.Add('SELECT MAX(ID_CLIENTE) AS ID_CLIENTE FROM TAB_CLIENTE');
      SQL.Add('WHERE EMAIL = :email');
      ParamByName('email').Value := email;
      active := true;

      id_cliente := FieldByName('ID_CLIENTE').AsInteger;
    end;

    query.Free;
    erro := '';
    Result := True;
  except on ex:exception do
  begin
    erro := 'Erro ao criar cliente: ' + ex.Message;
    Result := False;
  end;

  end;
  
end;

function TCliente.Excluir(out erro: string): Boolean;
var
  query: TFDQuery;
begin
  try
    query := TFDQuery.Create(nil);
    query.Connection := Model.connection.FConnection;
    with query do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('DELETE FROM TAB_CLIENTE WHERE ID_CLIENTE = :id_cliente');
      ParamByName('id_cliente').Value := id_cliente;
      ExecSQL;
    end;
    query.Free;
    erro := '';
    Result := true;
  except on ex:exception do
  begin
    erro := 'Erro ao excluir usu�rio: ' + ex.Message;
    Result := False;
  end;
  end;
end;

function TCliente.Editar(out erro: string): Boolean;
var
  query: TFDQuery;
begin
  try

    // Valida��es...
    if id_cliente < 0 then
    begin
        Result := False;
        erro := 'Informe o ID do cliente';
        exit;
    end;
    

    query := TFDQuery.Create(nil);
    query.Connection := Model.connection.FConnection;
    with query do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('UPDATE TAB_CLIENTE SET NOME=:NOME, EMAIL=:EMAIL, FONE:=FONE');
      SQL.Add('WHERE ID_CLIENTE = :ID_CLIENTE');
      ParamByName('NOME').Value := nome;
      ParamByName('EMAIL').Value := email;
      ParamByName('FONE').Value := telefone;
      ParamByName('ID_CLIENTE').Value := id_cliente;
      ExecSQL;
    end;
    query.Free;
    erro := '';
    Result := true;
  except on ex:exception do
  begin
    erro := 'Erro ao alterar usu�rio: ' + ex.Message;
    Result := False;
  end;
  end;
end;

end.
