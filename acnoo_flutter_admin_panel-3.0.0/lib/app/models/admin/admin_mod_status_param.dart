import 'package:json_annotation/json_annotation.dart';
part 'admin_mod_status_param.g.dart';
@JsonSerializable(includeIfNull: false)
class AdminModStatusParam{
  final String status;

  AdminModStatusParam({required this.status});
  Map<String, dynamic> toJson() => _$AdminModStatusParamToJson(this);
}