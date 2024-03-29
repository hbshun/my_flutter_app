import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hgbh_app/common/dao/repos_dao.dart';
import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/model/Event.dart';
import 'package:hgbh_app/common/model/User.dart';
import 'package:hgbh_app/common/model/UserOrg.dart';
import 'package:hgbh_app/common/utils/event_utils.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/widget/event_item.dart';
import 'package:hgbh_app/widget/pull/nested/sliver_header_delegate.dart';
import 'package:hgbh_app/widget/pull/nested/nested_refresh.dart';
import 'package:hgbh_app/widget/state/list_state.dart';
import 'package:hgbh_app/widget/user_header.dart';
import 'package:hgbh_app/widget/user_item.dart';
import 'package:provider/provider.dart';

abstract class BasePersonState<T extends StatefulWidget> extends State<T>
    with
        AutomaticKeepAliveClientMixin<T>,
        HGListState<T>,
        SingleTickerProviderStateMixin {
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey =
      new GlobalKey<NestedScrollViewRefreshIndicatorState>();

  final List<UserOrg> orgList = new List();

  final HonorModel honorModel = HonorModel();

  @override
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      refreshIKey.currentState.show().then((e) {});
      return true;
    });
  }

  @protected
  renderItem(index, User userInfo, String beStaredCount, Color notifyColor,
      VoidCallback refreshCallBack, List<UserOrg> orgList) {
    if (userInfo.type == "Organization") {
      return new UserItem(
          UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index]),
          onPressed: () {
        NavigatorUtils.goPerson(
            context,
            UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index])
                .userName);
      });
    } else {
      Event event = pullLoadWidgetControl.dataList[index];
      return new EventItem(EventViewModel.fromEventMap(event), onPressed: () {
        EventUtils.ActionUtils(context, event, "");
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @protected
  getUserOrg(String userName) {
    if (page <= 1 && userName != null) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next?.call();
        }
        return new Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

  @protected
  List<Widget> sliverBuilder(BuildContext context, bool innerBoxIsScrolled,
      User userInfo, Color notifyColor, String beStaredCount, refreshCallBack) {
    double headerSize = 210;
    double bottomSize = 70;
    double chartSize =
        (userInfo.login != null && userInfo.type == "Organization") ? 70 : 215;
    return <Widget>[
      ///头部信息
      SliverPersistentHeader(
        pinned: true,
        delegate: HGSliverHeaderDelegate(
            maxHeight: headerSize,
            minHeight: headerSize,
            changeSize: true,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              return Transform.translate(
                offset: Offset(0, -shrinkOffset),
                child: SizedBox.expand(
                  child: Container(
                    child: new UserHeaderItem(
                        userInfo, beStaredCount, Theme.of(context).primaryColor,
                        notifyColor: notifyColor,
                        refreshCallBack: refreshCallBack,
                        orgList: orgList),
                  ),
                ),
              );
            }),
      ),

      ///悬停的item
      SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: HGSliverHeaderDelegate(
            maxHeight: bottomSize,
            minHeight: bottomSize,
            changeSize: true,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              var radius = Radius.circular(10 - shrinkOffset / bottomSize * 10);
              return SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 0, right: 0),
                  /// MultiProvider 共享 HonorModel 状态
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(builder: (_) => honorModel),
                    ],
                    child: Consumer<HonorModel>(
                      builder: (context, honorModel, _) {
                        return UserHeaderBottom(userInfo,
                            honorModel.beStaredCount?.toString() ?? "---", radius, honorModel.honorList);
                      },
                    ),
                  ),
                ),
              );
            }),
      ),

      ///提交图表
      SliverPersistentHeader(
        delegate: HGSliverHeaderDelegate(
            maxHeight: chartSize,
            minHeight: chartSize,
            changeSize: true,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              return SizedBox.expand(
                child: Container(
                  height: chartSize,
                  child: UserHeaderChart(userInfo),
                ),
              );
            }),
      ),
    ];
  }

  ///获取用户仓库前100个star统计数据
  getHonor(name) {
    ReposDao.getUserRepository100StatusDao(name).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          ///提交到  Provider  HonorMode
          honorModel.beStaredCount = res.data["stared"];
          honorModel.honorList = res.data["list"];
        }
      }
    });
  }
}

/// Provider  HonorModel
class HonorModel extends ChangeNotifier {
  int _beStaredCount;

  int get beStaredCount => _beStaredCount;

  set beStaredCount(int value) {
    _beStaredCount = value;
    notifyListeners();
  }

  List _honorList;

  List get honorList => _honorList;

  set honorList(List value) {
    _honorList = value;
    notifyListeners();
  }
}
