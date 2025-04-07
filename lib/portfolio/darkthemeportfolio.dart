import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkThemePortfolio extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DarkThemePortfolio({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(userData: userData),
            HeroSection(userData: userData),
          ],
        ),
      ),
    );
  }
}

// ✅ Custom Text Widget
class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color fontColor;

  const CustomText({
    Key? key,
    required this.text,
    required this.fontWeight,
    required this.fontSize,
    required this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: fontColor),
    );
  }
}

// ✅ Custom AppBar
class CustomAppBar extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CustomAppBar({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
      color: Color(0xFF141421), // Dark background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dynamic Name
          CustomText(
            text: userData['name'] ?? "User Name",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontColor: Colors.deepPurple, // Highlighted text color
          ),

          // Navigation Menu
          Row(
            children: [
              _navItem("Home", isActive: true),
              _navItem("About Me"),
              _navItem("Projects"),
              _navItem("Contact"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title, {bool isActive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isActive ? Colors.deepPurple : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// ✅ Hero Section
class HeroSection extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HeroSection({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Color(0XFF1a1a29),
      height: height * 0.6,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left Side - Text Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Hello, I am",
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontColor: Colors.white70,
              ),
              SizedBox(height: 10),
              CustomText(
                text: userData['name'] ?? "Your Name",
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
                fontColor: Colors.white,
              ),
              SizedBox(height: 10),
              CustomText(
                text: userData['designation'] ?? "Your Profession",
                fontWeight: FontWeight.normal,
                fontSize: 18.sp,
                fontColor: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
