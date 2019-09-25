import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/model/User.dart';
import 'package:hgbh_app/common/redux/state.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/widget/card_item.dart';
import 'package:redux/redux.dart';


const String user_profile_name = "名字";
const String user_profile_email = "邮箱";
const String user_profile_link = "链接";
const String user_profile_org = "公司";
const String user_profile_location = "位置";
const String user_profile_info = "简介";

class UserProfileInfo extends StatefulWidget {
  UserProfileInfo();

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileInfo> {
  _renderItem(
      IconData leftIcon, String title, String value, VoidCallback onPressed) {
    return new HGCardItem(
      child: new RawMaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(15.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new Row(
          children: <Widget>[
            new Icon(leftIcon),
            new Container(
              width: 10.0,
            ),
            new Text(title, style: HGConstant.normalSubText),
            new Container(
              width: 10.0,
            ),
            new Expanded(child: new Text(value, style: HGConstant.normalText)),
            new Container(
              width: 10.0,
            ),
            new Icon(HGICons.REPOS_ITEM_NEXT, size: 12.0),
          ],
        ),
      ),
    );
  }

  _showEditDialog(String title, String value, String key, Store store) {
    String content = value ?? "";
    CommonUtils.showEditDialog(context, title, (title) {}, (res) {
      content = res;
    }, () {
      if (content == null || content.length == 0) {
        return;
      }
      CommonUtils.showLoadingDialog(context);

      UserDao.updateUserDao({key: content}, store).then((res) {
        Navigator.of(context).pop();
        if (res != null && res.result) {
          Navigator.of(context).pop();
        }
      });
    },
        titleController: new TextEditingController(),
        valueController: new TextEditingController(text: value),
        needTitle: false);
  }

  List<Widget> _renderList(User userInfo, Store store) {
    return [
      _renderItem(Icons.info, CommonUtils.getLocale(context).user_profile_name,
          userInfo.name ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_name,
            userInfo.name, "name", store);
      }),
      _renderItem(
          Icons.email,
          CommonUtils.getLocale(context).user_profile_email,
          userInfo.email ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_email,
            userInfo.email, "email", store);
      }),
      _renderItem(Icons.link, CommonUtils.getLocale(context).user_profile_link,
          userInfo.blog ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_link,
            userInfo.blog, "blog", store);
      }),
      _renderItem(Icons.group, CommonUtils.getLocale(context).user_profile_org,
          userInfo.company ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_org,
            userInfo.company, "company", store);
      }),
      _renderItem(
          Icons.location_on,
          CommonUtils.getLocale(context).user_profile_location,
          userInfo.location ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_location,
            userInfo.location, "location", store);
      }),
      _renderItem(
          Icons.message,
          CommonUtils.getLocale(context).user_profile_info,
          userInfo.bio ?? "---", () {
        _showEditDialog(CommonUtils.getLocale(context).user_profile_info,
            userInfo.bio, "bio", store);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<HGState>(builder: (context, store) {
      return Scaffold(
        appBar: new AppBar(
            title: new Hero(
                tag: "home_user_info",
                child: new Material(
                    color: Colors.transparent,
                    child: new Text(
                      CommonUtils.getLocale(context).home_user_info,
                      style: HGConstant.normalTextWhite,
                    )))),
        body: new Container(
          color: Color(HGColors.white),
          child: new SingleChildScrollView(
            child: new Column(
              children: _renderList(store.state.userInfo, store),
            ),
          ),
        ),
      );
    });
  }
}
