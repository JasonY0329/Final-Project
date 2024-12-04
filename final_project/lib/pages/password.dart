import 'package:flutter/material.dart';
import '../validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

// View for reset password
class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.red.shade600; // Primary red color
    final backgroundColor = Colors.grey.shade100; // Form background color
    final buttonTextColor = Colors.white; // Button text color

    return Scaffold(
      backgroundColor: Colors.grey.shade300, // Gray background for the entire screen
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Password Reset',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor, // Form background color
            borderRadius: BorderRadius.circular(12), // Rounded corners for the form
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Light shadow
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Form takes only necessary vertical space
            children: [
              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white, // White background for the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Send Password Reset Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Red button color
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (!isValidEmail(email)) {
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
                      const SnackBar(
                        content: Text(
                            'Password reset email has been sent. Please check your email.'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email sent failure: ${e.toString()}'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Send Password Reset Email',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: 18, // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


    





// import 'package:flutter/material.dart';
// import '../validators.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // View for reset password
// class ForgotPasswordScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();

//   ForgotPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''), 
//         flexibleSpace: const Center(
//           child: Padding(
//             padding: EdgeInsets.only(top: 30.0),
//             child: Text(
//               'Password reset',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Please input your email'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text.trim();
//                 if (!isValidEmail(email)) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Invalid email format')),
//                   );
//                   return;
//                 }
//                 // Forget password logic
//                  try {
//                       await FirebaseAuth.instance.sendPasswordResetEmail(
//                         email: emailController.text.trim(),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Password reset email has been sent')));
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Email sent failure：${e.toString()}')));
//                     }
//               },
//               child: const Text('Send password reset confirmation email'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
