import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/data_sources/database_helper/auth_helper.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repository/auth_use_case.dart';
import '../controller/auth_controller.dart';

Future<void> init() async {
  // Initialize dependencies
  final DatabaseHelper databaseHelper = DatabaseHelper();  // Initialize the DatabaseHelper

  await databaseHelper.database;  // Ensure the DB is set up before using it

  // Dependency injection using Get.lazyPut
  Get.lazyPut<AuthRepositoryImpl>(() => AuthRepositoryImpl(databaseHelper));  // Pass the DatabaseHelper instance
  Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));

  // Register AuthController
  Get.lazyPut(() => AuthController(Get.find<LoginUseCase>()));
}
