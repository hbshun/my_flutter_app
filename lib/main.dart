import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hgbh_app/common/event/http_error_event.dart';
import 'package:hgbh_app/common/event/index.dart';
import 'package:hgbh_app/common/localization/localizations_delegate.dart';
import 'package:hgbh_app/common/redux/state.dart';
import 'package:hgbh_app/common/model/User.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/page/home_page.dart';
import 'package:hgbh_app/page/login_page.dart';
import 'package:hgbh_app/page/welcome_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:hgbh_app/common/net/code.dart';
import 'common/event/index.dart';
import 'common/utils/navigator_utils.dart';

void main() {
  runZoned(() {
    runApp(FlutterReduxApp());
    PaintingBinding.instance.imageCache.maximumSize = 100;
    Provider.debugCheckInvalidValueType = null;
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}

// 继承无状态组件，使用第三方redux的状态管理，而不是组件自身的状态
class FlutterReduxApp extends StatelessWidget {
  /// 创建Store，引用 HGState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<HGState>(
    appReducer,
    middleware: middleware,

    ///初始化数据
    initialState: new HGState(
        userInfo: User.empty(),
        themeData: CommonUtils.getThemeData(HGColors.primarySwatch),
        locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<HGState>(builder: (context, store) {
        return new MaterialApp(

            ///多语言实现代理
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              HGLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            theme: store.state.themeData,
            routes: {
              WelcomePage.sName: (context) {
                store.state.platformLocale =
                    WidgetsBinding.instance.window.locale;
                return WelcomePage();
              },
              HomePage.sName: (context) {
                ///通过 Localizations.override 包裹一层，
                return new HGLocalizations(
                    child: NavigatorUtils.pageContainer(new HomePage()));
              },
              LoginPage.sName: (context) {
                return new HGLocalizations(
                    child: NavigatorUtils.pageContainer(new LoginPage()));
              },
            });
      }),
    );
  }
}

class HGLocalizations extends StatefulWidget {
  final Widget child;

  HGLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<HGLocalizations> createState() {
    return new _HGLocalizations();
  }
}

class _HGLocalizations extends State<HGLocalizations> {
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<HGState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_unknown +
                " " +
                message);
        break;
    }
  }
}
