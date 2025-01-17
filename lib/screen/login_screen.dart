import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/value/colors.dart';
import '../controller/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.login(
                      emailController.text, passwordController.text);
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () => Get.to(RegisterScreen()),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
