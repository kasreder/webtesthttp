import 'dart:convert';
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/BoardP.dart';
import '../models/Model.dart';
import '../provider/noticeModel.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class NwN extends StatefulWidget {
  /// Creates a RootScreen
  const NwN({
    required this.label,
    required this.detailsPath,
    Key? key,
  }) : super(key: key);

  /// The label
  final String label;
  final String detailsPath;

  @override
  State<NwN> createState() => NwNState();
}

class NwNState extends State<NwN> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// 메인 페이지 내용
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "새소식",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Screen ${widget.label}',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(widget.detailsPath),
              child: const Text('갈수 있어 details 돌리기전???11111'),
            ),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}

/// The details screen for either the A or B screen.
class News extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const News({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => NewsState();
}

/// The state for DetailsScreen
class NewsState extends State<News> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<BoardP>?>? _boardList;
  final int _counter = 0;
  final now = DateTime.now();
  final int itemsPerPage = 20; // 페이지당 항목 수
  int totalItems = 0; // 전체 항목 수
  int currentPage = 0; // 현재 페이지 번호

  @override
  void initState() {
    super.initState();
    _boardList = _getBoardList();
    print('initState initState');
  }

  String formatDate(String dateFromMySQL) {
    final DateTime parsedDate = DateTime.parse(dateFromMySQL);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(parsedDate);

    if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return DateFormat('yy-MM-dd').format(parsedDate);
    }
  }

  final String url = "http://192.168.35.126:8000/main/";
  Future<List<BoardP>> _getBoardList() async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<BoardP> result = jsonDecode(res.body)
          .map<BoardP>((data) => BoardP.fromJson(data))
          .toList();
      totalItems = result.length;
      print(result.length);
      return result;
    } else {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    print('width★★★★ : ${MediaQuery.of(context).size.width}');
    int startPage = max(0, currentPage - 2);
    int endPage = min((totalItems / itemsPerPage).ceil(), currentPage + 2);
    return Scaffold(
      appBar: BaseAppBar(
        title: "커뮤니티",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _boardList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      ); // if we got our data
                    } else if (snapshot.hasData && snapshot.data != null) {
                      print('FutureBuilder FutureBuilder');
                      return ListView.separated(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        // itemCount: snapshot.data!.length,
                        itemCount: min(itemsPerPage,
                            snapshot.data!.length - currentPage * itemsPerPage),
                        itemBuilder: (BuildContext context, int index) {
                          int itemIndex = (snapshot.data!.length - 1) -
                              (currentPage * itemsPerPage +
                                  index); // 내림차순으로 항목의 실제 인덱스 계산
                          return Container(
                            padding: const EdgeInsets.all(1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${snapshot.data![itemIndex].id} ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: deviceWidth * 0.8,
                                                child: Text(
                                                  "${snapshot.data![itemIndex].title} ",
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.7,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      // "${snapshot.data![index].created_at}",
                                                      formatDate(snapshot
                                                          .data![itemIndex]
                                                          .created_at),

                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      snapshot.data![itemIndex]
                                                          .nickname,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: deviceWidth * 0.1,
                                          child: Text(
                                            "사진",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage == 0
                      ? null
                      : () {
                          setState(() {
                            currentPage--;
                          });
                        },
                ),
                for (int i = startPage; i < endPage; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentPage = i;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black54;
                          }
                          return Colors.blue;
                        }),
                      ),
                      child: Text(
                        '$i',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed:
                      currentPage == (totalItems / itemsPerPage).ceil() - 1
                          ? null
                          : () {
                              setState(() {
                                currentPage++;
                              });
                            },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}

/// 222222222222222222222222
class Notice extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const Notice({
    required this.label,
    required this.detailPath,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;
  final String detailPath;

  @override
  State<StatefulWidget> createState() => NoticeState();
}

/// The state for DetailsScreen
class NoticeState extends State<Notice> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<BoardP>?>? _boardList;
  final int _counter = 0;
  final now = DateTime.now();
  final int itemsPerPage = 20; // 페이지당 항목 수
  int totalItems = 0; // 전체 항목 수
  int currentPage = 0; // 현재 페이지 번호

  @override
  void initState() {
    super.initState();
    _boardList = _getBoardList();
    print('initState initState');
  }

  String formatDate(String dateFromMySQL) {
    final DateTime parsedDate = DateTime.parse(dateFromMySQL);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(parsedDate);

    if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return DateFormat('yy-MM-dd').format(parsedDate);
    }
  }

  final String url = "http://192.168.35.126:8000/main/";
  Future<List<BoardP>> _getBoardList() async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<BoardP> result = jsonDecode(res.body)
          .map<BoardP>((data) => BoardP.fromJson(data))
          .toList();
      totalItems = result.length;
      print(result.length);
      return result;
    } else {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    print('width★★★★ : ${MediaQuery.of(context).size.width}');
    int startPage = max(0, currentPage - 2);
    int endPage = min((totalItems / itemsPerPage).ceil(), currentPage + 2);
    return Scaffold(
      appBar: BaseAppBar(
        title: "커뮤니티",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _boardList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      ); // if we got our data
                    } else if (snapshot.hasData && snapshot.data != null) {
                      print('FutureBuilder FutureBuilder');
                      return ListView.separated(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        // itemCount: snapshot.data!.length,
                        itemCount: min(itemsPerPage,
                            snapshot.data!.length - currentPage * itemsPerPage),
                        itemBuilder: (BuildContext context, int index) {
                          int itemIndex = (snapshot.data!.length - 1) -
                              (currentPage * itemsPerPage +
                                  index); // 내림차순으로 항목의 실제 인덱스 계산
                          return Container(
                            padding: const EdgeInsets.all(1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${snapshot.data![itemIndex].id} ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: deviceWidth * 0.8,
                                                // child: TextButton(
                                                //   onPressed: () => context.go(widget.detailPath),
                                                //   child: Align(
                                                //     alignment: Alignment.centerLeft,
                                                //     child: Text(
                                                //       "${snapshot.data![itemIndex].title} ",
                                                //       overflow: TextOverflow.fade,
                                                //       maxLines: 1,
                                                //       softWrap: false,
                                                //     ),
                                                //   ),
                                                // ),
                                                child: InkWell(
                                                  onTap: () {
                                                    // 공지 제목을 업데이트한 후 페이지 이동
                                                    Provider.of<NoticeProvider>(
                                                            context,
                                                            listen: false)
                                                        .setNoticeData(
                                                            NoticeData(
                                                      title: snapshot
                                                          .data![itemIndex]
                                                          .title,
                                                      content: snapshot
                                                          .data![itemIndex]
                                                          .content,
                                                      id: snapshot
                                                          .data![itemIndex].id,
                                                      created_at: snapshot
                                                          .data![itemIndex]
                                                          .created_at,
                                                      nickname: snapshot
                                                          .data![itemIndex]
                                                          .nickname,
                                                      itemIndex: itemIndex,
                                                    ));
                                                    context
                                                        .go(widget.detailPath);
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${snapshot.data![itemIndex].title} ",
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.7,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      // "${snapshot.data![index].created_at}",
                                                      formatDate(snapshot
                                                          .data![itemIndex]
                                                          .created_at),

                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      snapshot.data![itemIndex]
                                                          .nickname,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: deviceWidth * 0.1,
                                          child: Text(
                                            "사진",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage == 0
                      ? null
                      : () {
                          setState(() {
                            currentPage--;
                          });
                        },
                ),
                for (int i = startPage; i < endPage; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          currentPage = i;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.black54;
                          }
                          return Colors.blue;
                        }),
                      ),
                      child: Text(
                        '$i',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed:
                      currentPage == (totalItems / itemsPerPage).ceil() - 1
                          ? null
                          : () {
                              setState(() {
                                currentPage++;
                              });
                            },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}

class NoticeDetailsScreen extends StatefulWidget {
  const NoticeDetailsScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => NoticeDetailsScreenState();
}

String formatDate(String dateFromMySQL) {
  final DateTime parsedDate = DateTime.parse(dateFromMySQL);
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(parsedDate);

  if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else {
    return DateFormat('yy-MM-dd').format(parsedDate);
  }
}

/// The state for DetailsScreen
class NoticeDetailsScreenState extends State<NoticeDetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final noticeData = Provider.of<NoticeProvider>(context).noticeData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Details for ${widget.label} - Counter: $_counter',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('글번호: ${noticeData?.id ?? 'No ID'}'),
                  Text('nickname: ${noticeData?.nickname ?? 'No nickname'}'),
                  Text(
                    formatDate(noticeData!.created_at),
                  ),
                ],
              ),
            ),
            Text('Title: ${noticeData?.title ?? 'No Title'}'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Content: ${noticeData?.content ?? 'No Content'}'),
            ),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
    );
  }
}
