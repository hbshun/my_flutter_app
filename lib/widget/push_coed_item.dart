import 'package:flutter/material.dart';
import 'package:hgbh_app/common/model/CommitFile.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/widget/card_item.dart';


class PushCodeItem extends StatelessWidget {
  final PushCodeItemViewModel pushCodeItemViewModel;
  final VoidCallback onPressed;

  PushCodeItem(this.pushCodeItemViewModel, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      new Container(
        ///修改文件路径
        margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 0.0),
        child: new Text(
          pushCodeItemViewModel.path,
          style: HGConstant.smallSubLightText,
        ),
      ),
      new HGCardItem(
        ///修改文件名
        margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
        child: new ListTile(
          title: new Text(pushCodeItemViewModel.name, style: HGConstant.smallSubText),
          leading: new Icon(
            HGICons.REPOS_ITEM_FILE,
            size: 15.0,
          ),
          onTap: () {
            onPressed();
          },
        ),
      ),
    ]);
  }
}

class PushCodeItemViewModel {
  String path;
  String name;
  String patch;

  String blob_url;

  PushCodeItemViewModel();

  PushCodeItemViewModel.fromMap(CommitFile map) {
    String filename = map.fileName;
    List<String> nameSplit = filename.split("/");
    name = nameSplit[nameSplit.length - 1];
    path = filename;
    patch = map.patch;
    blob_url = map.blobUrl;
  }
}
