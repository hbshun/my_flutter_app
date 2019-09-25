import 'package:flutter/material.dart';

class HGBottomAppBar extends StatelessWidget {
  const HGBottomAppBar({
    this.color,
    this.fabLocation,
    this.shape,
    this.rowContents,
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;
  final List<Widget> rowContents;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      child: Row(children: rowContents),
      shape: shape,
    );
  }
}
