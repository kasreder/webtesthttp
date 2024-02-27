import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class BaseDrawer extends StatelessWidget {
  const BaseDrawer({
    Key? key,
    // required this.drawer,
    // required this.title1,
    // required this.onItemTapped,
  }) : super(key: key);

  // final Widget drawer;
  // final String title1;
  // final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              // color: Colors.deepPurpleAccent,
              color: Color(0xffce93d8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('COSMOSX',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.door_front_door_outlined),
                    Text('Login',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  ],
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text('새소식'),
            children: <Widget>[
              ListTile(
                  title: Text('News'),
                  onTap: () {
                    context.go('/nwn/news');
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Text('Notice'),
                  onTap: () {
                    context.go('/nwn/notice');
                    Navigator.pop(context);
                  }),
            ],
          ),
          ExpansionTile(
            title: Text('커뮤니티'),
            children: <Widget>[
              ListTile(
                title: Text('자유게시판'),
                onTap: () => context.go('/boards/free'),
              ),
              ListTile(
                  title: Text('기록/실험'),
                  onTap: () {
                    context.go('/boards/develop');
                    Navigator.pop(context);
                  }),
            ],
          ),
          ListTile(
              title: Text('설정'),
              onTap: () {
                context.go('/set');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('LOGIN'),
              onTap: () {
                context.go('/set');
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
