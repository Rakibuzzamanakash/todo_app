import 'package:get/get.dart';
import 'package:todo_app/features/todo/presentation/pages/todo_page.dart';

import '../../domain/repository/auth_use_case.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;

  AuthController(this.loginUseCase);

  var isLoading = false.obs;
  var token = ''.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      final user = await loginUseCase(username, password);
      if (user != null) {
        token.value = user.token;
        Get.off(TodoPage());
        Get.snackbar('Login Success', 'Welcome, ${user.username}');
      } else {
        Get.snackbar('Login Failed', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
