// home_screen.dart
import 'package:flutter/material.dart';

class AllTasksScreen extends StatelessWidget {
  final String userId;

  const AllTasksScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'All Tasks List here User id - $userId',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
