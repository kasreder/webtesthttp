import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../util/post_menu.dart';
import '../../util/responsive_width.dart';


class CommentWrite extends StatefulWidget {
  const CommentWrite({Key? key}) : super(key: key);

  @override
  State<CommentWrite> createState() => _CommentWriteState();
}

class _CommentWriteState extends State<CommentWrite> {
  final _formKey = GlobalKey<FormState>();
  String? selectedMenu;
  String? selectedSubMenu;
  final List<String> menuOptions = getMenuOptions();
  String? subMenuId;
  List<String> subMenus = [];

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 폼이 유효할 때 실행되는 코드

      // 각 TextFormField의 값 가져오기
      String nickname = _nicknameController.text;
      String? board = subMenuId;
      String content = _contentController.text;
      // 서버에 데이터 전송
      const String url = "https://terraforming.info/main/";
      final response = await http.post(Uri.parse(url), // 서버의 API 엔드포인트
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nickname': nickname,
          "board_id": board as String,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        // 성공적으로 데이터가 전송된 경우
        print('Data sent to the server successfully');
        Navigator.pop(context);
      } else {
        // 데이터 전송 실패
        print('Failed to send data');
      }

      // 값들을 처리하는 로직
      // 예: 서버에 데이터 전송, 화면 이동 등
      // 여기서는 콘솔에 출력하는 예제를 보여줍니다.
      print('닉네임: $nickname');
      // print('보드: $board');
      print('내용: $content');
      // print('링크: $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = ResponsiveWidth.getResponsiveWidth(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            // 메뉴 선택
            DropdownButtonFormField<String>(
              value: selectedMenu,
              hint: Text('메뉴 선택'),
              onChanged: (newValue) {
                setState(() {
                  selectedMenu = newValue;
                  subMenus = getSubMenus(selectedMenu!);
                  selectedSubMenu = null; // 서브메뉴 초기화
                });
              },
              items: menuOptions.map((menu) {
                return DropdownMenuItem(
                  value: menu,
                  child: Text(menu),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // 게시판 선택
            DropdownButtonFormField<String>(
              value: selectedSubMenu,
              hint: Text('게시판 선택'),
              onChanged: (newValue) {
                setState(() {
                  selectedSubMenu = newValue;
                  subMenuId = getSubMenuId(selectedSubMenu ?? '');
                  // 이제 'subMenuId'를 사용하여 필요한 작업을 수행할 수 있습니다.
                  // 예: 서버에 데이터 전송, 상태 업데이트 등
                });
              },
              items: subMenus.map((board) {
                return DropdownMenuItem(
                  value: board,
                  child: Text(board),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // 내용
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '내용을 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // 닉네임
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: '닉네임'),
            ),
            SizedBox(height: 16),

            // // 링크
            // TextFormField(
            //   controller: _linkController,
            //   decoration: InputDecoration(labelText: '링크'),
            // ),
            // SizedBox(height: 16),

            // 작성 버튼
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('작성하기'),
            ),

            // 취소 버튼
            TextButton(
              onPressed: () {
                // 취소 로직
                // 예: 이전 페이지로 돌아가기
              },
              child: Text('취소하기'),
            ),
          ],
        ),
      ),
    );
  }
}