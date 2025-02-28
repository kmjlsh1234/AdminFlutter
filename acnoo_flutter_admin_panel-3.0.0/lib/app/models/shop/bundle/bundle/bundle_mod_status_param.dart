import 'package:json_annotation/json_annotation.dart';
part 'bundle_mod_status_param.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleModStatusParam{
  final String status;

  BundleModStatusParam({required this.status});
  factory BundleModStatusParam.fromJson(Map<String, dynamic> json) => _$BundleModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleModStatusParamToJson(this);
}