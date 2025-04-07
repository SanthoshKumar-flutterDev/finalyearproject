import 'package:flutter/material.dart';

class features extends StatelessWidget {
  const features({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Features")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: const [
            FeatureTile(title: "📄 Resume Builder", description: "Easily create and customize your resume."),
            FeatureTile(title: "🎨 Portfolio Templates", description: "Choose from modern and responsive templates."),
            FeatureTile(title: "☁️ Firebase Hosting", description: "Publish your portfolio with a unique URL."),
            FeatureTile(title: "📝 Editable Profile", description: "Update personal and professional info anytime."),
            FeatureTile(title: "🕒 History Tracking", description: "Maintain a history of generated portfolios."),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String description;

  const FeatureTile({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
