import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the start (left)
          children: [
            // Spacer to push content down
            Spacer(),

            // Large Image
            Center(
              child: Image.asset(
                'assets/2.png', // Add your image here
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),

            // Welcome and description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
                children: [
                  Text(
                    'ยินดีต้อนรับ!!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  Text(
                    'แอพนี้ช่วยให้คุณติดตามกิจกรรมของคณะนิติศาสตร์อย่างมีประสิทธิภาพ ตั้งแต่การประชุม การสัมมนา จนถึงกิจกรรมอื่นๆ คุณจะไม่พลาดทุกเหตุการณ์สำคัญ',
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Login button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'เข้าสู่รบบ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Signup button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigate to RegisterPage
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
