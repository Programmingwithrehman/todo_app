import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Ensure this dependency is in your pubspec.yaml
import 'package:todo/login_screen.dart';
import 'package:todo/register_screen.dart';

void main() {
  runApp(MyApp());
}
// This To-Do app was developed by Programming with Rehman.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: SplashScreen(),
    );
  }
}

// This To-Do app was developed by Programming with Rehman.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Show the splash screen for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    _checkConnection();
  }

// This To-Do app was developed by Programming with Rehman.

  Future<void> _checkConnection() async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool isConnected = connectivityResult != ConnectivityResult.none;

    if (isConnected) {
      // Proceed to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show offline message
      _showOfflineMessage();
    }
  }

  void _showOfflineMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnection(); // Retry the connection
              },
              child: const Text("Retry"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your logo path
              width: 150, // Set the desired width
              height: 150, // Set the desired height
            ),
            const SizedBox(height: 20), // Space between logo and loading indicator
            const CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}

// This To-Do app was developed by Programming with Rehman.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Stack(
    children: [
      // Background image covering the entire screen
      Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'), // Your image
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      // Content overlay on top of the background
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,  // Position content at the bottom
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'PWR ToDo App',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // Ensure text is visible on the background
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage your tasks efficiently with our app. Developed by Programming With Rehman!',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),  // White text for visibility
              ),
              const SizedBox(height: 20),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Full width button
                ),
                child: Text('Login'),
              ),
              const SizedBox(height: 10),
              // Register Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to register screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Full width button
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

  }
}
