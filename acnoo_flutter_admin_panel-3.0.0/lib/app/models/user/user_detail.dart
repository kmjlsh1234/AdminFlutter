import 'package:acnoo_flutter_admin_panel/app/constants/user/user_status.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/user/login_type.dart';

part 'user_detail.g.dart';

@JsonSerializable(includeIfNull: true)
class UserDetail {
  //user
  final int userId;
  final String loginId;
  final UserStatus status;
  final String mobile;
  final String email;
  final LoginType loginType;
  final DateTime? initAt;
  final DateTime? loginAt;
  final DateTime? logoutAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  //profile
  final String nickname;
  final String? image;
  final int basicImageIdx;

  //Agreement
  final bool agreeTerm;
  final bool agreePrivacy;
  final bool agreeSensitive;
  final bool agreeMarketing;
  final DateTime? marketingModifiedAt;

  UserDetail(
      this.userId,
      this.loginId,
      this.status,
      this.mobile,
      this.email,
      this.loginType,
      this.initAt,
      this.loginAt,
      this.logoutAt,
      this.createdAt,
      this.updatedAt,
      this.nickname,
      this.image,
      this.basicImageIdx,
      this.agreeTerm,
      this.agreePrivacy,
      this.agreeSensitive,
      this.agreeMarketing,
      this.marketingModifiedAt
  );

  factory UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
