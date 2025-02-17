import 'package:json_annotation/json_annotation.dart';
part 'admin_mod_status_param.g.dart';
@JsonSerializable()
class AdminModStatusParam{
  final String status;

  AdminModStatusParam(this.status);
  Map<String, dynamic> toJson() => _$AdminModStatusParamToJson(this);
}