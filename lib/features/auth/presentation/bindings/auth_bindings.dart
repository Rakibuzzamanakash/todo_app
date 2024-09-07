import 'package:get/get.dart';

import '../../data/data_sources/database_helper/auth_helper.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repository/auth_use_case.dart';
import '../controller/auth_controller.dart';

Future<void> init() async {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  await databaseHelper.database;

  Get.lazyPut<AuthRepositoryImpl>(() =>
      AuthRepositoryImpl(databaseHelper)); // Pass the DatabaseHelper instance
  Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));

  Get.lazyPut(() => AuthController(Get.find<LoginUseCase>()));
}
