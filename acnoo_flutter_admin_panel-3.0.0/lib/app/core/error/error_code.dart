enum ErrorCode {
  UNKNOWN_ERROR(400, 0, '알수 없는 에러'),
  JWT_TOKEN_MISSING(400, 1, 'JWT토큰 오류'),
  FAIL_TO_CONVERT_FILE(400, 2, '파일 변환 오류'),

  //ADMIN_JOIN
  EXIST_PHONE_NO(400, 140101, "이미 등록된 휴대전화 번호"),
  MOBILE_REGEX_VALIDATION(400, 140102, "전화 번호 형식이 올바르지 않음"),
  EMAIL_REGEX_VALIDATION(400, 140103, "이메일 형식이 올바르지 않음"),
  EXIST_EMAIL(400,140104, "해당 이메일이 이미 존재"),
  FAILED_TO_JOIN_SAVE_ADMIN(401, 140105, "회원가입 저장 실패"),
  PASSWORD_REGEX_VALIDATION(400, 140106, "비밀번호 형식이 올바르지 않음(대소문자, 특수문자)"),
  INVALID_PASSWORD_LENGTH(400, 140107, "비밀번호 길이가 올바르지 않음"),
  MISMATCH_PASSWORD(400, 140108, "입력한 비밀번호가 다릅니다. 다시 확인해주세요"),

  //AUTH LOGIN
  LOGIN_FAILURE_NO_CREDENTIAL(400, 140201, "로그인시 입력 정보가 올바르지 않음"),
  LOGIN_FAILURE_REQUIRED_PARAMETER(400, 140202, "로그인시 필수 입력 정보가 없음"),
  LOGIN_FAILURE_NO_EXIST_ADMIN(403, 140203, "존재하지 않는 계정으로 로그인 시도"),
  BLOCKED_ADMIN(403, 140204, "로그인 시도 횟수를 초과한 유저의 로그인 (시스템에서 차단한 유저의 로그인)"),
  LOGIN_FAILURE_ADMIN_STATUS_EXIT(403, 140205, '탈퇴 유저의 인증 시도'),
  LOGIN_FAILURE_ADMIN_STATUS_TRYEXIT(403, 140206, '탈퇴신청한(탈퇴중) 유저의 인증 시도'),
  LOGIN_FAILURE_ADMIN_STATUS_LOGOUT(403, 140207, '로그아웃된 토큰으로 인증 시도'),
  LOGIN_FAILURE_ADMIN_STATUS_STOP(403, 140208, '이용정지된 유저의 로그인 시도'),
  LOGIN_FAILURE_ADMIN_STATUS_BAN(403, 140209, '강제 차단 당한 유저의 로그인 시도'),
  LOGIN_FAILURE_BAD_CREDENTIAL(403, 140210, "패스워드 틀림 등 인증 정보 불일치"),

  //ADMIN_MANAGE

  //APP_VERSION
  APP_VERSION_NOT_EXIST(404, 141101, "존재하지 않는 앱 버전"),
  APP_VERSION_REGEX_VALIDATION(400, 141102, "버전 형식이 맞지 않음"),
  INVALID_VERSION_PARAMETER(400, 141103, "이전 버전보다 낮음"),
  NOT_FOUND_ANY_PUBLISH_VERSION(404, 141104, "해당 버전을 제외하고 출시된 버전이 존재하지 않음"),
  ;

  const ErrorCode(this.statusCode, this.errorCode, this.message);
  final int statusCode;
  final int errorCode;
  final String message;

  factory ErrorCode.getByCode(int errorCode){
    return ErrorCode.values.firstWhere((value) => value.errorCode == errorCode,
    orElse: () => ErrorCode.UNKNOWN_ERROR);
  }
}