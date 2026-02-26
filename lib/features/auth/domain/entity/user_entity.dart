class UserEntity {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
  });

  String get fullName => '$firstName $lastName';
}
