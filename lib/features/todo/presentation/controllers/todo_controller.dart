import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/notification_services.dart';
import '../../data/models/todo_model.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoController extends GetxController {
  final TodoRepository repository;
  TodoController(this.repository);

  var loading = false.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  final todos = <Todo>[].obs;

  @override
  void onInit() {
    fetchTodos();
    super.onInit();
  }

  Future<void> fetchTodos() async {
    todos.value = await repository.getTodos();
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Not Set';
    }
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
  }

  Future<void> selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDateTime.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  Future<void> toggleIsDone(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isDone: !todo.isDone,
      imageUrl: todo.imageUrl,
      completionDate: todo.completionDate,
    );

    await repository.updateTodo(updatedTodo);
    fetchTodos();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imagePath = await saveImage(image);
      selectedImage.value = File(imagePath);
    }
  }

  Future<String> saveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final newImage = await File(image.path)
        .copy('$path/${DateTime.now().millisecondsSinceEpoch}.png');

    Directory(path).list().forEach((file) {
      print('File: ${file.path}');
    });

    return newImage.path;
  }

  Future<void> addTodo(String title, String description, String imageUrl,
      DateTime? completionDate) async {
    loading.value = true;

    try {
      final int notificationId =
          NotificationService.generateNotificationId(); // Generate a unique ID

      final newTodo = TodoModel(
        id: notificationId, // Use the generated ID for the new todo
        title: title,
        description: description,
        isDone: false,
        imageUrl: imageUrl,
        completionDate: completionDate,
      );

      todos.add(newTodo);
      await repository.addTodo(Todo(
        id: newTodo.id,
        title: newTodo.title,
        description: newTodo.description,
        isDone: false,
        imageUrl: imageUrl,
        completionDate: completionDate,
      ));

      if (completionDate != null) {
        await NotificationService.showNotification(
          id: notificationId, // Pass the generated ID to showNotification
          title: 'Task Reminder: ${newTodo.title}',
          body: 'This task is still incomplete. Don’t forget to complete it!',
          scheduledTime: completionDate,
        );
      }

      selectedImage.value = null;
      selectedDateTime.value = null;
      Get.snackbar('Success', 'Todo added successfully');
    } catch (e) {
      print('Error adding todo: $e');
      Get.snackbar('Error', 'Failed to add todo');
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await repository.updateTodo(todo);
    Get.snackbar('Success', 'Todo updated successfully');

    if (todo.isDone) {
      NotificationService.cancelNotification(todo.id);
    } else if (todo.completionDate != null) {
      NotificationService.showNotification(
        id: todo.id, // Pass the ID to match the updated method signature
        title: 'Task Reminder: ${todo.title}',
        body: 'This task is still incomplete. Don’t forget to complete it!',
        scheduledTime: todo.completionDate!,
      );
    }

    fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await repository.deleteTodo(id);
    fetchTodos();
  }
}
