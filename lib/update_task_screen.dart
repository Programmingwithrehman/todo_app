import 'package:flutter/material.dart';

class UpdateTaskDetailScreen extends StatefulWidget {
  final String userId;
  final String taskId;
  final String title;
  final String description;
  final String priority;
  final DateTime dueDate;
  final String status;

  const UpdateTaskDetailScreen({
    Key? key,
    required this.userId,
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.status,
  }) : super(key: key);

  @override
  _UpdateTaskDetailScreenState createState() => _UpdateTaskDetailScreenState();
}

class _UpdateTaskDetailScreenState extends State<UpdateTaskDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  String? selectedPriority;
  String? selectedStatus;

  final List<String> priorityItems = ['Low', 'Medium', 'High'];
  final List<String> statusItems = ['Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    dueDateController = TextEditingController(text: widget.dueDate.toString());
    selectedPriority = widget.priority;
    selectedStatus = widget.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.dispose();
  }

  void _updateTask() {
    Navigator.of(context).pop(); // Close the screen after updating
  }

  void _deleteTask() {
    Navigator.of(context).pop(); // Close the screen after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task Details', style: TextStyle(color: Colors.white,),),
        backgroundColor: const Color.fromRGBO(44, 34, 169, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // This will take you back to the previous screen
          },
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Task",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(44, 34, 169, 1),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: titleController,
                label: 'Title',
                icon: Icons.title,
              ),
              _buildTextField(
                controller: descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 5,
              ),
              _buildDropdownButton(
                label: 'Priority',
                icon: Icons.flag,
                value: selectedPriority,
                items: priorityItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPriority = newValue;
                  });
                },
              ),
              _buildTextField(
                controller: dueDateController,
                label: 'Due Date',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      dueDateController.text = selectedDate.toString();
                    });
                  }
                },
              ),
              _buildDropdownButton(
                label: 'Status',
                icon: Icons.info,
                value: selectedStatus,
                items: statusItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.save,
                    label: 'Save Changes',
                    color: const Color.fromRGBO(44, 34, 169, 1),
                    onPressed: _updateTask,
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    icon: Icons.delete,
                    label: 'Delete Task',
                    color: Colors.red,
                    onPressed: () {
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
                                  _deleteTask();
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1, // default single line
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color.fromRGBO(44, 34, 169, 1)),
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromRGBO(44, 34, 169, 1)),
          const SizedBox(width: 15),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Text(label, style: const TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
