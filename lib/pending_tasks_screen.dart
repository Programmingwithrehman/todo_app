import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_detail_screen.dart';

class PendingTasksScreen extends StatefulWidget {
  final String userId;

  const PendingTasksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PendingTasksScreenState createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  late Future<List<Task>> _pendingTasks;

  @override
  void initState() {
    super.initState();
    _pendingTasks = fetchPendingTasks(widget.userId);
  }

  Future<List<Task>> fetchPendingTasks(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost/flutter_to-do-app/pending.php?userId=$userId'), // Use 10.0.2.2 for Android emulator
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.isEmpty ? [] : data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load pending tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Tasks"),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false, // Removes the back arrow
        centerTitle: true, 
      ),
      body: FutureBuilder<List<Task>>(
        future: _pendingTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.description,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              SizedBox(width: 5),
                              Text(
                                'Due: ${task.dueDate}',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(width: 15),
                              Icon(Icons.priority_high, size: 14, color: Colors.red),
                              SizedBox(width: 5),
                              Text(
                                'Priority: ${task.priority}',
                                style: TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: task.status == 'Pending' ? Colors.grey : Colors.green,
                    ),
                    onTap: () {
                      // Navigate to TaskDetailScreen on item tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(
                            userId: widget.userId,
                            taskId: task.id,
                            title: task.title,
                            description: task.description,
                            priority: task.priority,
                            dueDate: task.dueDate,
                            status: task.status,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No pending tasks found.'));
          }
        },
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      dueDate: json['due_date'],
      status: json['status'],
    );
  }
}
