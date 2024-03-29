import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hgbh_app/common/dao/repos_dao.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/page/repository_detail_page.dart';
import 'package:hgbh_app/widget/markdown_widget.dart';
import 'package:scoped_model/scoped_model.dart';


class RepositoryDetailReadmePage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepositoryDetailReadmePage(this.userName, this.reposName, {Key key}) : super(key: key);

  @override
  RepositoryDetailReadmePageState createState() => RepositoryDetailReadmePageState();
}


class RepositoryDetailReadmePageState extends State<RepositoryDetailReadmePage> with AutomaticKeepAliveClientMixin {
  bool isShow = false;

  String markdownData;

  RepositoryDetailReadmePageState();

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(widget.userName, widget.reposName, ReposDetailModel.of(context).currentBranch).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next?.call();
        }
      }
      return new Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var widget = (markdownData == null)
        ? Center(
            child: new Container(
              width: 200.0,
              height: 200.0,
              padding: new EdgeInsets.all(4.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
                  new Container(width: 10.0),
                  new Container(child: new Text(CommonUtils.getLocale(context).loading_text, style: HGConstant.middleText)),
                ],
              ),
            ),
          )
        : HGMarkdownWidget(markdownData: markdownData);

    return new ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) => widget,
    );
  }
}
