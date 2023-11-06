import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///기본앱바
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget{
  const BaseAppBar({Key? key,
    required this.appBar,
    required this.title,
    this.center = false})
      : super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          onPressed: () {
            print('search');
          },
          icon: Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => context.go('/login'),
          // onPressed: () {
          //   print('로그인버튼');
          //   () => context.go('/DD');
          // },
          icon: Icon(Icons.login_outlined),
        )
      ],
      centerTitle: center,
      title: Text(
        "$title",
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

///커뮤니티 메뉴바
class CommuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommuAppBar(
      {Key? key,
      required this.appBar,
      required this.title,
      this.center = false})
      : super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.home),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      centerTitle: center,
      title: Text(
        "$title",
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
