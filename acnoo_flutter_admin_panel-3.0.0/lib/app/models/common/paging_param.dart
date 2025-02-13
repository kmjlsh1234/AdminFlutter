import 'package:json_annotation/json_annotation.dart';

part 'paging_param.g.dart';
@JsonSerializable()
class PagingParam{
  final int page;
  final int limit;

  PagingParam(this.page, this.limit);
  factory PagingParam.fromJson(Map<String, dynamic> json) => _$PagingParamFromJson(json);
  Map<String, dynamic> toJson() => _$PagingParamToJson(this);
}