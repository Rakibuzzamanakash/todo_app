import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/utils/widgets/custom_button.dart';
import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';

class EditTodoPage extends StatelessWidget {
  final Todo todo;
  final TodoController controller = Get.find<TodoController>();
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  EditTodoPage({required this.todo})
      : titleController = TextEditingController(text: todo.title),
        descriptionController = TextEditingController(text: todo.description) {
    // Initialize selectedImage with the existing image path if available
    controller.selectedImage.value = todo.imageUrl.isNotEmpty ? File(todo.imageUrl) : null;
    controller.selectedDateTime.value = todo.completionDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          controller.selectedImage.value = null;
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Todo Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Todo Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Stack(
              children: [
                Container(
                  height: 150,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      border: Border.all(
                          width: 3,
                          color: Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: controller.selectedImage.value == null
                      ? Center(
                    child: Text('No image selected'),
                  )
                      : Image.file(
                    controller.selectedImage.value!,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => controller.pickImage(),
                    icon: Icon(Icons.camera, color: Colors.white),
                  ),
                )
              ],
            )),
            SizedBox(height: 20),
            Obx(() => Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title: Text(
                  controller.selectedDateTime.value == null
                      ? 'Select Completion Date and Time'
                      : DateFormat('yyyy-MM-dd – kk:mm')
                      .format(controller.selectedDateTime.value!),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => controller.selectDateTime(context),
              ),
            )),
            SizedBox(height: 20),
            CustomButton(title: 'Update Todo', onAction: (){
              final imagePath = controller.selectedImage.value?.path ?? todo.imageUrl;
              final dateTime = controller.selectedDateTime.value;

              final updatedTodo = Todo(
                  id: todo.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  isDone: todo.isDone,
                  imageUrl: imagePath,
                  completionDate: dateTime
              );
              controller.updateTodo(updatedTodo);
              Get.back();
            })
          ],
        ),
      ),
    );
  }
}
