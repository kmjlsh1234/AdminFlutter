import 'package:acnoo_flutter_admin_panel/app/constants/shop/bundle/bundle_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bundle_mod_status_param.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleModStatusParam{
  final BundleStatus status;

  BundleModStatusParam({required this.status});
  factory BundleModStatusParam.fromJson(Map<String, dynamic> json) => _$BundleModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleModStatusParamToJson(this);
}