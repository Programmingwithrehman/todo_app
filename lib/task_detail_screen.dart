import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'update_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String userId;
  final String taskId;
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String status;

  const TaskDetailScreen({
    super.key,
    required this.userId,
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.status,
  });

  // Method to delete task using API
  Future<void> _deleteTask(BuildContext context) async {
    final url = Uri.parse('http://localhost/flutter_to-do-app/delete_task.php?taskId=$taskId');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        // Assuming the response returns JSON {"message": "Task removed"}
        //final responseData = response.body;
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task removed successfully')),
        );
        
        // Go back to the previous screen
        Navigator.pop(context);
      } else {
        // Show error message if the status code is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove task. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Unable to delete task')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // This will take you back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 34, 169, 1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(44, 34, 169, 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Task Details Section
              buildDetailRow('User ID', userId,),
              buildDetailRow('Task ID', taskId),
              buildDetailRow('Priority', priority),
              buildDetailRow('Due Date', dueDate),
              buildDetailRow('Status', status),

              const SizedBox(height: 20),

              // Task Description
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(44, 34, 169, 1),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 30),

              // Delete Button 
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Delete Task',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteTask(context); // Call delete function
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 20), // Space between buttons
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Update Task',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // Add your add task functionality here
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTaskDetailScreen(
                            userId: userId,
                            taskId: taskId,
                            title: title,
                            description: description,
                            priority: priority,
                            dueDate: DateTime.parse(dueDate),
                            status: status,
                          ),
                        ),
                      );
                      },
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build task detail row with label and value
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(44, 34, 169, 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
