enum ErrorCode {
  UNKNOWN_ERROR(400, 0, '알수 없는 에러'),
  JWT_TOKEN_MISSING(400, 1, 'JWT토큰 오류'),
  FAIL_TO_CONVERT_FILE(400, 2, '파일 변환 오류'),
  FILE_NOT_SELECTED(400, 3, '파일이 선택되지 않음'),

  // ADMIN JWT (1400XX)
  JWT_TOKEN_AUTH_ERROR(401,140001, "JWT_TOKEN_AUTH_ERROR"),
  JWT_TOKEN_EXPIRATION(401,140002, "JWT_TOKEN_EXPIRATION"),
  INVALID_AUTH_TOKEN(401,140003, "INVALID_AUTH_TOKEN"),
  INVALID_PRIVILEGE(403,140004, "해당 메뉴 권한 없음"),

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

  //ADMIN_MANAGE(1408XX)
  ADMIN_NOT_EXIST(401,140801, "ADMIN_NOT_EXIST"),
  NO_CHANGE_STATUS(401,140802, "NO_CHANGE_STATUS"),
  EXIST_CTI_INFO_ID(400,140803, "EXIST_CTI_INFO_ID"),
  NOT_SELECT_ROLE(400, 140804, "관리자 역할을 선택하지 않음"),

  // Admin menu (1409XX)
  ADMIN_MENU_NOT_EXIST(404,140901, "해당 메뉴가 존재하지 않음"),
  PARENT_ADMIN_MENU_NOT_EXIST(404,140902, "부모 메뉴가 존재하지 않음"),
  ADMIN_PRIVILEGE_NOT_EXIST(404,140903, "해당 권한이 존재하지 않음"),
  ADMIN_ROLE_NOT_EXIST(404,140904, "해당 역할이 존재하지 않음"),
  PRIVILEGE_HAS_MAPPING_WITH_ROLE(400,140905, "권한이 역할에 매핑되어 있음"),
  ADMIN_ROLE_PRIVILEGE_INVALID_PARAMETER(401,140906, "올바르지 않은 역할권한"),
  ADMIN_ROLE_HAS_MAPPING_WITH_ADMIN(401,140907, "역할이 관리자와 매핑되어 있음"),
  ADMIN_MENU_PRIVILEGE_EXIST(401,140908 , "관리자 권한이 존재함"),
  DUPLICATE_ADMIN_MENU_NAME(401, 140910, "중복된 메뉴 이름이 존재함"),
  DUPLICATE_ADMIN_MENU_PATH(401, 140911, "중복된 메뉴 경로가 존재함"),
  DUPLICATE_ADMIN_MENU_SORT_ORDER(401, 140912, "중복된 메뉴 순서가 존재함"),

  //APP_VERSION
  APP_VERSION_NOT_EXIST(404, 141101, "존재하지 않는 앱 버전"),
  APP_VERSION_REGEX_VALIDATION(400, 141102, "버전 형식이 맞지 않음"),
  INVALID_VERSION_PARAMETER(400, 141103, "이전 버전보다 낮음"),
  NOT_FOUND_ANY_PUBLISH_VERSION(404, 141104, "해당 버전을 제외하고 출시된 버전이 존재하지 않음"),

  //Board manage(1421XX)
  BOARD_NOT_EXIST(404, 142101, "게시글이 존재하지 않음"),
  BOARD_TITLE_EMPTY(400, 142102, "게시글 제목 형식이 올바르지 않습니다.(공백)"),
  BOARD_CONTENT_EMPTY(400, 142103, "게시글 본문 형식이 올바르지 않습니다.(공백)"),

  //Product(1500XX)
  PRODUCT_NOT_EXIST(404, 150001, '상품이 존재하지 않음'),
  DUPLICATE_PRODUCT_NAME(400, 150002, '상품 이름이 존재함'),
  INVALID_PRODUCT_PARAMETER(400, 150003, '적합하지 않은 파라미터가 포함됨(준비 중이 아니면 name, type, originPrice 못 바꿈)'),
  INVALID_PRODUCT_COUNT(400, 150004, '상품 갯수가 적합하지 않음'),
  PRODUCT_OPTION_NOT_EXIST(404, 150005, '상품 옵션이 존재하지 않음'),
  INVALID_PRODUCT_OPTION_PARAMETER(400, 150006, '등록 옵션이 비었음'),
  INVALID_PRODUCT_STATUS(400, 150007, '해당 상태로 변경이 불가'),
  PRODUCT_NAME_EMPTY(400, 150008, '상품 이름이 빈 값'),
  PRODUCT_DESC_EMPTY(400, 150009, '상품 설명이 빈 값'),
  PRODUCT_INFO_EMPTY(400, 150010, '상품 정보가 빈 값'),
  PRODUCT_PRICE_EMPTY(400, 150011, '상품 금액이 빈 값'),
  PRODUCT_ORIGIN_PRICE_EMPTY(400, 150012, '상품 원금액이 빈 값'),
  PRODUCT_THUMBNAIL_EMPTY(400, 150013, '상품 썸네일이 빈 값'),
  PRODUCT_IMAGE_EMPTY(400, 150014, '상품 이미지가 빈 값'),

  //Category(1501XX)
  CATEGORY_NOT_EXIST(404, 150101, "해당 카테고리가 존재하지 않음"),
  DUPLICATE_CATEGORY_NAME(400,150102, "중복된 이름의 카테고리가 존재함"),
  CATEGORY_HAS_MAPPING_WITH_ITEM(400,150103, "카테고리가 아이템에 매핑되어 있음"),

  // CURRENCY(1502XX)
  COIN_LOCK_FAIL(400, 150201, "코인 락 획득 실패"),
  NOT_FOUND_COIN_INFO(404, 150202, "코인 정보가 존재하지 않음"),
  NOT_ENOUGH_COIN(400, 150203, "코인이 충분하지 않음"),
  NOT_ALLOWED_CHEAT(400, 150204, "치트가 허용되지 않음"),
  DUPLICATED_COIN_REQUEST(400, 150205, "중복된 코인 요청"),
  DIAMOND_LOCK_FAIL(400, 150206, "다이아 락 획득 실패"),
  NOT_FOUND_DIAMOND_INFO(404, 150207, "다이아 정보가 존재하지 않음"),
  NOT_ENOUGH_DIAMOND(400, 150208, "다이아가 충분하지 않음"),
  DUPLICATED_DIAMOND_REQUEST(400, 150209, "중복된 다이아 요청"),
  CHIP_LOCK_FAIL(400, 150210, "칩 락 획득 실패"),
  NOT_FOUND_CHIP_INFO(404, 150211, "칩 정보가 존재하지 않음"),
  NOT_ENOUGH_CHIP(400, 150212, "칩이 충분하지 않음"),
  DUPLICATED_CHIP_REQUEST(400, 150213, "중복된 칩 요청"),
  INVALID_CURRENCY_PARAMETER(400, 150214, "잘못된 수량 형식"),

  // BUNDLE(1503XX)
  BUNDLE_NOT_EXIST(404, 150301, "해당 번들이 존재하지 않음"),
  DUPLICATE_BUNDLE_NAME(400, 150302, "중복된 이름의 번들이 존재함"),
  DUPLICATE_BUNDLE_SKU(400, 150303, "중복된 SKU의 번들이 존재함"),
  INVALID_BUNDLE_STOCK_QUANTITY(400, 150304, "번들 재고 수량이 적합하지 않음"),
  INVALID_BUNDLE_END_DATE(400, 150305, "번들 종료 날짜가 올바르지 않음"),
  INVALID_BUNDLE_COUNT_PER_PERSON(400, 150306, "인당 구매제한 횟수가 올바르지 않음"),
  BUNDLE_NOT_MAPPED_WITH_ITEM_AND_CURRENCY(400, 150307, "번들이 아이템, 재화 모두와 매핑되어 있지 않음"),
  EMPTY_BUNDLE_PARAMETER(400, 150308, "번들 파라미터가 비었음"),
  BUNDLE_STATUS_NOT_READY(400, 150309, "번들의 상태가 준비중이 아님"),
  INVALID_BUNDLE_STATUS(400, 150310, "올바르지 않은 번들 상태"),
  INVALID_BUNDLE_MOD_PARAMETER(400, 150311, "올바르지 않은 번들 정보 변경 파라미터"),

  BUNDLE_CURRENCY_NOT_EXIST(404, 150312, "번들 재화가 존재하지 않음"),
  BUNDLE_CURRENCY_TYPE_ALREADY_MAPPED(400, 150313, "번들 재화 타입이 이미 매핑되어 있음"),
  BUNDLE_CURRENCY_COUNT_EMPTY(400, 150314, "번들 재화 수량이 비어있음"),

  BUNDLE_ITEM_COUNT_EMPTY(400, 150315, "번들 아이템 수량이 비어있음"),
  BUNDLE_ITEM_ALREADY_MAPPED(400, 150316, "번들 아이템이 이미 매핑되어 있음"),
  BUNDLE_ITEM_NOT_EXIST(404, 150317, "번들 아이템이 존재하지 않음"),

  // ITEM_UNIT(1504XX)
  ITEM_UNIT_NOT_EXIST(404, 150401, '아이템 유닛이 존재하지 않음'),
  DUPLICATE_ITEM_UNIT_SKU(400, 150402, '아이템 유닛 sku가 존재함'),
  DUPLICATE_ITEM_UNIT_NAME(400, 150403, '아이템 유닛 이름이 존재함'),
  ITEM_UNIT_HAS_MAPPING_WITH_ITEM(400, 150404, '매핑된 아이템이 존재함'),
  INVALID_ITEM_UNIT_MOD_PARAMETER(400, 150405, '잘못된 변경 파라미터가 포함됨.(매핑된 아이템이 준비 중이 아닌데, NAME, SKU, TYPE 변경 시도)'),

  // ITEM(1505XX)
  ITEM_NOT_EXIST(404, 150501, '아이템이 존재하지 않음'),
  DUPLICATE_ITEM_NAME(400, 150502, '아이템 이름이 중복됨'),
  DUPLICATE_ITEM_SKU(400, 150503, '아이템 sku가 중복됨'),
  INVALID_ITEM_STOCK_QUANTITY(400, 150504, '아이템 재고가 적절하지 않음'),
  INVALID_ITEM_EXPIRATION(400, 150505, '아이템 판매 기한이 적절하지 않음'),
  INVALID_ITEM_MOD_PARAMETER(400, 150506, '잘못된 변경 파라미터가 포함됨.(아이템이 준비 중이 아닌데 categoryId, itemUnitId, name, sku, currencyType, num, amount 변경 시도)'),
  EMPTY_ITEM_PARAMETER(400, 150507, '아이템 sku와 이름이 빈 값(ready → on_sale)'),
  ITEM_HAS_MAPPING_WITH_BUNDLE(400, 150508, '아이템이 번들에 매핑되어 있음(매핑된 번들이 READY, ON_SALE상태)'),
  INVALID_ITEM_STATUS(400, 150509, '아이템 상태가 적합하지 않음'),
  ITEM_SKU_EMPTY(400, 150510, '아이템 SKU가 빈 값'),
  ITEM_NAME_EMPTY(400, 150511, '아이템 이름이 빈 값'),
  ITEM_DESC_EMPTY(400, 150512, '아이템 설명이 빈 값'),
  ITEM_INFO_EMPTY(400, 150513, '아이템 정보가 빈 값'),
  INVALID_PERIOD_PARAMETER(400, 150514, '잘못된 기간 입력'),
  ITEM_AMOUNT_EMPTY(400, 150515, '아이템 가격이 빈 값'),
  ITEM_CATEGORY_EMPTY(400, 150516, '아이템 카테고리가 빈 값'),
  INVALID_EXPIRATION_PARAMETER(400, 150517, '잘못된 만료기한 입력'),
  ITEM_THUMBNAIL_EMPTY(400, 150518, '아이템 썸네일 빈 값'),
  ITEM_IMAGE_EMPTY(400, 150518, '아이템 이미지 빈 값'),
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