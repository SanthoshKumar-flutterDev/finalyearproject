import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../portfoliotemplates/template_one.dart';

class GeneratedPortfolioPage extends StatefulWidget {
  final String userId;
  final String templateId;

  const GeneratedPortfolioPage({required this.userId, required this.templateId, Key? key})
      : super(key: key);

  @override
  _GeneratedPortfolioPageState createState() => _GeneratedPortfolioPageState();
}

class _GeneratedPortfolioPageState extends State<GeneratedPortfolioPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('user').doc(widget.userId).get();

    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>;
      });
    } else {
      setState(() {
        userData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Portfolio")),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Loading state
          : _buildTemplate(widget.templateId), // Load the correct template UI
    );
  }

  /// Dynamically build UI based on selected template
  Widget _buildTemplate(String templateId) {
    switch (templateId) {
      case "1":
        return ProfilePageAlignment();
      case "2":
        return _templateTwo();
      case "3":
        return _templateThree();
      default:
        return Center(child: Text("Error: Template not found"));
    }
  }



  /// Template 2 UI
  Widget _templateTwo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Template two"),
        Text("🌟 ${userData!['name']}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Text("📌 ${userData!['location']}", style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
        SizedBox(height: 15),
        Text("💼 ${userData!['designation']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        SizedBox(height: 20),
        Text("✨ ${userData!['description']}", textAlign: TextAlign.justify),
      ],
    );
  }

  /// Template 3 UI
  Widget _templateThree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Template Three"),
        Text(userData?['name'] ?? 'No Name', // Provide default value
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text(userData?['designation'] ?? 'No Designation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(userData?['description'] ?? 'No description available',
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

}
