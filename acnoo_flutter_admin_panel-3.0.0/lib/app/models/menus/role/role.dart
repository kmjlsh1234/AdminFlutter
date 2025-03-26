import 'package:json_annotation/json_annotation.dart';
part 'role.g.dart';

@JsonSerializable(includeIfNull: false)
class Role {
  final int id;
  final String roleName;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Role({
    required this.id,
    required this.roleName,
    required this.description,
    required this.createdAt,
    required this.updatedAt
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}