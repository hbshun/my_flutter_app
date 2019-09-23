import 'package:flutter/material.dart';
import 'package:hgbh_app/common/dao/repos_dao.dart';
import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/utils/common_utils.dart';
import 'package:hgbh_app/common/utils/navigator_utils.dart';
import 'package:hgbh_app/widget/state/base_person_state.dart';
import 'package:hgbh_app/widget/state/gsy_list_state.dart';
import 'package:hgbh_app/widget/pull/gsy_pull_load_widget.dart';
import 'package:hgbh_app/widget/repos_item.dart';
import 'package:hgbh_app/widget/user_item.dart';
import 'package:provider/provider.dart';

class HonorListPage extends StatefulWidget {

  final List list;

  HonorListPage(this.list);

  @override
  _HonorListPageState createState() => _HonorListPageState();
}

class _HonorListPageState extends State<HonorListPage> {
  _renderItem(item) {
    ReposViewModel reposViewModel = ReposViewModel.fromMap(item);
    return new ReposItem(reposViewModel, onPressed: () {
      NavigatorUtils.goReposDetail(
          context, reposViewModel.ownerName, reposViewModel.repositoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(
            CommonUtils
                .getLocale(context)
                .user_tab_honor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _renderItem(widget.list[index]);
        },
        itemCount: widget.list.length,
      ),);
  }
}
