import 'package:flutter/material.dart';
import '../validators.dart'; // 引入验证器文件
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // 清空默认标题
        flexibleSpace: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Password reset',
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
              decoration: const InputDecoration(labelText: 'Please input your email'),
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
                // Forget password logic
                 try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset email has been sent')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email sent failure：${e.toString()}')));
                    }
              },
              child: const Text('Send password reset confirmation email'),
            ),
          ],
        ),
      ),
    );
  }
}
