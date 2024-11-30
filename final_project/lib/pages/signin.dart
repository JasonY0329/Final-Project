import 'package:flutter/material.dart';
import 'signup.dart';
import 'homepage.dart';
import 'password.dart';
import '../validators.dart'; // 引入验证器文件
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonTextColor = Theme.of(context).primaryColor; // 定义文字颜色

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
                  // 显示错误提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email format')),
                  );
                  return;
                }
                // Sign in logic
                 try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign in successfully')));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()), // 替换为你的主页组件
                        );

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
                      color: buttonTextColor, // 文字为紫色
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
                      color: buttonTextColor, // 文字为紫色
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


