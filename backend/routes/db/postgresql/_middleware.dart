import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
//conexão com o banco de dados
Handler middleware(Handler handler) {
  return (context) async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      '2xko',
      username: 'postgres',
      password: 'postdba',
    );

    await connection.open();

    //retorno dos dados
    final response = await handler
        .use(provider<PostgreSQLConnection>((_) => connection))
        .call(context);

    await connection.close();

    return response;

  };
}
