import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgbh_app/common/dao/repos_dao.dart';
import 'package:hgbh_app/common/model/PushCommit.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/widget/common_option_widget.dart';
import 'package:hgbh_app/widget/state/list_state.dart';
import 'package:hgbh_app/widget/pull/pull_load_widget.dart';
import 'package:hgbh_app/widget/title_bar.dart';
import 'package:hgbh_app/widget/push_coed_item.dart';
import 'package:hgbh_app/widget/push_header.dart';
import 'package:hgbh_app/common/utils/html_utils.dart';


class PushDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String sha;

  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName, {this.needHomeIcon = false});

  @override
  _PushDetailPageState createState() => _PushDetailPageState();
}

class _PushDetailPageState extends State<PushDetailPage> with AutomaticKeepAliveClientMixin<PushDetailPage>, HGListState<PushDetailPage> {

  ///提价信息页面的头部数据实体
  PushHeaderViewModel pushHeaderViewModel = new PushHeaderViewModel();

  ///配置标题了右侧的更多显示
  final OptionControl titleOptionControl = new OptionControl();

  _PushDetailPageState();

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    ///获取提交信息
    var res = await _getDataLogic();
    if (res != null && res.result) {
      PushCommit pushCommit = res.data;
      pullLoadWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pushHeaderViewModel = PushHeaderViewModel.forMap(pushCommit);
          pullLoadWidgetControl.dataList.addAll(pushCommit.files);
          pullLoadWidgetControl.needLoadMore.value = false;
          titleOptionControl.url = pushCommit.htmlUrl;
        });
      }
    }
    isLoading = false;
    return null;
  }

  ///绘制头部和提交item
  _renderEventItem(index) {
    if (index == 0) {
      return new PushHeader(pushHeaderViewModel);
    }
    PushCodeItemViewModel itemViewModel = PushCodeItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]);
    return new PushCodeItem(itemViewModel, () {
      String html = HtmlUtils.generateCode2HTml(HtmlUtils.parseDiffSource(itemViewModel.patch, false),
          backgroundColor: HGColors.webDraculaBackgroundColorString, lang: '', userBR: false);
      NavigatorUtils.gotoCodeDetailPlatform(
        context,
        title: itemViewModel.name,
        reposName: widget.reposName,
        userName: widget.userName,
        path: itemViewModel.patch,
        data: new Uri.dataFromString(html, mimeType: 'text/html', encoding: Encoding.getByName("utf-8")).toString(),
        branch: "",
      );
    });
  }

  _getDataLogic() async {
    return await ReposDao.getReposCommitsInfoDao(widget.userName, widget.reposName, widget.sha);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {}

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    Widget widgetContent = (widget.needHomeIcon) ? null : new HGCommonOptionWidget(titleOptionControl);
    return new Scaffold(
      appBar: new AppBar(
        title: HGTitleBar(
          widget.reposName,
          rightWidget: widgetContent,
          needRightLocalIcon: widget.needHomeIcon,
          iconData: HGICons.HOME,
          onPressed: () {
            NavigatorUtils.goReposDetail(context, widget.userName, widget.reposName);
          },
        ),
      ),
      body: HGPullLoadWidget(
        pullLoadWidgetControl,
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
