import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource dataSource;

  TodoRepositoryImpl(this.dataSource);

  @override
  Future<List<Todo>> getTodos() async {
    return await dataSource.getTodos();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todoModel = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
      imageUrl: todo.imageUrl,
      completionDate: todo.completionDate,
    );
    await dataSource.addTodo(todoModel);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todoModel = TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isDone: todo.isDone,
        imageUrl: todo.imageUrl,
        completionDate: todo.completionDate);
    await dataSource.updateTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await dataSource.deleteTodo(id);
  }
}
