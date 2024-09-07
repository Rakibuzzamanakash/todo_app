import 'package:get/get.dart';
import '../../../todo/presentation/pages/todo_page.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../pages/login_page.dart';

class SplashController extends GetxController {
  final AuthRepositoryImpl authRepository = Get.find<AuthRepositoryImpl>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await authRepository.getToken();
    if (token != null) {
      Get.off(() => TodoPage());
    } else {
      Get.off(() => LoginPage());
    }
  }
}
