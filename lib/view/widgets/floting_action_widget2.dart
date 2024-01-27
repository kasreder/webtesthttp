import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NaviFloatingAction2 extends StatefulWidget {
  const NaviFloatingAction2({
    super.key,
  });

  @override
  State<NaviFloatingAction2> createState() => _NaviFloatingAction2State();
}

class _NaviFloatingAction2State extends State<NaviFloatingAction2> {
  GlobalKey<dFloatingActionButtonState> fabKey = GlobalKey();

  OverlayEntry createOverlayEntry(BuildContext context, GlobalKey<FloatingActionButtonState> fabKey) {
    RenderBox renderBox = fabKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy, // FloatingActionButton의 Y 위치
        left: offset.dx, // FloatingActionButton의 X 위치
        width: 200, // 팝업의 너비
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text('포스트 작성'),
                onTap: () {
                  // 포스트 작성 페이지로 이동
                  Navigator.of(context).pop(); // 팝업 닫기
                  context.go('/PostWrite');
                },
              ),
              ListTile(
                title: Text('취소'),
                onTap: () {
                  // 팝업 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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