import 'package:json_annotation/json_annotation.dart';
part 'privilege.g.dart';

@JsonSerializable(includeIfNull: false)
class Privilege {
  final int id;
  final int? menuId;
  final String? menuName;
  final String privilegeName;
  final String privilegeCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Privilege({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.privilegeName,
    required this.privilegeCode,
    required this.createdAt,
    required this.updatedAt
  });

  factory Privilege.fromJson(Map<String, dynamic> json) => _$PrivilegeFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeToJson(this);
}