List<String> menuOptions = ["새소식", "커뮤니티"];
List<String> subMenus1 = ["News", "Notice", "제휴문의"];
List<String> subMenus2 = ["자유게시판", "기록/일지"];
List<String> subMenusTotal = subMenus1+subMenus2;

List<String> getMenuOptions() {
  return menuOptions;
}

List<String> getSubMenus(String selectedMenu ) {
  if (selectedMenu  == menuOptions[0]) {
    return subMenus1;
  } else if (selectedMenu  == menuOptions[1]) {
    return subMenus2;
  } else {
    return [];
  }
}

String getSubMenuId(String selectedSubMenu) {
  for (int i = 0; i < subMenusTotal.length; i++) {
    if (subMenusTotal[i] == selectedSubMenu) {
      print(selectedSubMenu + "☆☆☆☆☆☆☆☆☆");
      print(i + 1);
      return (i + 1).toString(); // 인덱스는 0부터 시작하므로 1을 더합니다.
    }
  }
  return '0'; // 일치하는 항목이 없을 경우 '0' 반환
}
