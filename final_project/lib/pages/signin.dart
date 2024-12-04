import 'package:flutter/material.dart';
import 'signup.dart';
import 'homepage.dart';
import 'password.dart';
import '../validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonTextColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign In')), // Center the title
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
                final password = passwordController.text.trim();

                if (!isValidEmail(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email format')),
                  );
                  return;
                }

                try {
                  // Sign in the user
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  final user = userCredential.user;

                  // Ensure user is not null
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign-in failed. Please try again.')),
                    );
                    return;
                  }

                  // Check if the user's email is verified
                  if (!user.emailVerified) {
                    await user.sendEmailVerification(); // Send a verification email
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email not verified. A verification email has been sent. Please verify and try again.',
                        ),
                      ),
                    );
                    await FirebaseAuth.instance.signOut(); // Sign out the user
                    return;
                  }

                  // Fetch user information from Firestore
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid) // Access the uid safely
                      .get();

                  if (userDoc.exists && userDoc.data() != null) {
                    // Navigate to HomePage with user data
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userData: userDoc.data()!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User data not found')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in failure: $e')),
                  );
                }
              },
              child: Text(
                'Sign In',
                style: TextStyle(color: buttonTextColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: buttonTextColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    'No account?',
                    style: TextStyle(
                      color: buttonTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}