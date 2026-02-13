import 'package:flutter/material.dart';
import 'package:hotelowner/login/loginpage.dart'; // Keep your actual import

class GetStartpage extends StatelessWidget {
  const GetStartpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for full responsiveness
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF312C51), // Your brown/tan background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top spacing - responsive (about 10% of height)
              SizedBox(height: height * 0.10),

              // Main title text
              Text(
                'We make you feel \nLike Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      width * 0.10, // Scales nicely: ~35-40 on most phones
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              // Flexible spacer to push button to bottom
              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Loginpage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom spacing for comfort (safe area + extra)
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
