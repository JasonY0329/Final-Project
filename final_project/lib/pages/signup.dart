
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
    final primaryColor = Colors.red.shade600; // Primary red color
    final backgroundColor = Colors.grey.shade100; // Background color for the form
    final buttonTextColor = Colors.white; // Button text color

    return Scaffold(
      backgroundColor: Colors.grey.shade300, // Gray background for the entire screen
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Sign Up',
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
              // Full Name TextField
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
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
              const SizedBox(height: 12),
              // Phone Number TextField
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
              const SizedBox(height: 12),
              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              const SizedBox(height: 12),
              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              // Sign Up Button
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
                      bool isVerified = false;
                      while (!isVerified) {
                        await Future.delayed(const Duration(seconds: 3));
                        // await user.reload(); // Reload user information
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
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: 18, // Increased font size
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




// import 'package:final_project/pages/homepage.dart';
// import 'package:flutter/material.dart';
// import '../validators.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''),
//         flexibleSpace: const Center(
//           child: Padding(
//             padding: EdgeInsets.only(top: 30.0),
//             child: Text(
//               'Sign Up',
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
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//             ),
//             TextField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text.trim();
//                 final password = passwordController.text.trim();
//                 final fullName = nameController.text.trim();
//                 final phoneNumber = phoneController.text.trim();

//                 if (!isValidEmail(email)) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Invalid email format')),
//                   );
//                   return;
//                 }

//                 if (fullName.isEmpty || phoneNumber.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please fill out all fields.')),
//                   );
//                   return;
//                 }

//                 try {
//                   // Create a new user
//                   final userCredential =
//                       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                     email: email,
//                     password: password,
//                   );

//                   // Get the current user
//                   final user = userCredential.user;

//                   if (user != null) {
//                     // Save user details to Firestore
//                     await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(user.uid)
//                         .set({
//                       'uid': user.uid,
//                       'email': email,
//                       'name': fullName,
//                       'phone': phoneNumber,
//                       'createdAt': FieldValue.serverTimestamp(),
//                     });

//                     // Send a verification email
//                     await user.sendEmailVerification();

//                     // Prompt the user to check their email
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text(
//                               'Verification email sent. Please check your email.')),
//                     );

//                     // Wait for the user to verify their email
//                     bool isVerified = false;
//                     while (!isVerified) {
//                       await Future.delayed(const Duration(seconds: 3));
//                       // await user.reload(); // Reload user information
//                       isVerified = user.emailVerified; // Check if verified
//                     }

//                     // If verified, display a success message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Sign up successfully')),
//                     );

//                     // Navigate to home page
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomePage(
//                           userData: {
//                             'uid': user.uid,
//                             'email': email,
//                             'name': fullName,
//                             'phone': phoneNumber,
//                           },
//                         ),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   // Display error message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Sign up failure: ${e.toString()}')),
//                   );
//                 }
//               },
//               child: const Text('Sign up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
