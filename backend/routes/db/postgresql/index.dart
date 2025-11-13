import 'dart:io' show HttpStatus;

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

/*Future<Response> _getLists(RequestContext context) async {
  final lists = <Map<String, dynamic>>[];

  final results = await context
      .read<PostgreSQLConnection>()
      .query('SELECT id , name FROM lists');

  for (final row in results) {
    lists.add({'id': row[0], 'name': row[1]});
  }

  return Response.json(body: lists.toString());
}*/

Future<Response> _getLists(RequestContext context) async {
  final lists = <Map<String, dynamic>>[];

  final results = await context.read<Connection>().execute(
    'SELECT id , name FROM lists',
  );

  for (final row in results) {
    lists.add({'id': row[0], 'name': row[1]});
  }

  return Response.json(body: lists);
}

/*Future<Response> _createList(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name != null) {
    try {
      final result = await context.read<PostgreSQLConnection>().query(
          "INSERT INTO lists (name) VALUES ('$name')  ");

      if (result.affectedRowCount == 1) {
        return Response.json(body: {'success': true});
      } else {
        return Response.json(body: {'success': false});
      }
    } catch (e) {
      return Response(statusCode: HttpStatus.connectionClosedWithoutResponse);
    }
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }*/

Future<Response> _createList(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Missing "name" field.',
    );
  }

  try {
   
    await context.read<Connection>().execute(
    r'INSERT INTO lists (name) VALUES ($1)',
    
    //Argumentos: lista de valores que substituirão $1, $2, etc..
    parameters: [
        name,
    ]
);
    // Se o código chegou até aqui, a inserção foi bem-sucedida.
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'success': true, 'message': 'List created successfully'},
    );
  } catch (e) {
    // Retorna o erro real, mas formatado no console do Dart Frog.
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: 'Database error occurred. Check server console.',
    );
  }
}
