import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Ensure this dependency is in your pubspec.yaml
import 'package:todo/login_screen.dart';
import 'package:todo/register_screen.dart';

void main() {
  runApp(MyApp());
}
// This To-Do app was developed by Programming with Rehman.

class MyApp extends StatelessWidget {
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
    await Future.delayed(Duration(seconds: 5));
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
          title: Text("No Internet Connection"),
          content: Text("Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnection(); // Retry the connection
              },
              child: Text("Retry"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Exit"),
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
            SizedBox(height: 20), // Space between logo and loading indicator
            CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}

// This To-Do app was developed by Programming with Rehman.

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top 80% area with an image
          Expanded(
            flex: 6, // 80% of the screen
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/homescreen.png'), // Change to your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Remaining area for heading, paragraph, and buttons
          Expanded(
            flex: 4, // 20% of the screen
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PWR ToDo App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Manage your tasks efficiently with our app. Developed by Programming With Rehman!',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Add your login action here
                      Navigator.push(
                        context,
                         MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width button
                    ),
                  ),
                  SizedBox(height: 10),
                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      // Add your register action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width button
                    ),
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
