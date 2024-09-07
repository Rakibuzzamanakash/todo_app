import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/utils/widgets/custom_button.dart';
import 'package:todo_app/core/utils/widgets/custom_textField.dart';
import '../controllers/todo_controller.dart';

class AddTodoPage extends StatelessWidget {
  final TodoController controller = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: titleController,
                labelText: 'Todo Title',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Todo Description',
              ),
              const SizedBox(height: 20),
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
                            ? const Center(
                                child: Text('No image selected',style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                                ),),
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
                            icon:
                                const Icon(Icons.camera, color: Colors.white)),
                      )
                    ],
                  )),
              const SizedBox(height: 20),
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
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => controller.selectDateTime(context),
                    ),
                  )),
              const SizedBox(height: 20),

              CustomButton(
                title: 'Add Todo',
                onAction: () async {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  if (title.isEmpty || description.isEmpty) {
                    Get.snackbar(
                        'Error', 'Title and description cannot be empty');
                    return;
                  }

                  final imagePath = controller.selectedImage.value?.path ?? '';
                  final dateTime = controller.selectedDateTime.value;

                  await controller.addTodo(
                    title,
                    description,
                    imagePath,
                    dateTime,
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
