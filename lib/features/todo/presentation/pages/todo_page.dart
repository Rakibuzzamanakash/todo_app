// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/todo_controller.dart';
// import 'add_todo.dart';
// import 'edit_todo_page.dart';
//
// class TodoPage extends StatelessWidget {
//   final TodoController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todo List'),
//       ),
//       body: Obx(() {
//         if (controller.todos.isEmpty) {
//           return Center(child: Text('No Todos'));
//         }
//         return ListView.builder(
//           itemCount: controller.todos.length,
//           itemBuilder: (context, index) {
//             final todo = controller.todos[index];
//             return Card(
//               child: Container(
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: Text(todo.title),
//                       subtitle: Text(todo.description),
//                     ),
//                     Text('Completion Date: ${controller.formatDateTime(todo.completionDate)}'),
//                     SizedBox(
//                       height: 200,
//                       width: double.infinity,
//                       child: todo.imageUrl.isNotEmpty
//                           ? Image.file(
//                         File(todo.imageUrl),
//                         fit: BoxFit.cover,
//                       )
//                           : Center(child: Text('No image available')),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         controller.toggleIsDone(todo); // Use toggleIsDone directly
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16.0),
//                         color: todo.isDone ? Colors.teal : Colors.amberAccent,
//                         child: Text(
//                           todo.isDone ? 'Task Completed' : 'Task Incomplete',
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Get.to(() => EditTodoPage(todo: todo));
//                           },
//                           icon: Icon(Icons.edit),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             controller.deleteTodo(todo.id);
//                           },
//                           icon: Icon(Icons.delete_outline_outlined),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.to(() => AddTodoPage()); // Navigate to AddTodoPage
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/repository/auth_repository_impl.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../controllers/todo_controller.dart';
import 'add_todo.dart';
import 'edit_todo_page.dart';


class TodoPage extends StatelessWidget {
  final TodoController controller = Get.find();
  final AuthRepositoryImpl authRepository = Get.find<AuthRepositoryImpl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List',),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined,),
            onPressed: () async {
              await authRepository.logout(); // Perform logout
              Get.offAll(() => LoginPage()); // Navigate to LoginPage
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.todos.isEmpty) {
          return Center(child: Text('No Todos'));
        }
        return ListView.builder(
          itemCount: controller.todos.length,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Card(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text('Title : ${todo.title}',style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                      SizedBox(height: 10,),
                      Text('Description : ${todo.title}',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),),
                      Text('Completion Date : ${controller.formatDateTime(todo.completionDate)}',style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),),
                      SizedBox(height: 10,),

                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: todo.imageUrl.isNotEmpty
                            ? Image.file(
                          File(todo.imageUrl),
                          fit: BoxFit.cover,
                        )
                            : Center(child: Text('No image available')),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(() => EditTodoPage(todo: todo));
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.deleteTodo(todo.id);
                            },
                            icon: Icon(Icons.delete_outline_outlined),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              controller.toggleIsDone(todo); // Use toggleIsDone directly
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: todo.isDone ? Colors.teal : Colors.deepOrangeAccent,
                              ),
                              child: Text(
                                todo.isDone ? 'done' : 'inProgress',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTodoPage()); // Navigate to AddTodoPage
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
