import 'package:hive_flutter/hive_flutter.dart';

part 'application_user.g.dart';

@HiveType(typeId: 0)
class ApplicationUser extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  ApplicationUser({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory ApplicationUser.fromJson(Map<String, dynamic> json) =>
      ApplicationUser(
        id: json['id'],
        name: json['displayName'],
        email: json['userPrincipalName'],
      );
}
