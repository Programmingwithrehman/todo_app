// home_screen.dart
import 'package:flutter/material.dart';

class AllTasksScreen extends StatelessWidget {
  final String userId;

  const AllTasksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'All Tasks List here User id - $userId',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
