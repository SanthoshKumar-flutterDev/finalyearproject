import 'package:flutter/material.dart';

class Helppage extends StatelessWidget {
  const Helppage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: const [
            HelpTile(
              question: "How do I create my portfolio?",
              answer: "Go to 'Start Building', fill in your details step-by-step, and publish.",
            ),
            HelpTile(
              question: "Can I edit my portfolio after publishing?",
              answer: "Yes, go to 'Profile Page' to update your data and republish.",
            ),
            HelpTile(
              question: "Where is my data stored?",
              answer: "Your data is securely stored in Firebase Firestore under your user ID.",
            ),
            HelpTile(
              question: "How can I contact support?",
              answer: "Send us an email at support@portfoliobuilder.com.",
            ),
          ],
        ),
      ),
    );
  }
}

class HelpTile extends StatelessWidget {
  final String question;
  final String answer;

  const HelpTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [Padding(padding: const EdgeInsets.all(8.0), child: Text(answer))],
    );
  }
}
