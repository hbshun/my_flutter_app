import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hgbh_app/common/config/config.dart';
import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/local/local_storage.dart';
import 'package:hgbh_app/common/localization/default_localizations.dart';
import 'package:hgbh_app/common/redux/state.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/widget/flex_button.dart';
import 'package:hgbh_app/widget/input_widget.dart';

class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  State createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _userName = "";

  var _password = "";

  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  _LoginPageState() : super();

  @override
  void initState() {
    super.initState();
    initParams();
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
  }

  @override
  Widget build(BuildContext context) {
    ///共享 store
    return new StoreBuilder<HGState>(builder: (context, store) {
      /// 触摸收起键盘
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
            color: Theme.of(context).primaryColor,
            child: new Center(
              ///防止overFlow的现象
              child: SafeArea(
                ///同时弹出键盘不遮挡
                child: SingleChildScrollView(
                  child: new Card(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    color: Color(HGColors.cardWhite),
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: new Padding(
                      padding: new EdgeInsets.only(
                          left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Image(
                              image: new AssetImage(HGICons.DEFAULT_USER_ICON),
                              width: 90.0,
                              height: 90.0),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          new HGInputWidget(
                            hintText: CommonUtils.getLocale(context)
                                .login_username_hint_text,
                            iconData: HGICons.LOGIN_USER,
                            onChanged: (String value) {
                              _userName = value;
                            },
                            controller: userController,
                          ),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          new HGInputWidget(
                            hintText: CommonUtils.getLocale(context)
                                .login_password_hint_text,
                            iconData: HGICons.LOGIN_PW,
                            obscureText: true,
                            onChanged: (String value) {
                              _password = value;
                            },
                            controller: pwController,
                          ),
                          new Padding(padding: new EdgeInsets.all(30.0)),
                          new HGFlexButton(
                            text: CommonUtils.getLocale(context).login_text,
                            color: Theme.of(context).primaryColor,
                            textColor: Color(HGColors.textWhite),
                            onPress: () {
                              if (_userName == null || _userName.length == 0) {
                                return;
                              }
                              if (_password == null || _password.length == 0) {
                                return;
                              }
                              CommonUtils.showLoadingDialog(context);
                              UserDao.login(
                                      _userName.trim(), _password.trim(), store)
                                  .then((res) {
                                Navigator.pop(context);
                                if (res != null && res.result) {
                                  new Future.delayed(const Duration(seconds: 1),
                                      () {
                                    NavigatorUtils.goHome(context);
                                    return true;
                                  });
                                }
                              });
                            },
                          ),
                          new Padding(padding: new EdgeInsets.all(15.0)),
                          InkWell(
                            onTap: () {
                              CommonUtils.showLanguageDialog(context, store);
                            },
                            child: Text(
                              CommonUtils.getLocale(context).switch_language,
                              style: TextStyle(
                                  color: Color(HGColors.subTextColor)),
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.all(15.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
