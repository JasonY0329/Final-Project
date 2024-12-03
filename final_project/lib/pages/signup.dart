import 'package:final_project/pages/homepage.dart';
import 'package:flutter/material.dart';
import '../validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
              'Sign Up',
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
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
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
                final password = passwordController.text.trim();
                final fullName = nameController.text.trim();
                final phoneNumber = phoneController.text.trim();

                if (!isValidEmail(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email format')),
                  );
                  return;
                }

                if (fullName.isEmpty || phoneNumber.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all fields.')),
                  );
                  return;
                }

                try {
                  // Create a new user
                  final userCredential =
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Get the current user
                  final user = userCredential.user;

                  if (user != null) {
                    // Save user details to Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'uid': user.uid,
                      'email': email,
                      'name': fullName,
                      'phone': phoneNumber,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    // Send a verification email
                    await user.sendEmailVerification();

                    // Prompt the user to check their email
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Verification email sent. Please check your email.')),
                    );

                    // Wait for the user to verify their email
                    bool isVerified = false;
                    while (!isVerified) {
                      await Future.delayed(const Duration(seconds: 3));
                      await user.reload(); // Reload user information
                      isVerified = user.emailVerified; // Check if verified
                    }

                    // If verified, display a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign up successfully')),
                    );

                    // Navigate to home page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userData: {
                            'uid': user.uid,
                            'email': email,
                            'name': fullName,
                            'phone': phoneNumber,
                          },
                        ),
                      ),
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
