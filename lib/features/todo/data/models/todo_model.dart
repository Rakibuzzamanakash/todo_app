import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isDone,
    required super.imageUrl,
    required super.completionDate,
  });

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isDone: json['isDone'] == 1,
    imageUrl: json['imageUrl'],
    completionDate: DateTime.parse(json['completionDate']), // Convert String to DateTime
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone ? 1 : 0,
    'imageUrl': imageUrl,
    'completionDate': completionDate!.toIso8601String(), // Convert DateTime to String
  };
}
