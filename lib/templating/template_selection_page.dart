import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'portfolio_templates.dart';

class TemplateSelectionPage extends StatelessWidget {
  @override

  void generatePortfolio(BuildContext context, PortfolioTemplate template) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      String uniqueId = "${uid}_${DateTime.now().millisecondsSinceEpoch}";

      // ✅ Pass template as an object
      context.go("/portfolio/$uniqueId", extra: {'userData': userData, 'template': template});
    } else {
      print("User data not found!");
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a Template")),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(template.previewImage, height: 150, width: double.infinity, fit: BoxFit.cover), // Show preview
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    template.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () => generatePortfolio(context, template),
                        child: Text("Generate"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
