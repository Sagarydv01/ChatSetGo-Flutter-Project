import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chatsetgo/pages/auth/login_form.dart';
import 'package:chatsetgo/pages/auth/sign_up_form.dart';
import '../../controller/auth_controller.dart';

class AuthPageBody extends StatelessWidget {
  AuthPageBody({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Center(
      child: Container(
        width: screenWidth * 0.90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Row(
              children: [
                _buildTab(
                  context,
                  label: "Login",
                  isSelected: authController.isLogin.value,
                  onTap: () => authController.toggleAuthTab(true),
                ),
                _buildTab(
                  context,
                  label: "Sign Up",
                  isSelected: !authController.isLogin.value,
                  onTap: () => authController.toggleAuthTab(false),
                ),
              ],
            )),
            const SizedBox(height: 20),
            Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: authController.isLogin.value
                  ? const LoginForm()
                  : const SignUpForm(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context,
      {required String label,
        required bool isSelected,
        required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                label,
                style: isSelected
                    ? Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)
                    : Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: isSelected ? 100 : 0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
