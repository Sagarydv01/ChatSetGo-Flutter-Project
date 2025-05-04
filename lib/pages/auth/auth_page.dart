import 'package:chatsetgo/pages/auth/auth_body.dart';
import 'package:chatsetgo/pages/welcome_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const WelcomeHeading(),
              const SizedBox(height: 20),
              AuthPageBody()
            ],
          ),
        ),
      ),
    );
  }
}
