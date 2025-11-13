import 'package:backend/items/itemRepository.dart';
import 'package:backend/lists/listRepository.dart';
import 'package:dart_frog/dart_frog.dart';

//handler recebe os dados e passa pro middleware que trabalha em cima deles para criar uma resposta pra requisicao e envia de volta para o context poder usar esses dados

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler
      .use(requestLogger())
      .use(provider<TaskListRepository>((context) => TaskListRepository()))
      .use(provider<TaskItemRepository>((context) => TaskItemRepository()));
}
