import 'package:flutter/material.dart';
import '../validators.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//View for register
class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), 
        flexibleSpace: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (!isValidEmail(email)) {
              
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email format')),
                  );
                  return;
                }
                // Sign up logic
                try {
                    // Create a new user
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    // Get the current user
                    final user = userCredential.user;

                    if (user != null) {
                      // Send a verification email
                      await user.sendEmailVerification();

                      // Prompt the user to check their email
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification email sent. Please check your email.')),
                      );

                      // Wait for the user to verify their email
                      bool isVerified = false;
                      while (!isVerified) {
                        await Future.delayed(const Duration(seconds: 3));
                        await user.reload(); // Reload user information
                        isVerified = user.emailVerified; // Check if the email is verified
                      }

                      // If verified, display a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign up successfully')),
                      );
                    }
                  } catch (e) {
                    // Display error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign up failure: ${e.toString()}')),
                    );
                  }

              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}


