import 'package:backend/hash_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'itemRepository.g.dart';

@visibleForTesting
/// Data source - in-memory cache
Map<String, TaskItem> itemtDb = {};

@JsonSerializable()
/// TaskList class
class TaskItem extends Equatable {
  /// Constructor
  const TaskItem({
    required this.id,
    required this.listid,
    required this.name,
    required this.description,
    required this.status,
  });

  /// deserialization
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  /// copyWith method
  TaskItem copyWith({
    String? id,
    String? listid,
    String? name,
    String? description,
    bool? status,
  }) {
    return TaskItem(
      id: id ?? this.id,
      listid: listid ?? this.listid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  /// Item's id
  final String id;

  /// List id of where the item belongs
  final String listid;

  /// Item's name
  final String name;

  /// Item's description
  final String description;

  /// Item's status
  final bool status;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  @override
  List<Object?> get props => [id, name];
}

/// classe repositorio TaskItem
class TaskItemRepository {
  Future<TaskItem?> itemById(String id) async {
    return itemtDb[id];
  }

  /// puxa todos os itens do banvo de dados
  Map<String, dynamic> getAllItems() {
    final formattedItems = <String, dynamic>{};

    if (itemtDb.isNotEmpty) {
      itemtDb.forEach((key, value) {
        formattedItems[key] = value.toJson();
      });
    }

    return formattedItems;
  }

  /// procura item por id
  Map<String, dynamic> getItemsByList(String listid) {
    final formattedItems = <String, dynamic>{};
    if (itemtDb.isNotEmpty) {
      itemtDb.forEach((key, value) {
        if (value.listid == listid) {
          formattedItems[key] = value.toJson();
        }
      });
    }
    return formattedItems;
  }

  /// cria um novo item
  String createItem({
    required String name,
    required String listid,
    required String description,
    required bool status,
  }) {
    final id = name.hashValue;

    final item = TaskItem(
      id: id,
      name: name,
      listid: listid,
      description: description,
      status: status,
    );

    itemtDb[id] = item;

    return id;
  }

  /// realiza o delete do item do [id]
  void deleteItem(String id) {
    itemtDb.remove(id);
  }

  /// função Update
  Future<void> updateItem({
    required String id,
    required String name,
    required String listid,
    required String description,
    required bool status,
  }) async {
    final currentitem = itemtDb[id];

    if (currentitem == null) {
      return Future.error(Exception('Item not found'));
    }

    itemtDb[id] = TaskItem(
      id: id,
      name: name,
      listid: listid,
      description: description,
      status: status,
    );
  }
}
