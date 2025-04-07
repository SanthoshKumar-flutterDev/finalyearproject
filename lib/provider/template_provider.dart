import 'package:flutter/material.dart';

class TemplateProvider extends ChangeNotifier {
  final List<TemplateModel> templates = [
    TemplateModel(
      id: "1",
      title: "Mild Theme for Developers",
      imagePath: "assets/templateimage/templateone.png",
      description: "A mild-colored theme portfolio for developers",
      route: "/aboutpage",
    ),
    TemplateModel(
      id: "2",
      title: "Modern Portfolio",
      imagePath: "assets/templateimage/img_2.png",
      description: "A modern, stylish portfolio for professionals",
      route: "/helppage",
    ),
    TemplateModel(
      id: "3",
      title: "Minimalist Portfolio",
      imagePath: "assets/templateimage/img_2.png",
      description: "A clean and minimalist portfolio template",
      route: "/features",
    ),
  ];

  TemplateModel? selectedTemplate;

  void selectTemplate(TemplateModel template) {
    selectedTemplate = template;
    notifyListeners();
  }
}


class TemplateModel {
  final String id;
  final String title;
  final String imagePath;
  final String description;
  final String route; // Route to navigate when generating

  TemplateModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.route,
  });
}
