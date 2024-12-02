import 'package:flutter/material.dart';
import 'signup.dart';
import 'homepage.dart';
import 'password.dart';
import '../validators.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//View for login
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
                if (!isValidEmail(email)) {
                 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email format')),
                  );
                  return;
                }
                // Sign in logic
                 try {
                    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    final user = userCredential.user;
                    if (user != null) {
                      // Check if the email is verified
                      if (user.emailVerified) {
                        // Email is verified, allow login
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign in successfully')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      } else {
                        // Email not verified, display warning
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Sign in failed: Email not verified. Please check your inbox and verify your email.',
                            ),
                          ),
                        );
                      }
                    }
                    // await FirebaseAuth.instance.signInWithEmailAndPassword(
                    //   email: emailController.text.trim(),
                    //   password: passwordController.text.trim(),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Sign in successfully')));
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const HomePage()),
                    //     );

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign in failure：${e.toString()}')));
                  }
              },
              child: Text(
                'Sign In',
                style: TextStyle(color: buttonTextColor),
              ),
            ),
            const SizedBox(height: 10), // Add spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align both ends
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
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


