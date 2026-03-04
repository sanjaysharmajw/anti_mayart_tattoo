class Tattoo {
  final String id;
  final String title;
  final String image;

  Tattoo({
    required this.id,
    required this.title,
    required this.image,
  });

  factory Tattoo.fromJson(Map<String, dynamic> json) {
    return Tattoo(
      id: json['_id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
