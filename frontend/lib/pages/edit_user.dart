import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'package:frontend/models/user_model.dart';

class EditUser extends StatefulWidget {
  final UserModel user;

  const EditUser({required this.user});

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _nameController;
  late TextEditingController _lnameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController; // เพิ่ม TextEditingController สำหรับ role
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _lnameController = TextEditingController(text: widget.user.lname ?? '');
    _emailController = TextEditingController(text: widget.user.email);
    _roleController = TextEditingController(text: widget.user.role); // กำหนดค่าเริ่มต้นของ role
  }

  Future<void> _updateUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // เรียกใช้ฟังก์ชัน updateUser โดยส่งค่า role เพิ่มเข้าไป
      await AuthService().updateUser(
        widget.user.id,
        _nameController.text,
        _lnameController.text,
        _roleController.text, // ส่ง role ด้วย
        _emailController.text,
      );

      // Navigate back or show success message
      Navigator.pop(context, true);
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลผู้ใช้"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Name Field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "ชื่อ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // User Last Name Field
                  TextField(
                    controller: _lnameController,
                    decoration: InputDecoration(
                      labelText: "นามสกุล",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // User Email Field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "อีเมล",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // User Role Field (เพิ่มฟิลด์ Role)
                  TextField(
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: "บทบาท",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateUser,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "บันทึกข้อมูล",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
