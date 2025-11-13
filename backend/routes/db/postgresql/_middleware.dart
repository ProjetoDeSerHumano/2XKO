import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

//conexão com o banco de dados
Handler middleware(Handler handler) {
  return (context) async {
    final connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: '2xko',
        username: 'postgres',
        password: 'postdba',
      ),

      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );

    //retorno dos dados
    final response = await handler
        .use(provider<Connection>((_) => connection))
        .call(context);

    await connection.close();

    return response; 
  };
}
