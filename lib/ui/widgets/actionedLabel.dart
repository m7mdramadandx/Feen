import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';


class ActionedLabel extends StatelessWidget {
  final String requiredtext;
  final TextAlign alignment;
  final Function onTap;
  final double fontSize;

  const ActionedLabel({
    @required this.requiredtext,
    @required this.alignment,
    @required this.onTap,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .05,
      child: GestureDetector(
        child: AutoSizeText(
          requiredtext,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          maxFontSize: 18,
          minFontSize: 12,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Cairo',
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
