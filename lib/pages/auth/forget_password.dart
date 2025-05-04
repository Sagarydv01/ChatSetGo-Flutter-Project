import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final authController = Get.find<AuthController>();

  ForgotPasswordPage({super.key});

  void _sendResetEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains("@")) {
      Get.snackbar("Invalid", "Please enter a valid email");
      return;
    }
    authController.resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Enter your email to reset your password", style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => authController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Send Reset Link"),
              onPressed: _sendResetEmail,
            )),
          ],
        ),
      ),
    );
  }
}
