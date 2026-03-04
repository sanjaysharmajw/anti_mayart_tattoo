class Contact {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String message;

  Contact({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.message,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      message: json['message'] ?? '',
    );
  }
}
