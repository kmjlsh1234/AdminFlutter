import 'package:json_annotation/json_annotation.dart';
part 'privilege_menu.g.dart';

@JsonSerializable(includeIfNull: true)
class PrivilegeMenu {
  final int menuId;
  final int? parentId;
  final String menuName;
  final int sortOrder;
  final String menuPath;
  final int privilegeId;
  final String privilegeName;
  final String privilegeCode;
  final DateTime createdAt;

  PrivilegeMenu({
    required this.menuId,
    required this.parentId,
    required this.menuName,
    required this.sortOrder,
    required this.menuPath,
    required this.privilegeId,
    required this.privilegeName,
    required this.privilegeCode,
    required this.createdAt
  });

  factory PrivilegeMenu.fromJson(Map<String, dynamic> json) => _$PrivilegeMenuFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeMenuToJson(this);
}