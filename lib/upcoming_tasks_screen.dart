import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_detail_screen.dart';

class UpcomingTasksScreen extends StatefulWidget {
  final String userId;

  const UpcomingTasksScreen({super.key, required this.userId});

  @override
  _UpcomingTasksScreenState createState() => _UpcomingTasksScreenState();
}

class _UpcomingTasksScreenState extends State<UpcomingTasksScreen> {
  late Future<List<Task>> _upcomingTasks;

  @override
  void initState() {
    super.initState();
    _upcomingTasks = fetchUpcomingTasks(widget.userId);
  }

  Future<List<Task>> fetchUpcomingTasks(String userId) async {
    final response = await http.get(
      Uri.parse('http://localhost/flutter_to-do-app/upcomming.php?userId=$userId'), // Use 10.0.2.2 for Android emulator
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.isEmpty ? [] : data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load upcoming tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Tasks", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
        automaticallyImplyLeading: false, // Removes the back arrow
        centerTitle: true, // Centers the title
      ),
      body: FutureBuilder<List<Task>>(
        future: _upcomingTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(44, 34, 169, 1),
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
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                'Due: ${task.dueDate}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(width: 15),
                              const Icon(Icons.priority_high, size: 14, color: Colors.orange),
                              const SizedBox(width: 5),
                              Text(
                                'Priority: ${task.priority}',
                                style: const TextStyle(fontSize: 12, color: Colors.orange),
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
            return const Center(child: Text('No upcoming tasks found.'));
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
