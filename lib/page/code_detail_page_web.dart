import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hgbh_app/common/config/config.dart';
import 'package:hgbh_app/common/dao/repos_dao.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/common/utils/html_utils.dart';
import 'package:hgbh_app/widget/title_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CodeDetailPageWeb extends StatefulWidget {
  final String userName;

  final String reposName;

  final String path;

  final String data;

  final String title;

  final String branch;

  final String htmlUrl;

  CodeDetailPageWeb(
      {this.title,
      this.userName,
      this.reposName,
      this.path,
      this.data,
      this.branch,
      this.htmlUrl});

  @override
  _CodeDetailPageState createState() => _CodeDetailPageState(data);
}

class _CodeDetailPageState extends State<CodeDetailPageWeb> {

  String data;

  _CodeDetailPageState(this.data);

  @override
  void initState() {
    super.initState();
    if (data == null) {
      ReposDao.getReposFileDirDao(widget.userName, widget.reposName,
              path: widget.path,
              branch: widget.branch,
              text: true,
              isHtml: true)
          .then((res) {
        if (res != null && res.result) {
          String data2 = HtmlUtils.resolveHtmlFile(res, "java");
          String url = new Uri.dataFromString(data2,
                  mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
              .toString();
          setState(() {
            this.data = url;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: HGTitleBar(widget.title),
        ),
        body: new Center(
          child: new Container(
            width: 200.0,
            height: 200.0,
            padding: new EdgeInsets.all(4.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
                new Container(width: 10.0),
                new Container(
                    child: new Text(CommonUtils.getLocale(context).loading_text,
                        style: HGConstant.middleText)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
      ),
      body: WebView(
        initialUrl: data,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
