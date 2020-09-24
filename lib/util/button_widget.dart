import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required this.color,
    @required this.title,
    @required this.textColor,
    @required this.leftMarginValue,
    @required this.onPressed,
    this.margin,
  });

  final Color color;
  final Color textColor;
  final String title;
  final Function onPressed;
  final double leftMarginValue;
  final Function margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .065,
      margin: EdgeInsets.only(
          left: leftMarginValue,
          bottom: MediaQuery.of(context).size.width * .05,
          right: MediaQuery.of(context).size.width * .03),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(-5, 10),
          )
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: AutoSizeText(
          title,
          minFontSize: 10,
          maxFontSize: 18,
          style: TextStyle(
            color: textColor,
            letterSpacing: 2,
            fontFamily: 'Cairo',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
