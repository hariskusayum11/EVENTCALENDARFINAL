import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/edit_user.dart'; // Import your edit user page

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await AuthService().getAllUsers(); // Assuming getAllUsers fetches user data
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await AuthService().deleteUser(userId); // Assuming deleteUser handles the deletion of a user
      setState(() {
        _users.removeWhere((user) => user.id == userId);
      });
    } catch (e) {
      // Handle errors
    }
  }

  void _editUser(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUser(user: user), // Navigate to the edit user page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลผู้ใช้"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Banner Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เว็บแอปพลิเคชันปฏิทินกิจกรรมคณะนิติศาสตร์',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'คุณสามารถดู จัดเก็บ และแก้ไขปฏิทินกิจกรรมของคุณได้ในแอพพลิเคชันนี้!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.calendar_today, size: 50, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                // Title Text with Gradient Underline
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'ข้อมูลผู้ใช้',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.blue, Colors.teal],
                          tileMode: TileMode.mirror,
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // List of Users
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two cards per row
                        childAspectRatio: 1.5, // Adjust aspect ratio for vertical cards
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return UserCard(
                          user: user,
                          onDelete: () => _deleteUser(user.id),
                          onEdit: () => _editUser(user),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'เพิ่มข้อมูล'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'ข้อมูลส่วนตัว'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'ข้อมูลผู้ใช้'),
        ],
        currentIndex: 2, // active tab is the user info
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }
}
class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const UserCard({
    required this.user,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleAvatar on top
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            SizedBox(height: 10), // Space between avatar and text
            Text(
              '${user.name} ${user.lname ?? ''}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              user.email,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Action buttons
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter, // Align buttons at the bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, size: 14), // Reduced icon size
                      label: Text('แก้ไข', style: TextStyle(fontSize: 12)), // Reduced font size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Set the background color of the edit button
                        padding: EdgeInsets.symmetric(horizontal: 8), // Reduced padding
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, size: 14), // Reduced icon size
                      label: Text('ลบ', style: TextStyle(fontSize: 12)), // Reduced font size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Set the background color of the delete button
                        padding: EdgeInsets.symmetric(horizontal: 8), // Reduced padding
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
