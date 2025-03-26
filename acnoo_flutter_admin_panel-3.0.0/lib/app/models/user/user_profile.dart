import 'package:acnoo_flutter_admin_panel/app/constants/user/login_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/user/user_status.dart';

part 'user_profile.g.dart';

@JsonSerializable(includeIfNull: true)
class UserProfile{
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
  final int? basicImageIdx;

  UserProfile(
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
      this.basicImageIdx
  );

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}