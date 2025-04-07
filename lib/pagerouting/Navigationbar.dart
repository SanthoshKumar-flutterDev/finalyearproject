import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/Homepage.dart';
import '../pages/aboutpage.dart';
import '../pages/features.dart';
import '../pages/helppage.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    features(), // Fixed class name case
    Helppage(),
    Aboutpage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Responsive Static Tab Bar
          Container(
            height: 180, // Responsive height
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Responsive padding
            color: Color(0XFF111B47),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Using Flexible to avoid overflow
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TabButton(title: "Home", index: 0, selectedIndex: _selectedIndex, onTap: _onItemTapped),
                      SizedBox(width: screenWidth * 0.02), // Dynamic spacing
                      TabButton(title: "Features", index: 1, selectedIndex: _selectedIndex, onTap: _onItemTapped),
                      SizedBox(width: screenWidth * 0.02),
                      TabButton(title: "Help", index: 2, selectedIndex: _selectedIndex, onTap: _onItemTapped),
                      SizedBox(width: screenWidth * 0.02),
                      TabButton(title: "About Us", index: 3, selectedIndex: _selectedIndex, onTap: _onItemTapped),
                    ],
                  ),
                ),
                // Buttons Row
                Row(
                  children: [
                    MyelevatedButton(color: Colors.white, title: "Generate", fontcolor: Colors.black),
                    SizedBox(width: screenWidth * 0.01), // Dynamic spacing
                    MyelevatedButton(color: Colors.white, title: "Sign In", fontcolor: Colors.black),
                  ],
                ),
              ],
            ),
          ),
          // Dynamic Page Content
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// Tab Button (No change needed)
class TabButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const TabButton({
    super.key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap(index),
      child: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index ? Colors.white : Colors.white,
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.w500,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}

// Responsive Elevated Button
class MyelevatedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Color fontcolor;

  const MyelevatedButton({super.key, required this.color, required this.title, required this.fontcolor});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {},
      child: Text(
        title,
        style: TextStyle(color: fontcolor, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 9,
        shadowColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
        minimumSize: Size(50.w, 40.h), // Button width responsive
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
