class Portfolio {
  final String id;
  final String title;
  final String image;

  Portfolio({
    required this.id,
    required this.title,
    required this.image,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['_id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
