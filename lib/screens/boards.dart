import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/BoardPaser.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

/// Widget for the root/initial pages in the bottom navigation bar.
class Boards extends StatefulWidget {
  /// Creates a RootScreen
  const Boards({
    required this.label,
    required this.detailsPath,
    Key? key,
  }) : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  @override
  State<Boards> createState() => _BoardsState();
}

class _BoardsState extends State<Boards> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<BoardPaser>?>? _boardList;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _boardList = _getBoardList();
    print('initState initState');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      print('_incrementCounter _incrementCounter');
    });
  }
  final String url = "https://terraforming.info/main/published";
  Future<List<BoardPaser>> _getBoardList() async {

    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<BoardPaser> result = jsonDecode(res.body)
          .map<BoardPaser>((data) => BoardPaser.fromJson(data))
          .toList();
      print('BoardPaser 됨됨됨됨됨됨됨됨');
      return result;
    } else {
      throw Exception('Failed to load boards');
    }
  }

  /// 메인 페이지 내용
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    print('width★★★★ : ${MediaQuery.of(context).size.width}');
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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () => context.go(widget.detailsPath),
              child: const Text('갈수 있어 details 돌리기전???11111'),
            ),
            Expanded(
              child: FutureBuilder(
                future: _boardList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ); // if we got our data
                    } else if (snapshot.hasData) {
                      print('FutureBuilder FutureBuilder');
                      return ListView.separated(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
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
                                        Text("${snapshot.data![index].id} ",style: Theme.of(context).textTheme.titleSmall,),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: deviceWidth * 0.7,
                                                child: Text(
                                                  "${snapshot.data![index].title} ",
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.7,
                                                child: Text(
                                                  "내용: ${snapshot.data![index].description}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "지원자",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(color: Colors.black54),
                                        ),
                                        Text(
                                          "122",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(color: Colors.black54),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      drawer: const BaseDrawer(),
      // drawer: const BaseDrawer(),
    );
  }
}

/// The details screen for either the A or B screen.
class BoadrsFree extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const BoadrsFree({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<BoadrsFree> {
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
            Text('개발세발 for ${widget.label} - Counter: $_counter',
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
      drawer: const BaseDrawer(),
    );
  }
}

class BoadrsDevelop extends StatefulWidget {
  const BoadrsDevelop({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  State<BoadrsDevelop> createState() => _BoadrsDevelopState();
}

class _BoadrsDevelopState extends State<BoadrsDevelop> {
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
          ],
        ),
      ),
      drawer: const BaseDrawer(),
    );
  }
}
