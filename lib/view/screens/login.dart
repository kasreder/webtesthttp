
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class Login extends StatefulWidget {
  /// Creates a RootScreen
  const Login({
    required this.label,
    required this.detailsPath_a,
    Key? key,
  }) : super(key: key);

  /// The label
  final String label;
  final String detailsPath_a;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// 메인 페이지 내용
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    print('width★★★★ : ${MediaQuery.of(context).size.width}');
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar(), title: "로그인"),
      //라우팅쪽 label
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ID 입력창
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Enter ID'),
                  keyboardType: TextInputType.text,
                )),
            // PW 입력창
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Enter Password'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                )),
            // 로그인 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 처리
                },
                child: const Text('로그인'),
              ),
            ),
            // 소셜 로그인 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 구글 로그인 버튼
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // 구글 로그인 처리
                    },
                    child: const Text('구글'),
                  ),
                ),
                // 네이버 로그인 버튼
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // 네이버 로그인 처리
                    },
                    child: const Text('네이버'),
                  ),
                ),
                // 카카오톡 로그인 버튼
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // 카카오톡 로그인 처리
                    },
                    child: const Text('카카오톡'),
                  ),
                ),
              ],
            ),
            // 비밀번호 찾기 링크
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  // 비밀번호 찾기 페이지로 이동
                },
                child: const Text('비밀번호 찾기'),
              ),
            ),
            // Text('LoginLoginLoginLoginLoginLogin $label',
            //     style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(widget.detailsPath_a),
              child: const Text('View details 돌리기전???'),
            ),
          ],
        ),
      ),
      drawer: BaseDrawer(),
    );
  }
}

/// The details screen for either the A or B screen.
class DetailsScreen_a extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen_a({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen_a> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('loginlogin Details for ${widget.label} - Counter: $_counter',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('Increment counter'),
            ),
          ],
        ),
      ),
    );
  }
}
