class NoticeData {
  String title;
  String content;
  String created_at;
  String nickname;
  int id;
  int itemIndex;

  NoticeData({
    required this.title,
    required this.content,
    required this.created_at,
    required this.nickname,
    required this.id,
    required this.itemIndex,
  });

  // JSON을 Dart 객체로 변환하는 fromJson 메서드를 추가합니다.
  static NoticeData fromJson(Map<String, dynamic> json) {
    return NoticeData(
      title: json['title'],
      content: json['content'],
      created_at: json['created_at'],
      nickname: json['nickname'],
      id: json['id'],
      itemIndex: json['itemIndex'],
    );
  }

}