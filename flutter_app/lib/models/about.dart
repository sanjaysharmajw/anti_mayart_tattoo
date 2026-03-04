class About {
  final String id;
  final String title;
  final String description;

  About({
    required this.id,
    required this.title,
    required this.description,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
