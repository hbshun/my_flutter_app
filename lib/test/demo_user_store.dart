import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hgbh_app/common/model/User.dart';
import 'package:hgbh_app/common/redux/state.dart';

class DemoUseStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///通过 StoreConnector 关联 HGState 中的 User
    return new StoreConnector<HGState, User>(
      ///通过 converter 将 HGState 中的 userInfo返回
      converter: (store) => store.state.userInfo,
      ///在 userInfo 中返回实际渲染的控件
      builder: (context, userInfo) {
        return new Text(
          userInfo.name,
          style: Theme.of(context).textTheme.display1,
        );
      },
    );
  }
}
