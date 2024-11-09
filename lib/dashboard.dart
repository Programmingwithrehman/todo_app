import 'package:flutter/material.dart';
import 'package:todo/add_task_screen.dart'; // Correct import for AddTaskScreen
//import 'all_tasks_screen.dart';
import 'pending_tasks_screen.dart';
import 'upcoming_tasks_screen.dart';
import 'contact_us_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final String userId;

  const DashboardScreen({super.key, required this.username, required this.userId});

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
  // Method to refresh the content
  Future<void> _refreshContent() async {
    // Implement your logic to refresh content here
    setState(() {
      // Rebuild the screen by setting the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programming With Rehman", style: TextStyle(color: Color.fromRGBO(44, 34, 169, 1)),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(44, 34, 169, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.username}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'User ID: ${widget.userId}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
              title: const Text('Dashboard'),
              onTap: () => _onDrawerItemTapped(1), // Set index for All Tasks
            ),
            ListTile(
              title: const Text('Pending Tasks'),
              onTap: () => _onDrawerItemTapped(2), // Set index for Pending Tasks
            ),
            ListTile(
              title: const Text('Upcoming Tasks'),
              onTap: () => _onDrawerItemTapped(0), // Set index for Upcoming Tasks
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Body content
          RefreshIndicator(
            onRefresh: _refreshContent, // Trigger refresh
            child: _screens[_selectedIndex], // Display the selected screen
          ),
          //_screens[_selectedIndex],
        ],
      ),
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

  const DashboardContent({super.key, required this.userId, required this.username});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    //return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to $username!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),
          ),
          const SizedBox(height: 20),
          Text(
            "User ID: $userId",
            style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 248, 247, 247)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCard(context, Icons.task, "All Tasks"),
              _buildCard(context, Icons.pending, "Pending"),
              _buildCard(context, Icons.calendar_today, "Upcoming"),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
          ),
          const SizedBox(height: 10),
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
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Task"),
                ),
              ),
              const SizedBox(width: 10),
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
                  icon: const Icon(Icons.contact_mail),
                  label: const Text("Contact Us"),
                ),
              ),
              const SizedBox(height: 20),
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
        child: SizedBox(
          width: cardSize,
          height: cardSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: cardSize * 0.4, // Make icon 40% of card size
                color: const Color.fromRGBO(44, 34, 169, 1),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
