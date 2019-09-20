import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/redux/gsy_state.dart';
import 'package:hgbh_app/common/style/gsy_style.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:redux/redux.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<GSYState> store = StoreProvider.of(context);
    new Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      UserDao.initUserInfo(store).then((res) {
        //TODO 先前往home
        NavigatorUtils.goHome(context);
        // if (res != null && res.result) {
        // } else {
        //   NavigatorUtils.goLogin(context);
        // }
        return true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        double size = 200;
        return new Container(
          color: Color(GSYColors.white),
          child: Stack(
            children: <Widget>[
              new Center(
                child: new Image(
                    image: new AssetImage('static/images/welcome.png')),
              ),
              new Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                  width: size,
                  height: size,
                  child: new FlareActor("static/file/flare_flutter_logo_.flr",
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      animation: "Placeholder"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
