class User {
  final String id;
  final String? email;
  final String? phone;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  User({
    required this.id,
    this.email,
    this.phone,
    this.createdAt,
    this.metadata,
  });
}
