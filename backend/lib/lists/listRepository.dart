import 'package:backend/hash_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'listRepository.g.dart';

@visibleForTesting
Map<String, TaskList> listDb = {};

//linha que diz ao build_runner para gerar o codigo json na classe
@JsonSerializable()

/// equatable permite a comparação de valores e tratalos como um mesmo sendo diferentes no banco de dados
class TaskList extends Equatable {
  ///contrutor
  const TaskList({required this.id, required this.name});

  //transforma um arquivo json em um objeto lista de tasks
  /// deserialization
  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  /// copyWith method
  TaskList copyWith({
    String? id,
    String? name,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  /// List's id

  final String id;

  /// List's name

  final String name;

  //transformar um arquivo json em uma lista de tasks

  ///transforma a tasklist em um arquivo json
  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  //verifica se 2 objetos da lista são iguais a comparar os ids e os nomes
  @override
  List<Object?> get props => [id, name];
}

class TaskListRepository {
  //chamada asincrona para esperar o retorno do banco de dados
  Future<TaskList?> listById(String id) async {
    //retorna o objeto lista
    return listDb[id];
  }

  Map<String, dynamic> getAllLists() {
    //variavel que vai guarda a resposta da funcao
    final formattedLists = <String, dynamic>{};

    if (listDb.isNotEmpty) {
      //for que percorre toda a lista armazenando dados
      listDb.forEach(
        (String id) {
          final currentlist = listDb[id];
          formattedLists[id] = currentlist?.toJson();
        } as void Function(String key, TaskList value),
      );
    }

    return formattedLists;
  }
  ///função de criar lista
  String createList({required String name}) {
    /// id gerado com hash
    final id = name.hashValue;

    /// cria uma lista
    final list = TaskList(id: id, name: name);

    /// adiciona a lista ao bd
    listDb[id] = list;

    return id;
  }

  void deleteList(String id) {
    listDb.remove(id);
  }

  /// Update operation
  Future<void> updateList({required String id, required String name}) async {
    final currentlist = listDb[id];

    if (currentlist == null) {
      return Future.error(Exception('List not found'));
    }

    listDb[id] = TaskList(id: id, name: name);
  }
}
