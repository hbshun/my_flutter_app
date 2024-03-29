import 'package:flutter/material.dart';
import 'package:hgbh_app/common/model/Event.dart';
import 'package:hgbh_app/common/model/RepoCommit.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/common/utils/event_utils.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/widget/card_item.dart';
import 'package:hgbh_app/widget/user_icon_widget.dart';
import 'package:hgbh_app/common/model/Notification.dart' as Model;

class EventItem extends StatelessWidget {
  final EventViewModel eventViewModel;

  final VoidCallback onPressed;

  final bool needImage;

  EventItem(this.eventViewModel, {this.onPressed, this.needImage = true}) : super();

  @override
  Widget build(BuildContext context) {
    Widget des = (eventViewModel.actionDes == null || eventViewModel.actionDes.length == 0)
        ? new Container()
        : new Container(
            child: new Text(
              eventViewModel.actionDes,
              style: HGConstant.smallSubText,
              maxLines: 3,
            ),
            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft);

    Widget userImage = (needImage)
        ? new HGUserIconWidget(
            padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 0.0),
            width: 30.0,
            height: 30.0,
            image: eventViewModel.actionUserPic,
            onPressed: () {
              NavigatorUtils.goPerson(context, eventViewModel.actionUser);
            })
        : Container();
    return new Container(
      child: new HGCardItem(
          child: new FlatButton(
              onPressed: onPressed,
              child: new Padding(
                padding: new EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 10.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        userImage,
                        new Expanded(child: new Text(eventViewModel.actionUser, style: HGConstant.smallTextBold)),
                        new Text(eventViewModel.actionTime, style: HGConstant.smallSubText),
                      ],
                    ),
                    new Container(
                        child: new Text(eventViewModel.actionTarget, style: HGConstant.smallTextBold),
                        margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                        alignment: Alignment.topLeft),
                    des,
                  ],
                ),
              ))),
    );
  }
}

class EventViewModel {
  String actionUser;
  String actionUserPic;
  String actionDes;
  String actionTime;
  String actionTarget;

  EventViewModel.fromEventMap(Event event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt);
    actionUser = event.actor.login;
    actionUserPic = event.actor.avatar_url;
    var other = EventUtils.getActionAndDes(event);
    actionDes = other["des"];
    actionTarget = other["actionStr"];
  }

  EventViewModel.fromCommitMap(RepoCommit eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.commit.committer.date);
    actionUser = eventMap.commit.committer.name;
    actionDes = "sha:" + eventMap.sha;
    actionTarget = eventMap.commit.message;
  }

  EventViewModel.fromNotify(BuildContext context, Model.Notification eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.updateAt);
    actionUser = eventMap.repository.fullName;
    String type = eventMap.subject.type;
    String status = eventMap.unread ? CommonUtils.getLocale(context).notify_unread : CommonUtils.getLocale(context).notify_readed;
    actionDes = eventMap.reason + "${CommonUtils.getLocale(context).notify_type}：$type，${CommonUtils.getLocale(context).notify_status}：$status";
    actionTarget = eventMap.subject.title;
  }
}
