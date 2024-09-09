import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _hasError = false;

  // Handle the login process
void _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasError = false;
    });

    try {
      // พิมพ์ข้อมูลก่อนส่งไปยังเซิร์ฟเวอร์
      print('Username: ${_usernameController.text}');
      print('Password: ${_passwordController.text}');

      // เรียกใช้ AuthService เพื่อล็อกอิน
      final user = await AuthService().login(
        _usernameController.text,
        _passwordController.text,
      );

      // พิมพ์ข้อมูลของผู้ใช้ที่ได้จากการล็อกอิน
      print('Login successful, user role: ${user?.role}');

      if (user != null) {
        // ตรวจสอบบทบาทผู้ใช้และนำไปยังหน้าที่เหมาะสม
        if (user.role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
          _hasError = true;
          _passwordController.clear();
        });
      }
    } catch (error) {
      // พิมพ์ข้อความ error ที่ได้รับ
      print('Login error: $error');

      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ: $error';
        _hasError = true;
        _passwordController.clear();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  // Navigate to the registration page
  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  // Refresh form to clear any input
  Future<void> _onRefresh() async {
    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _errorMessage = null;
      _hasError = false;
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate a short refresh delay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when the user taps outside the form fields
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'เรายินดีที่ได้พบคุณอีกครั้ง กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อผู้ใช้',
                                  suffixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _hasError
                                      ? 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'
                                      : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อผู้ใช้';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 24),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'รหัสผ่าน',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _hasError
                                      ? 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'
                                      : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                  return null;
                                },
                              ),
                              if (_errorMessage != null) ...[
                                SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                      )
                                    : Text('เข้าสู่ระบบ'),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _navigateToRegister,
                        child: Text(
                          'ยังไม่มีบัญชี? สมัครสมาชิก',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
