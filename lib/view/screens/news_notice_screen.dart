import 'dart:convert';
import 'dart:math';
import 'dart:core';

// import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../models/BoardP.dart';
import '../../models/CommentP.dart';
import '../../models/Model.dart';
import '../../models/PostWithComments.dart';
import '../../util/date_util.dart';
import '../../util/responsive_width.dart';
import '../widgets/appbar.dart';
import '../widgets/comment_write_widget.dart';
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
            const Text('정해져있는 페이지로 자동 이동합니다'),
          ],
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}

/// 공지사항 게시판
class News extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const News({
    required this.label,
    required this.detailPath,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;
  final String detailPath;

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

  final String url = "https://terraforming.info/main/news";
  Future<List<BoardP>> _getBoardList() async {
    print('initState ddddddddddddd');
    final http.Response res = await http.get(Uri.parse(url));
    print('initState eeeeeeeeeeeeeee');
    if (res.statusCode == 200) {
      print('initState fffffffffffffff');
      final List<BoardP> result = jsonDecode(res.body).map<BoardP>((data) => BoardP.fromJson(data)).toList();
      totalItems = result.length;
      print('initState sddsdsdsd');
      print('initState sddsdsdsd');
      return result;
    } else {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = ResponsiveWidth.getResponsiveWidth(context);
    print('width★★★★ : ${ResponsiveWidth.getResponsiveWidth(context)}');
    int startPage = max(0, currentPage - 2);
    int endPage = min((totalItems / itemsPerPage).ceil(), currentPage + 2);
    return Scaffold(
      appBar: BaseAppBar(
        title: "새소식(공지사항)",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("홈페이지 관련소식, 제휴 및 기타 공지"),
              buildNewsExpanded(deviceWidth),
              buildNewsRow(startPage, endPage),
            ],
          ),
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }

  //하단 작성글 보는 리스트
  Expanded buildNewsExpanded(double deviceWidth) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        child: FutureBuilder(
          future: _boardList,
          builder: (context, snapshot) {
            var NewsData = snapshot.data;
            if (snapshot.connectionState == ConnectionState.done) {
              print('initState gggggggggggggggg');
              if (snapshot.hasError) {
                return Center(
                  child: SelectableText(
                    '${snapshot.error} occurred nnnnnnnnnnn',
                    style: const TextStyle(fontSize: 18),
                  ),
                ); // if we got our data
              } else if (snapshot.hasData && snapshot.data != null) {
                print('FutureBuilder FutureBuilder');
                return ListView.separated(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: min(itemsPerPage, NewsData!.length - currentPage * itemsPerPage),
                  itemBuilder: (BuildContext context, int index) {
                    int itemIndex = (NewsData!.length - 1) - (currentPage * itemsPerPage + index); // 내림차순으로 항목의 실제 인덱스 계산
                    int totalItemsCount = NewsData!.length; // 내림차순으로 news로 검색된 인덱스 계산
                    int listOrderNumber = totalItemsCount - (currentPage * itemsPerPage + index);

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
                                    // "${NewsData![itemIndex].id} ",
                                    '$listOrderNumber',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: deviceWidth * 0.6,
                                          child: InkWell(
                                            onTap: () {
                                              String newPath = '${widget.detailPath}?itemIndex=${NewsData![itemIndex].id}';
                                              context.go(newPath);
                                            },
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${NewsData![itemIndex].title} ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceWidth * 0.5,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                // "${snapshot.data![index].created_at}",
                                                DateUtil.formatDate(NewsData![itemIndex].created_at),
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
                                    width: deviceWidth * 0.2,
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
      ),
    );
  }

  //하단 페이지 숫자
  Row buildNewsRow(int startPage, int endPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
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

class NewsDetailsScreen extends StatefulWidget {
  final String label;
  final String? itemIndex;

  const NewsDetailsScreen({
    Key? key,
    required this.label,
    this.itemIndex, // 옵셔널로 변경
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewsDetailsScreenState();
}

/// The state for DetailsScreen
class NewsDetailsScreenState extends State<NewsDetailsScreen> {
  // Future<Model>? _NewsList;
  // Future<List<CommentP>>? _NewsPostComment;
  Future<PostWithComments>? _NewsPostComment;

  String constructUrl() {
    // `widget.itemIndex` 또는 쿼리 파라미터를 사용하여 URL 구성
    final itemIndex = widget.itemIndex ?? Uri.base.queryParameters['itemIndex'];
    if (itemIndex == null) {
      throw Exception('No item index provided');
    }
    return "https://terraforming.info/main/news/$itemIndex";
  }

  Future<PostWithComments> _getNewsData() async {
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

  // Future<Model> _getNewspost() async {
  //   final url = constructUrl();
  //   final http.Response res = await http.get(Uri.parse(url));
  //   if (res.statusCode == 200) {
  //     return Model.fromJson(jsonDecode(res.body));
  //   } else {
  //     throw Exception('Post Failed to load data from $url');
  //   }
  // }
  //
  // Future<List<CommentP>> _getNewscomment() async {
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
    // print('initState $_NewsList');
    // _NewsList = _getNewspost();
    // _NewsPostComment = _getNewscomment();
    _NewsPostComment = _getNewsData();
    // print('initState after $_NewsList');
    print('initState _getNewscomment $_NewsPostComment');
    // url = "https://terraforming.info/main/${widget.itemIndex ?? Uri.base.queryParameters["itemIndex"]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: FutureBuilder<PostWithComments>(
          future: _NewsPostComment,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    SelectableText(
                      '${snapshot.error} occurred111',
                      style: const TextStyle(fontSize: 18),

                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            }
            var NewsData = snapshot.data?.post;
            var commentData = snapshot.data!.comments;

            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
                  child: Column(
                    children: [
                      SelectableText(
                        NewsData!.title,
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
                                          padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                          child: Icon(
                                            // Icons.add_chart,
                                            Icons.import_contacts_sharp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text('NO: ${NewsData?.id}', style: const TextStyle(color: Colors.grey)),
                                        Text('ddddddddddddddddddddddddddddddddddddddddddd'),
                                      ],
                                    ),
                                    SelectableText(NewsData?.nickname ?? 'No nickname',
                                        style: const TextStyle(color: Colors.grey)),
                                    Text(DateUtil.formatDate(NewsData!.created_at),
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(
                                    width: ResponsiveWidth.getResponsiveWidth(context),
                                    child: const Divider(color: Colors.black54, thickness: 0.3)),
                                SizedBox(
                                  width: ResponsiveWidth.getResponsiveWidth(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      NewsData!.content,
                                      style: const TextStyle(
                                        height: 1.5, // 줄 간격을 글자 크기의 1.5배로 설정
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveWidth.getResponsiveWidth(context),
                                    child: const Divider(color: Colors.black54, thickness: 0.3)),
                                SizedBox(
                                  width: ResponsiveWidth.getResponsiveWidth(context),
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
                                      Text('ddddddddddddddddddddddddddddddddddddddddddd'),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CommentWrite(),
                      Text('ddddddddddddddddddddddddddddddddddddddddddd'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildCommentListNews(commentData: commentData),
                      Text('ddddddddddddddddddddddddddddddddddddddddddd'),
                    ],
                  ),
                )
              ],
            );
          }),
      drawer: const BaseDrawer(),
    );
  }
}

class _buildCommentListNews extends StatelessWidget {
  const _buildCommentListNews({
    super.key,
    required this.commentData,
  });

  final List<CommentP> commentData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 자식 크기에 맞춤
      children: commentData
          .map((comment) => Padding(
        padding: const EdgeInsets.fromLTRB(50, 4, 0, 4),
        child: SizedBox(
          width: ResponsiveWidth.getResponsiveWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.subdirectory_arrow_left_outlined, color: Colors.grey, size: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(comment.comment_author_nickname ?? 'No nickname',
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(DateUtil.formatDate(comment.comment_created_at),
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(comment.comment_content),
              ),
            ],
          ),
        ),
      ))
          .toList(),
    );
  }
}

//  notice
//
//
//


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

  final String url = "https://terraforming.info/main/notice";
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
    final deviceWidth = ResponsiveWidth.getResponsiveWidth(context);
    print('width★★★★ : ${ResponsiveWidth.getResponsiveWidth(context)}');
    int startPage = max(0, currentPage - 2);
    int endPage = min((totalItems / itemsPerPage).ceil(), currentPage + 2);
    return Scaffold(
      appBar: BaseAppBar(
        title: "새소식(공지사항)",
        appBar: AppBar(),
      ),
      //라우팅쪽 label
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("홈페이지 관련소식, 제휴 및 기타 공지"),
              buildNoticeExpanded(deviceWidth),
              buildNoticeRow(startPage, endPage),
            ],
          ),
        ),
      ),
      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }

  //하단 작성글 보는 리스트
  Expanded buildNoticeExpanded(double deviceWidth) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        child: FutureBuilder(
          future: _boardList,
          builder: (context, snapshot) {
            var noticeData = snapshot.data;
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred nnnnnnnnnnn',
                    style: const TextStyle(fontSize: 18),
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
                                          width: deviceWidth * 0.6,
                                          child: InkWell(
                                            onTap: () {
                                              String newPath = '${widget.detailPath}?itemIndex=${itemIndex+1}';
                                              context.go(newPath);
                                            },
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${noticeData![itemIndex].title} ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceWidth * 0.5,
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
                                    width: deviceWidth * 0.2,
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
      ),
    );
  }

  //하단 페이지 숫자
  Row buildNoticeRow(int startPage, int endPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
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
    return "https://terraforming.info/main/notice/$itemIndex";
  }

  Future<PostWithComments> _getNoticeData() async {
    final url = constructUrl();
    final http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Failed to load data from $url');
    }

    final jsonData = jsonDecode(res.body);

    // 'post' 키가 있는지 확인하고, 있으면 Map으로 변환
    if (jsonData['post'] != null && jsonData['post'] is Map<String, dynamic>) {
      final post = Model.fromJson(jsonData['post']);

      // 'comments' 키가 있는지 확인하고, 있으면 List로 변환
      final comments = jsonData['comments'] != null && jsonData['comments'] is List
          ? (jsonData['comments'] as List).map<CommentP>((data) => CommentP.fromJson(data)).toList()
          : <CommentP>[];

      return PostWithComments(post: post, comments: comments);
    } else {
      throw Exception('Invalid data format');
    }
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
                    SelectableText(
                      '${snapshot.error} occurred222',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
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
                      SelectableText(
                        noticeData!.title,
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
                                          padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                          child: Icon(
                                            Icons.add_chart,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text('NO: ${noticeData?.id}', style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    SelectableText(noticeData?.nickname ?? 'No nickname',
                                        style: const TextStyle(color: Colors.grey)),
                                    Text(DateUtil.formatDate(noticeData!.created_at),
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(
                                    width: ResponsiveWidth.getResponsiveWidth(context),
                                    child: const Divider(color: Colors.black54, thickness: 0.3)),
                                SizedBox(
                                  width: ResponsiveWidth.getResponsiveWidth(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      noticeData!.content,
                                      style: const TextStyle(
                                        height: 1.5, // 줄 간격을 글자 크기의 1.5배로 설정
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveWidth.getResponsiveWidth(context),
                                    child: const Divider(color: Colors.black54, thickness: 0.3)),
                                SizedBox(
                                  width: ResponsiveWidth.getResponsiveWidth(context),
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
      children: commentData
          .map((comment) => Padding(
        padding: const EdgeInsets.fromLTRB(50, 4, 0, 4),
        child: SizedBox(
          width: ResponsiveWidth.getResponsiveWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.subdirectory_arrow_left_outlined, color: Colors.grey, size: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(comment.comment_author_nickname ?? 'No nickname',
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(DateUtil.formatDate(comment.comment_created_at),
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(comment.comment_content),
              ),
            ],
          ),
        ),
      ))
          .toList(),
    );
  }
}
