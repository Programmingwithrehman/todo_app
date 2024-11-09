import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final String userId;

  const ContactUsScreen({super.key, required this.userId});

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
    const email = 'abc@gmail.com';
    final subject = 'Contact Request from User $userId';
    const body = 'Hello, I would like to contact you for further details.';
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
        title: const Text('Contact Us', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // This will take you back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Get in Touch',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromRGBO(44, 34, 169, 1)),
              ),
              const SizedBox(height: 20),
              Text(
                'We are here to help you. Reach out to us via WhatsApp or Email!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone_android, color: Colors.white),
                label: const Text('Contact via WhatsApp',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _launchWhatsApp,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.email, color: Colors.white),
                label: const Text('Contact via Email', style: TextStyle(color: Colors.white,)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _launchEmail,
              ),
              const SizedBox(height: 50),
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
