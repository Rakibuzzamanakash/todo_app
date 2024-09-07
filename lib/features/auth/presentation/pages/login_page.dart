import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/core/utils/widgets/custom_button.dart';
import 'package:todo_app/core/utils/widgets/coustom_textField.dart';

import '../controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
                controller: usernameController, labelText: 'Username'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: passwordController,
                obsText: true,
                labelText: 'Password'),
            const SizedBox(height: 16),
            Obx(() {
              return authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      title: 'Login',
                      onAction: () {
                        authController.login(
                            usernameController.text, passwordController.text);
                      });
            }),
          ],
        ),
      ),
    );
  }
}
