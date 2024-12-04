import 'package:final_project/pages/signin.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isNavigating = false; // Flag to prevent multiple navigations

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with 1.5 seconds duration
    _controller = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 500), // 1.5 seconds
      vsync: this,
    );

    // Define the animation curve
    _animation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0), // Start off-screen to the left
      end: Offset.zero, // End at the center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth curve
      ),
    );

    // Start the animation
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isNavigating) {
        // Wait for 1.5 seconds before navigating to the next page
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          if (!_isNavigating) _navigateToSigninPage();
        });
      }
    });
  }

  void _navigateToSigninPage() {
    if (!_isNavigating) {
      _isNavigating = true; // Mark as navigating
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, // Change the background color as needed
      body: Stack(
        children: [
          // Splash Screen Content
          Center(
            child: SlideTransition(
              position: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.jpg', // Replace with your logo's path
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // App Title
                  const Text(
                    'FoodieGo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Skip Button
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: _navigateToSigninPage, // Skip immediately
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:final_project/pages/signin.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the animation controller
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     // Define the animation curve
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );

//     // Start the animation
//     _controller.forward();
//     _controller.addStatusListener((status){
//       if (status == AnimationStatus.completed){
//         _navigateToSigninPage();
//       }
//     });

//     // Navigate to HomePage after animation ends
//     // Future.delayed(const Duration(seconds: 10), () {
//     //   _navigateToSigninPage();
//     // });
//   }

//   void _navigateToSigninPage() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => SignInScreen()),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey, // Change the background color as needed
//       body: Stack(
//         children: [
//           // Splash Screen Content
//           Center(
//             child: FadeTransition(
//               opacity: _animation,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image.asset(
//                       'assets/images/logo.jpg', // Replace with your logo's path
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // App Title
//                   const Text(
//                     'FoodieGo',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Skip Button
//           Positioned(
//             top: 40,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: _navigateToSigninPage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.grey,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text('Skip'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

