import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/BoardP.dart';
import '../../../models/Model.dart';
import '../../../provider/news_item_privider.dart';
import '../../../provider/noticeModel.dart';
import '../../../util/date_util.dart';
import '../../screens/NewsnNotice.dart';

class NewsItem extends StatefulWidget {
  const NewsItem({
    super.key,
    required this.deviceWidth,
    required this.widget,
    required this.itemIndex,
  });

  final int itemIndex;
  final double deviceWidth;
  final Notice widget;

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    NewsProvider provider = Provider.of(context, listen: false);
    var data = provider.boardP;

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
                    "${data.id} ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: widget.deviceWidth * 0.8,
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
                              Provider.of<NoticeProvider>(context, listen: false).setNoticeData(NoticeData(
                                title: data!.title,
                                content: data!.content,
                                id: data!.id,
                                created_at: data!.created_at,
                                nickname: data!.nickname,
                                itemIndex: widget.itemIndex,
                              ));
                              // context
                              //     .go(widget.detailPath);
                              String newPath = '${widget.widget.detailPath}?itemIndex=${widget.itemIndex}';
                              context.go(newPath);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Newstitle(data: data),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.deviceWidth * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                // "${snapshot.data![index].created_at}",
                                DateUtil.formatDate(data!.created_at),

                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black54),
                              ),
                              Text(
                                data!.nickname,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black54),
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
                    width: widget.deviceWidth * 0.1,
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
  }
}

class Newstitle extends StatelessWidget {
  const Newstitle({
    super.key,
    required this.data,
  });

  final BoardP data;

  @override
  Widget build(BuildContext context) {
    NewsProvider provider = Provider.of(context, listen: true);
    var data = provider.boardP;

    return Text(
      "${data!.title} ",
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    );
  }
}
