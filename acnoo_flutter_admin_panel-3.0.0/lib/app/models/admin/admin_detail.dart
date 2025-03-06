import 'package:acnoo_flutter_admin_panel/app/constants/admin/admin_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'admin_detail.g.dart';

@JsonSerializable(includeIfNull: true)
class AdminDetail {
  final int adminId;
  final int? roleId;
  final String? roleName;
  final AdminStatus status;
  final String email;
  final String name;
  final String mobile;
  final DateTime? loginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminDetail({
    required this.adminId,
    required this.roleId,
    required this.roleName,
    required this.status,
    required this.email,
    required this.name,
    required this.mobile,
    required this.loginAt,
    required this.createdAt,
    required this.updatedAt
  });

  factory AdminDetail.fromJson(Map<String, dynamic> json) => _$AdminDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AdminDetailToJson(this);
}