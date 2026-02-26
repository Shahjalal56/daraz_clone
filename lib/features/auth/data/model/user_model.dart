import '../../domain/entity/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        firstName: json['name']['firstname'],
        lastName: json['name']['lastname'],
        phone: json['phone'],
        city: json['address']['city'],
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        city: city,
      );
}
