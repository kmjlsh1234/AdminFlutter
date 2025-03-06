import 'package:json_annotation/json_annotation.dart';

import '../../constants/admin/admin_status.dart';
part 'admin_mod_status_param.g.dart';
@JsonSerializable(includeIfNull: false)
class AdminModStatusParam{
  final AdminStatus status;

  AdminModStatusParam({required this.status});
  Map<String, dynamic> toJson() => _$AdminModStatusParamToJson(this);
}