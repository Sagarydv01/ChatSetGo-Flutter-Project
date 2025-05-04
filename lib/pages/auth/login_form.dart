import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatsetgo/widgets/buttons.dart';
import '../../controller/auth_controller.dart';   // Auth logic using GetX
import 'forget_password.dart';            // Forgot password screen

// LoginForm is a stateful widget that handles login UI + validation + logic
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form key used for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to track input values
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Toggle password visibility
  bool _obscurePassword = true;

  // GetX controller that manages auth state and logic
  final AuthController authController = Get.put(AuthController());

  // Dispose controllers when not needed to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles form submission: validates, then calls login from authController
  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      // Call login from GetX controller
      bool success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // If successful, show snackbar and navigate to homepage
      if (success) {
        Get.snackbar(
          "Login",
          "Logged in as ${_emailController.text}",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed("/homePage"); // Clear previous routes and go to home
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey, // Assign the form key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text("Welcome back 👋", style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text("Please sign in to your account", style: textTheme.bodyMedium),
          const SizedBox(height: 24),

          // Email input field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password input field with visibility toggle
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // Toggle password visibility
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),

          // "Forgot Password?" text button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              // Navigates to forgot password screen
              onPressed: () => Get.to(() => ForgotPasswordPage()),
              child: const Text("Forgot Password?"),
            ),
          ),
          const SizedBox(height: 16),

          // Login button with loading spinner
          Obx(() => authController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : PrimaryButton(
            btnName: "Login",
            icon: Icons.login,
            onPressed: _submitLogin, // Calls the login handler
          )),
        ],
      ),
    );
  }
}
