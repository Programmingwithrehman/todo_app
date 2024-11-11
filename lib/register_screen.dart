import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'dart:convert'; // Add this import for JSON decoding

// This To-Do app was developed by Programming with Rehman.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  bool isLoading = false; // Loading state

  // Function to register a new user
  Future<void> _registerUser() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://thedailyearnings.online/flutter_to-do-app/users_create.php'),
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Successful registration
        final responseData = json.decode(response.body);
        // Handle success response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Try different Username and Email')),
        );
        // Optionally, navigate to another screen
        Navigator.pop(context); // Go back to login screen or home screen
      } else {
        // Handle error response
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Registration failed')),
        );
      }
    } catch (error) {
      // Handle any other errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
  }

// This To-Do app was developed by Programming with Rehman.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Register form
          Center(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                   
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white), 
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            username = value;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white), 
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white), 
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : () { // Disable button while loading
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50), // Full-width button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator() // Show loading indicator
                              : Text('Register'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Navigate back to the previous screen
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.white), // White text
                          ), 
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This To-Do app was developed by Programming with Rehman.
