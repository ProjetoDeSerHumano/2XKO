import 'package:dart_frog/dart_frog.dart';

//requestcontext é uma variavel com todos os detalhes da requisicao
Response onRequest(RequestContext context) {
  final value = context.read<String>();
  return Response(body: value);
}
