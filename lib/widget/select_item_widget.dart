import 'package:flutter/material.dart';
import 'package:hgbh_app/common/style/style.dart';
import 'package:hgbh_app/widget/card_item.dart';

typedef void SelectItemChanged<int>(int value);

class HGSelectItemWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final List<String> itemNames;

  final SelectItemChanged selectItemChanged;

  final RoundedRectangleBorder shape;

  final double elevation;

  final double height;

  final EdgeInsets margin;

  HGSelectItemWidget(
    this.itemNames,
    this.selectItemChanged, {
    this.elevation = 5.0,
    this.height = 70.0,
    this.shape,
    this.margin = const EdgeInsets.all(10.0),
  });

  @override
  _HGSelectItemWidgetState createState() => _HGSelectItemWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(height);
  }
}

class _HGSelectItemWidgetState extends State<HGSelectItemWidget> {
  int selectIndex = 0;

  _HGSelectItemWidgetState();

  _renderItem(String name, int index) {
    var style = index == selectIndex
        ? HGConstant.middleTextWhite
        : HGConstant.middleSubLightText;
    return new Expanded(
      child: AnimatedSwitcher(
        transitionBuilder: (child, anim) {
          return ScaleTransition(child: child, scale: anim);
        },
        duration: Duration(milliseconds: 300),
        child: RawMaterialButton(
            key: ValueKey(index == selectIndex),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: EdgeInsets.all(10.0),
            child: new Text(
              name,
              style: style,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (selectIndex != index) {
                widget.selectItemChanged?.call(index);
              }
              setState(() {
                selectIndex = index;
              });
            }),
      ),
    );
  }

  _renderList() {
    List<Widget> list = new List();
    for (int i = 0; i < widget.itemNames.length; i++) {
      if (i == widget.itemNames.length - 1) {
        list.add(_renderItem(widget.itemNames[i], i));
      } else {
        list.add(_renderItem(widget.itemNames[i], i));
        list.add(new Container(
            width: 1.0,
            height: 25.0,
            color: Color(HGColors.subLightTextColor)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new HGCardItem(
        elevation: widget.elevation,
        margin: widget.margin,
        color: Theme.of(context).primaryColor,
        shape: widget.shape ??
            new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
        child: new Row(
          children: _renderList(),
        ));
  }
}
