import 'package:flutter/material.dart';
import 'package:todo/add_task_screen.dart'; // Correct import for AddTaskScreen
//import 'all_tasks_screen.dart';
import 'pending_tasks_screen.dart';
import 'upcoming_tasks_screen.dart';
import 'contact_us_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final String userId;

  const DashboardScreen({Key? key, required this.username, required this.userId})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize _screens with userId passed to each screen
    _screens = [
      UpcomingTasksScreen(userId: widget.userId), // 0
      DashboardContent(userId: widget.userId, username: widget.username), // 1
      PendingTasksScreen(userId: widget.userId), // 2
      //AllTasksScreen(userId: widget.userId), // 3
      //ContactUsScreen(), // 4
    ];
  }

  void _onNavigationTapped(int index) {
    if (_selectedIndex != index) {  // Avoid unnecessary rebuilds
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context); // Close the drawer
    _onNavigationTapped(index); // Update the selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programming With Rehman"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ' + widget.username,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User ID: ' + widget.userId,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            /*ListTile(
              title: Text('Dashboard'),
              onTap: () => _onDrawerItemTapped(1), // Set index for Dashboard
            ),
            ListTile(
              title: Text('Add New Task'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(userId: widget.userId),
                  ),
                );
              },
            ),*/
            ListTile(
              title: Text('Dashboard'),
              onTap: () => _onDrawerItemTapped(1), // Set index for All Tasks
            ),
            ListTile(
              title: Text('Pending Tasks'),
              onTap: () => _onDrawerItemTapped(2), // Set index for Pending Tasks
            ),
            ListTile(
              title: Text('Upcoming Tasks'),
              onTap: () => _onDrawerItemTapped(0), // Set index for Upcoming Tasks
            ), 
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavigationTapped, // Use the same method for BottomNavigationBar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Upcoming Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending Tasks',
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Dashboard Content with userId parameter
class DashboardContent extends StatelessWidget {
  final String userId;
  final String username;

  const DashboardContent({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to $username!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "User ID: $userId",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCard(context, Icons.task, "All Tasks"),
              _buildCard(context, Icons.pending, "Pending"),
              _buildCard(context, Icons.calendar_today, "Upcoming"),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Quick Actions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Add Task Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskScreen(userId: userId),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add New Task"),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Contact Us Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUsScreen(userId: userId),
                      ),
                    );
                  },
                  icon: Icon(Icons.contact_mail),
                  label: Text("Contact Us"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title) {
  double cardSize = MediaQuery.of(context).size.width * 0.25; // 40% of screen width

  return GestureDetector(
    onTap: () {
      // Add navigation to respective screen if needed
    },
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for aesthetics
      ),
      child: Container(
        width: cardSize,
        height: cardSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: cardSize * 0.4, // Make icon 40% of card size
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

}
