import 'package:get/get.dart';
import '../../../todo/presentation/pages/todo_page.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../pages/login_page.dart';

class SplashController extends GetxController {
  // Use Get.find() to retrieve the AuthRepositoryImpl instance
  final AuthRepositoryImpl authRepository = Get.find<AuthRepositoryImpl>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await authRepository.getToken();
    if (token != null) {
      // Token exists, navigate to TodoPage
      Get.off(() => TodoPage());
    } else {
      // No token, navigate to LoginPage
      Get.off(() => LoginPage());
    }
  }
}
