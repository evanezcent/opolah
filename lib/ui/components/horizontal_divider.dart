import 'package:flutter/material.dart';
import 'package:opolah/constant/constans.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    Key key,
    this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: colorPrimary,
        height: 1,
        width: width,
      ),
    );
  }
}
