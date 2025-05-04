import 'package:flutter/material.dart';

import '../../widgets/buttons.dart';

class UserUpdateProfile extends StatelessWidget {
  const UserUpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer, // 💡 Color retained
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Avatar Image ──
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: const Icon(Icons.image, size: 50),
                ),
              ),

              const SizedBox(height: 24),

              // ── Section Title ──
              Text(
                "Personal Info",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 20),

              // ── Name Field ──
              Text(
                "Name",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),

              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Enter your name",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔄 Add more fields if needed here...
              // ── Email Field ──
              Text(
                "Email",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),

              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  hintText: "Enter your email",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Mobile Number Field ──
              Text(
                "Mobile Number",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),

              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: "Enter your mobile number",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              Center(
                child: PrimaryButton(
                    btnName: "Save",
                    icon: Icons.save,
                    onPressed: () {}
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
