enum ActionMenu{
  VIEW('보기'),
  EDIT('변경'),
  EDIT_STATUS('상태 변경'),
  DELETE('삭제'),
  ROLE_MANAGER('해당 역할 관리자'),
  MAPPING_ITEM('매핑된 아이템 보기'),
  ;

  final String value;
  const ActionMenu(this.value);
}