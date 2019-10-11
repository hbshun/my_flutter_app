import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:hgbh_app/common/localization/default_localizations.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/page/dynamic_page.dart';
import 'package:hgbh_app/page/my_page.dart';
import 'package:hgbh_app/page/trend_page.dart';
import 'package:hgbh_app/widget/tabbar_widget.dart';
import 'package:hgbh_app/widget/title_bar.dart';
import 'package:hgbh_app/widget/home_drawer.dart';

import '../assets/icons.dart';

class HomePage extends StatelessWidget {
  static final String sName = "home";

  /// 不退出
  Future<bool> _dialogExitApp(BuildContext context) async {
    ///如果是 android 回到桌面
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }

    return Future.value(false);
  }

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Icon(icon, size: 16.0), new Text(text)],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(HGIcons.zhudaohang_xianshanggouwu, CommonUtils.getLocale(context).tabbar_index),
      _renderTab(HGIcons.zhudaohang_fenlei, CommonUtils.getLocale(context).tabbar_category),
      _renderTab(HGIcons.zhudaohang_pinpai, CommonUtils.getLocale(context).tabbar_brand),
      _renderTab(HGIcons.zhudaohang_gouwuche, CommonUtils.getLocale(context).tabbar_shopcart),
      _renderTab(HGIcons.zhudaohang_huiyuanzhongxin, CommonUtils.getLocale(context).tabbar_my),
    ];
    ///增加返回按键监听
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new HGTabBarWidget(
        drawer: new HomeDrawer(),
        type: HGTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: [
          new DynamicPage(),
          new DynamicPage(),
          new DynamicPage(),
          new TrendPage(),
          new MyPage(),
        ],
        backgroundColor: HGColors.primarySwatch,
        indicatorColor: Color(HGColors.white),
        title: HGTitleBar(
          HGLocalizations.of(context).currentLocalized.app_name,
          iconData: HGICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onPressed: () {
            NavigatorUtils.goSearchPage(context);
          },
        ),
      ),
    );
  }
}
