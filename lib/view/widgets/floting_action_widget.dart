import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NaviFloatingAction extends StatelessWidget {
  const NaviFloatingAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // 대화상자 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('추가 옵션'),
              content: Text('어떤 작업을 수행하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 대화상자 닫기
                    context.go('/PostWrite'); // 페이지 이동
                  },
                  child: Text('포스트 작성'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 대화상자 닫기
                    // 다른 동작 수행
                  },
                  child: Text('취소'),
                ),
              ],
            );
          },
        );
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }
}