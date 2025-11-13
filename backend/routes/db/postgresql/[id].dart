import 'dart:io' show HttpStatus;

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name == null) { // Retorna erro 400 se 'name' estiver faltando
    return Response(statusCode: HttpStatus.badRequest, body: 'Missing "name" field.');
  }

  try {
    final result = await context.read<Connection>().execute(
      r'UPDATE lists SET name = $1 WHERE id = $2',
      
      parameters: [
        name, // $1
        id,   // $2
      ],
    );

    // Verifica se uma linha foi afetada.
    if (result.affectedRows == 1) { 
      return Response.json(body: {'success': true});
    } else if (result.affectedRows == 0) {
      // Se 0 linhas foram afetadas, a lista não foi encontrada (404 Not Found)
      return Response(statusCode: HttpStatus.notFound, body: 'List not found.');
    } else {
      // Caso de erro genérico
      return Response.json(body: {'success': false, 'message': 'Update failed.'});
    }
    
  } catch (e) {
    
    return Response(statusCode: HttpStatus.internalServerError, body: 
    'Database error occurred.');
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  try {
    // 1. CORREÇÃO DE API E SEGURANÇA: Usando .execute() e parâmetros posicionais ($1)
    final result = await context.read<Connection>().execute(
      // Raw string (r'...') para tratar o $1 como placeholder SQL
      r'DELETE FROM lists WHERE id = $1',
      parameters: [id], // O valor 'id' é passado separadamente
    );

    if (result.affectedRows == 1) {
      // 204 No Content: Padrão para exclusão bem-sucedida sem corpo de resposta
      return Response(statusCode: HttpStatus.noContent); 
    } else if (result.affectedRows == 0) {
      // Se 0 linhas foram afetadas, o item não existia
      return Response(statusCode: HttpStatus.notFound); 
    }
    
    // Fallback: Se affectedRows for algo inesperado 
    return Response(statusCode: HttpStatus.internalServerError, body:
     'Deletion failed unexpectedly.');

  } catch (e) {

    return Response(statusCode: HttpStatus.internalServerError, body:
     'Database error occurred.'); 
  }
}
