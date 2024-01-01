import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'dart:async';

// import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/BoardP.dart';
import '../models/CommentP.dart';
import '../models/Model.dart';
import '../models/PostWithComments.dart';
import '../provider/noticeModel.dart';
import '../util/date_util.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class NewsNoticeMain extends StatefulWidget {
  /// Creates a RootScreen
  const NewsNoticeMain({
    required this.label,
    required this.detailsPath,
    Key? key,
  }) : super(key: key);

  /// The label
  final String label;
  final String detailsPath;

  @override
  State<NewsNoticeMain> createState() => NewsNoticeMainState();
}

class NewsNoticeMainState extends State<NewsNoticeMain> {
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
            Text('Screen ${widget.label}', style: Theme.of(context).textTheme.titleLarge),
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

  final String url = "https://terraforming.info/main/";
  Future<List<BoardP>> _getBoardList() async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<BoardP> result = jsonDecode(res.body).map<BoardP>((data) => BoardP.fromJson(data)).toList();
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
            buildNewsExpanded(deviceWidth),
            buildNewsRow(startPage, endPage),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }

  Expanded buildNewsExpanded(double deviceWidth) {
    return Expanded(
      child: FutureBuilder(
        future: _boardList,
        builder: (context, snapshot) {
          var newsDate = snapshot.data;
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
                itemCount: min(itemsPerPage, snapshot.data!.length - currentPage * itemsPerPage),
                itemBuilder: (BuildContext context, int index) {
                  int itemIndex =
                      (snapshot.data!.length - 1) - (currentPage * itemsPerPage + index); // 내림차순으로 항목의 실제 인덱스 계산
                  return Container(
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${newsDate![itemIndex].id} ",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: deviceWidth * 0.8,
                                        child: Text(
                                          "${newsDate![itemIndex].title} ",
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width: deviceWidth * 0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              // "${snapshot.data![index].created_at}",
                                              DateUtil.formatDate(newsDate![itemIndex].created_at),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(color: Colors.black54),
                                            ),
                                            Text(
                                              newsDate![itemIndex].nickname,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(color: Colors.black54),
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
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black54),
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
                separatorBuilder: (BuildContext context, int index) => const Divider(),
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
    );
  }

  Row buildNewsRow(int startPage, int endPage) {
    return Row(
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
                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
          onPressed: currentPage == (totalItems / itemsPerPage).ceil() - 1
              ? null
              : () {
                  setState(() {
                    currentPage++;
                  });
                },
        ),
      ],
    );
  }
}

/// 공지사항 게시판
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

  final String url = "https://terraforming.info/main/";
  Future<List<BoardP>> _getBoardList() async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<BoardP> result = jsonDecode(res.body).map<BoardP>((data) => BoardP.fromJson(data)).toList();
      totalItems = result.length;
      print(result[0]);
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
            buildNoticeExpanded(deviceWidth),
            buildNoticeRow(startPage, endPage),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }

  //하단 작성글 보는 리스트
  Expanded buildNoticeExpanded(double deviceWidth) {
    return Expanded(
      child: FutureBuilder(
        future: _boardList,
        builder: (context, snapshot) {
          var noticeData = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred nnnnnnnnnnn',
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
                itemCount: min(itemsPerPage, noticeData!.length - currentPage * itemsPerPage),
                itemBuilder: (BuildContext context, int index) {
                  int itemIndex =
                      (noticeData!.length - 1) - (currentPage * itemsPerPage + index); // 내림차순으로 항목의 실제 인덱스 계산
                  return Container(
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${noticeData![itemIndex].id} ",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: deviceWidth * 0.8,
                                        child: InkWell(
                                          onTap: () {
                                            String newPath = '${widget.detailPath}?itemIndex=$itemIndex';
                                            context.go(newPath);
                                          },
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${noticeData![itemIndex].title} ",
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: deviceWidth * 0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              // "${snapshot.data![index].created_at}",
                                              DateUtil.formatDate(noticeData![itemIndex].created_at),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(color: Colors.black54),
                                            ),
                                            Text(
                                              snapshot.data![itemIndex].nickname,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(color: Colors.black54),
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
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black54),
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
                separatorBuilder: (BuildContext context, int index) => const Divider(),
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
    );
  }

  //하단 페이지 숫자
  Row buildNoticeRow(int startPage, int endPage) {
    return Row(
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
                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
          onPressed: currentPage == (totalItems / itemsPerPage).ceil() - 1
              ? null
              : () {
                  setState(() {
                    currentPage++;
                  });
                },
        ),
      ],
    );
  }
}

class NoticeDetailsScreen extends StatefulWidget {
  final String label;
  final String? itemIndex;

  const NoticeDetailsScreen({
    Key? key,
    required this.label,
    this.itemIndex, // 옵셔널로 변경
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoticeDetailsScreenState();
}

/// The state for DetailsScreen
class NoticeDetailsScreenState extends State<NoticeDetailsScreen> {
  // Future<Model>? _noticeList;
  // Future<List<CommentP>>? _noticePostComment;
  Future<PostWithComments>? _noticePostComment;

  String constructUrl() {
    // `widget.itemIndex` 또는 쿼리 파라미터를 사용하여 URL 구성
    final itemIndex = widget.itemIndex ?? Uri.base.queryParameters['itemIndex'];
    if (itemIndex == null) {
      throw Exception('No item index provided');
    }
    return "https://terraforming.info/main/$itemIndex";
  }

  Future<PostWithComments> _getNoticeData() async {
    final url = constructUrl();
    final http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load data from $url');
    }

    final jsonData = jsonDecode(res.body) as Map<String, dynamic>;
    final post = Model.fromJson(jsonData['post']);
    final comments = (jsonData['comments'] as List).map<CommentP>((data) => CommentP.fromJson(data)).toList();

    return PostWithComments(post: post, comments: comments);
  }

  // Future<Model> _getnoticepost() async {
  //   final url = constructUrl();
  //   final http.Response res = await http.get(Uri.parse(url));
  //   if (res.statusCode == 200) {
  //     return Model.fromJson(jsonDecode(res.body));
  //   } else {
  //     throw Exception('Post Failed to load data from $url');
  //   }
  // }
  //
  // Future<List<CommentP>> _getnoticecomment() async {
  //   final url = constructUrl();
  //   final http.Response res = await http.get(Uri.parse(url));
  //   if (res.statusCode == 200) {
  //     // JSON 객체에서 "comments" 키에 해당하는 배열을 추출
  //     final List<dynamic> jsonList = (jsonDecode(res.body) as Map<String, dynamic>)['comments'] ?? [];
  //     final List<CommentP> result = jsonList.map<CommentP>((data) => CommentP.fromJson(data)).toList();
  //     return result; // 변환된 리스트를 반환
  //   } else {
  //     throw Exception('Failed to load data from $url');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print('initState aaaaa');
    // print('initState $_noticeList');
    // _noticeList = _getnoticepost();
    // _noticePostComment = _getnoticecomment();
    _noticePostComment = _getNoticeData();
    // print('initState after $_noticeList');
    print('initState _getnoticecomment $_noticePostComment');
    // url = "https://terraforming.info/main/${widget.itemIndex ?? Uri.base.queryParameters["itemIndex"]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: FutureBuilder<PostWithComments>(
          future: _noticePostComment,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            if  (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            }
            var noticeData = snapshot.data?.post;
            var commentData = snapshot.data!.comments;

            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
                  child: Column(
                    children: [
                      Text(
                        'Title: ${noticeData?.title}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.add_chart,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text('NO: ${noticeData?.id}', style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    Text(noticeData?.nickname ?? 'No nickname', style: const TextStyle(color: Colors.grey)),
                                    Text(DateUtil.formatDate(noticeData!.created_at), style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(noticeData!.content),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.55,
                                    child: const Divider(color: Colors.black54, thickness: 2.0)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      // 구글 로그인 버튼
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // 구글 로그인 처리
                                          },
                                          child: Text('구글'),
                                        ),
                                      ),
                                      // 네이버 로그인 버튼
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // 네이버 로그인 처리
                                          },
                                          child: Text('네이버'),
                                        ),
                                      ),
                                      // 카카오톡 로그인 버튼
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // 카카오톡 로그인 처리
                                          },
                                          child: Text('카카오톡'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildCommentList(commentData: commentData),
                )
              ],
            );
          }),
      drawer: const BaseDrawer(),
    );
  }
}

class _buildCommentList extends StatelessWidget {
  const _buildCommentList({
    super.key,
    required this.commentData,
  });

  final List<CommentP> commentData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 자식 크기에 맞춤
      children: commentData.map((comment) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.comment, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(comment.comment_author_nickname ?? 'No nickname', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              Text(comment.comment_content),
              const SizedBox(height: 4),
              Text(DateUtil.formatDate(comment.comment_created_at), style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      )).toList(),
    );
  }
}
