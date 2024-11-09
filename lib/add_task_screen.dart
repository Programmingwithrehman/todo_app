import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'dart:convert'; // Add this import for JSON decoding
import 'package:intl/intl.dart'; // Import for date formatting

class AddTaskScreen extends StatefulWidget {
  final String userId;

  const AddTaskScreen({super.key, required this.userId}); // Constructor

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String taskTitle = '';
  String taskDescription = '';
  String priority = 'Low'; // Default priority
  DateTime? dueDate; // Store due date
  String status = 'Pending'; // Default status
  bool isLoading = false; // Loading state

  // Function to add a new task
  Future<void> _addTask() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter_to-do-app/tasks.php'),
        body: {
          'user_id': widget.userId,
          'title': taskTitle,
          'description': taskDescription,
          'priority': priority,
          'due_date': dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : '',
          'status': status,
          'created_at': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Task added successfully')),
        );
        Navigator.pop(context);
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Failed to add task')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Allow scrolling for the form
            child: Column(
              children: [
                const Text(
                  'Create a New Task',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(44, 34, 169, 1)),
                    ),
                    prefixIcon: const Icon(Icons.title, color: Color.fromRGBO(44, 34, 169, 1)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    taskTitle = value;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(44, 34, 169, 1)),
                    ),
                    prefixIcon: const Icon(Icons.description, color: Color.fromRGBO(44, 34, 169, 1)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    taskDescription = value;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(44, 34, 169, 1)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      priority = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(44, 34, 169, 1)),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today, color: Color.fromRGBO(44, 34, 169, 1)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onTap: () => _selectDueDate(context),
                  controller: TextEditingController(
                    text: dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : '',
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(44, 34, 169, 1)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: ['Pending', 'Completed'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      _addTask();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5, // Add some shadow effect
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add Task', style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Color.fromRGBO(44, 34, 169, 1))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
