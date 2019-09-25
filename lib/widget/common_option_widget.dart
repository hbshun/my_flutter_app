import 'package:flutter/material.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:share/share.dart';

class HGCommonOptionWidget extends StatelessWidget {
  final List<HGOptionModel> otherList;

  final OptionControl control;

  HGCommonOptionWidget(this.control, {this.otherList});

  _renderHeaderPopItem(List<HGOptionModel> list) {
    return new PopupMenuButton<HGOptionModel>(
      child: new Icon(HGICons.MORE),
      onSelected: (model) {
        model.selected(model);
      },
      itemBuilder: (BuildContext context) {
        return _renderHeaderPopItemChild(list);
      },
    );
  }

  _renderHeaderPopItemChild(List<HGOptionModel> data) {
    List<PopupMenuEntry<HGOptionModel>> list = new List();
    for (HGOptionModel item in data) {
      list.add(PopupMenuItem<HGOptionModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }


  @override
  Widget build(BuildContext context) {
    List<HGOptionModel> list = [
      new HGOptionModel(CommonUtils.getLocale(context).option_web, CommonUtils.getLocale(context).option_web, (model) {
        CommonUtils.launchOutURL(control.url, context);
      }),
      new HGOptionModel(CommonUtils.getLocale(context).option_copy, CommonUtils.getLocale(context).option_copy, (model) {
        CommonUtils.copy(control.url ?? "", context);
      }),
      new HGOptionModel(CommonUtils.getLocale(context).option_share, CommonUtils.getLocale(context).option_share, (model) {
        Share.share(CommonUtils.getLocale(context).option_share_title + control.url ?? "");
      }),
    ];
    if (otherList != null && otherList.length > 0) {
      list.addAll(otherList);
    }
    return _renderHeaderPopItem(list);
  }
}

class OptionControl {
  String url = HGConstant.app_default_share_url;
}

class HGOptionModel {
  final String name;
  final String value;
  final PopupMenuItemSelected<HGOptionModel> selected;

  HGOptionModel(this.name, this.value, this.selected);
}
