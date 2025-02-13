enum ErrorCode {
  UNKNOWN_ERROR(0, '알수 없는 에러'),
  JWT_TOKEN_MISSING(1, 'JWT토큰 오류'),
  FAIL_TO_CONVERT_FILE(2, '파일 변환 오류'),
  //AUTH LOGIN
  LOGIN_FAILURE_NO_CREDENTIAL(140201, "로그인시 입력 정보가 올바르지 않음"),
  LOGIN_FAILURE_REQUIRED_PARAMETER(140202, "로그인시 필수 입력 정보가 없음"),
  LOGIN_FAILURE_NO_EXIST_ADMIN(140203, "존재하지 않는 계정으로 로그인 시도"),
  BLOCKED_ADMIN(140204, "로그인 시도 횟수를 초과한 유저의 로그인 (시스템에서 차단한 유저의 로그인)"),

  //ADMIN_JOIN
  EXIST_PHONE_NO(140101, "이미 등록된 휴대전화 번호"),
  MOBILE_REGEX_VALIDATION(140102, "전화 번호 형식이 올바르지 않음"),
  EMAIL_REGEX_VALIDATION(140103, "이메일 형식이 올바르지 않음"),
  EXIST_EMAIL(140104, "해당 이메일이 이미 존재"),
  FAILED_TO_JOIN_SAVE_ADMIN(140105, "회원가입 저장 실패"),
  PASSWORD_REGEX_VALIDATION(140106, "비밀번호 형식이 올바르지 않음(대소문자, 특수문자)"),
  INVALID_PASSWORD_LENGTH(140107, "비밀번호 길이가 올바르지 않음"),
  MISMATCH_PASSWORD(140108, "입력한 비밀번호가 다릅니다. 다시 확인해주세요"),

  //APP_VERSION
  APP_VERSION_NOT_EXIST(141101, "존재하지 않는 앱 버전"),
  APP_VERSION_REGEX_VALIDATION(141102, "버전 형식이 맞지 않음"),
  INVALID_VERSION_PARAMETER(141103, "이전 버전보다 낮음"),
  NOT_FOUND_ANY_PUBLISH_VERSION(141104, "해당 버전을 제외하고 출시된 버전이 존재하지 않음"),
  ;

  const ErrorCode(this.errorCode, this.message);
  final int errorCode;
  final String message;

  factory ErrorCode.getByCode(int errorCode){
    return ErrorCode.values.firstWhere((value) => value.errorCode == errorCode,
    orElse: () => ErrorCode.UNKNOWN_ERROR);
  }
}