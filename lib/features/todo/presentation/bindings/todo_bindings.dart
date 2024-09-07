import 'package:get/get.dart';

import '../../data/datasources/todo_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../controllers/todo_controller.dart';


class TodoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoRepository>(() => TodoRepositoryImpl(TodoDataSource.db));
    Get.lazyPut(() => TodoController(Get.find()));
  }
}
