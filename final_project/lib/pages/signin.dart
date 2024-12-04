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
    final buttonTextColor = Colors.white;
    final primaryColor = Colors.red.shade600; // Primary red color
    final backgroundColor = Colors.grey.shade100; // Background color for the form

    return Scaffold(
      backgroundColor: Colors.grey.shade300, // Gray background for the entire screen
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the logo
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.jpg'), // Path to the logo image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Form container
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  children: [
                    // Sign In title
                    const Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email text field
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
                    // Password text field
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
                    // Sign In button
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

                        if (!isValidEmail(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid email format')),
                          );
                          return;
                        }

                        try {
                          final userCredential =
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          final user = userCredential.user;

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sign-in failed. Please try again.')),
                            );
                            return;
                          }

                          if (!user.emailVerified) {
                            await user.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Email not verified. A verification email has been sent. Please verify and try again.',
                                ),
                              ),
                            );
                            await FirebaseAuth.instance.signOut();
                            return;
                          }

                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();

                          if (userDoc.exists && userDoc.data() != null) {
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
                        style: TextStyle(color: buttonTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),
                        
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Forgot password and sign-up links
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
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
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
                            'No Account?',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
// import 'signup.dart';
// import 'homepage.dart';
// import 'password.dart';
// import '../validators.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignInScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   SignInScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final buttonTextColor = Theme.of(context).primaryColor;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Sign In')), // Center the title
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
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

//                 if (!isValidEmail(email)) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Invalid email format')),
//                   );
//                   return;
//                 }

//                 try {
//                   // Sign in the user
//                   final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//                     email: email,
//                     password: password,
//                   );

//                   final user = userCredential.user;

//                   // Ensure user is not null
//                   if (user == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Sign-in failed. Please try again.')),
//                     );
//                     return;
//                   }

//                   // Check if the user's email is verified
//                   if (!user.emailVerified) {
//                     await user.sendEmailVerification(); // Send a verification email
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           'Email not verified. A verification email has been sent. Please verify and try again.',
//                         ),
//                       ),
//                     );
//                     await FirebaseAuth.instance.signOut(); // Sign out the user
//                     return;
//                   }

//                   // Fetch user information from Firestore
//                   final userDoc = await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(user.uid) // Access the uid safely
//                       .get();

//                   if (userDoc.exists && userDoc.data() != null) {
//                     // Navigate to HomePage with user data
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomePage(
//                           userData: userDoc.data()!,
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('User data not found')),
//                     );
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Sign in failure: $e')),
//                   );
//                 }
//               },
//               child: Text(
//                 'Sign In',
//                 style: TextStyle(color: buttonTextColor),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ForgotPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       color: buttonTextColor,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignUpScreen()),
//                     );
//                   },
//                   child: Text(
//                     'No account?',
//                     style: TextStyle(
//                       color: buttonTextColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }