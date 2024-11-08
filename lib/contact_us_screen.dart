import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final String userId;

  const ContactUsScreen({Key? key, required this.userId}) : super(key: key);

  // Method to launch WhatsApp with try-catch block
  void _launchWhatsApp() async {
    const phone = '+923018589509';
    const message = "Hello, I would like to contact you!";
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print("Error: $e");
      // You can also show an alert dialog to inform the user
    }
  }

  // Method to launch Email with try-catch block
  void _launchEmail() async {
    final email = 'abc@gmail.com';
    final subject = 'Contact Request from User $userId';
    final body = 'Hello, I would like to contact you for further details.';
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch Email';
      }
    } catch (e) {
      print("Error: $e");
      // You can also show an alert dialog to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get in Touch',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              Text(
                'We are here to help you. Reach out to us via WhatsApp or Email!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.phone_android, color: Colors.white),
                label: Text('Contact via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: _launchWhatsApp,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.email, color: Colors.white),
                label: Text('Contact via Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: _launchEmail,
              ),
              SizedBox(height: 50),
              Text(
                'Your User ID: $userId',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
