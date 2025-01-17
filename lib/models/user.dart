class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? json['firstName'],
      lastName: json['last_name'] ?? json['lastName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar': avatar,
    };
  }
}