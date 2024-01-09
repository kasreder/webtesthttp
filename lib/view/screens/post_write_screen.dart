
import 'package:flutter/material.dart';

import '../../util/responsive_width.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';


class PostWrite extends StatefulWidget {
  const PostWrite({Key? key}) : super(key: key);

  @override
  State<PostWrite> createState() => _PostWriteState();
}

class _PostWriteState extends State<PostWrite> {
  final _formKey = GlobalKey<FormState>();
  String? selectedMenu;
  String? selectedBoard;
  final List<String> menuOptions = ['Menu 1', 'Menu 2', 'Menu 3'];
  final List<String> boardOptions = ['Board 1', 'Board 2', 'Board 3'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = ResponsiveWidth.getResponsiveWidth(context);
    return Scaffold(
      appBar: BaseAppBar(
        title: "글작성 페이지",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  // 메뉴 선택
                  DropdownButtonFormField<String>(
                    value: selectedMenu,
                    hint: Text('메뉴 선택'),
                    onChanged: (newValue) => setState(() => selectedMenu = newValue),
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
                    value: selectedBoard,
                    hint: Text('게시판 선택'),
                    onChanged: (newValue) => setState(() => selectedBoard = newValue),
                    items: boardOptions.map((board) {
                      return DropdownMenuItem(
                        value: board,
                        child: Text(board),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // 제목
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: '제목'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제목을 입력해주세요';
                      }
                      return null;
                    },
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

                  // 링크
                  TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(labelText: '링크'),
                  ),
                  SizedBox(height: 16),

                  // 작성 버튼
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // 폼 데이터 처리
                        // 예: 서버에 데이터 전송
                      }
                    },
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
          ),
        ],
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}