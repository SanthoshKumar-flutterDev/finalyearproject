
class PortfolioTemplate {
  final String id;
  final String name;
  final String previewImage;
  final String route; // Route for the generated page

  PortfolioTemplate({
    required this.id,
    required this.name,
    required this.previewImage,
    required this.route,
  });
}


final List<PortfolioTemplate> templates = [
  PortfolioTemplate(
    id: "template1",
    name: "Modern Portfolio",
    previewImage: "assets/templateimage/img.png", // Replace with actual URL
    route: "/template1",
  ),
  PortfolioTemplate(
    id: "template2",
    name: "Creative Portfolio",
    previewImage: "assets/templateimage/img.png", // Replace with actual URL
    route: "/template2",
  ),
  PortfolioTemplate(
    id: "template3",
    name: "Minimal Portfolio",
    previewImage: "assets/templateimage/img.png", // Replace with actual URL
    route: "/template3",
  ),
];
