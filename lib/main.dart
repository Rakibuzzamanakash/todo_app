import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:todo_app/features/auth/presentation/pages/splash_screen.dart';

import 'core/services/notification_services.dart';
import 'features/todo/data/datasources/todo_datasource.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/presentation/bindings/todo_bindings.dart';
import 'features/todo/presentation/controllers/todo_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initializeNotifications();

  Get.put<TodoRepository>(TodoRepositoryImpl(TodoDataSource.db));  // Inject Repository
  Get.put<TodoController>(TodoController(Get.find()));  // Inject Controller

  await init();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        useMaterial3: true,
      ),
      initialBinding: TodoBindings(),
      // home:  TodoPage(),
      home: SplashScreen(),
    );
  }
}
