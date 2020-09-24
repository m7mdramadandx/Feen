import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Fen/util/constants.dart';
import 'colors.dart';

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> avatar;
  final String firstName;
  final String lastName;
  final double radius;

  const ProfileHeader({
    @required this.avatar,
    @required this.firstName,
    @required this.lastName,
    @required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
      child: Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.height * .01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Avatar(
              image: avatar,
              radius: radius,
              backgroundcolor: Colors.white,
              bordercolor: primaryColor,
              borderWidth: MediaQuery.of(context).size.height * .005,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * .01,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .05,
                  child: AutoSizeText(
                    firstName,
                    style: kLabelTextStyle.copyWith(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                    maxFontSize: 22.0,
                    minFontSize: 18.0,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .04,
                  child: AutoSizeText(
                    lastName,
                    style: kLabelTextStyle.copyWith(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    maxFontSize: 18.0,
                    minFontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color bordercolor;
  final Color backgroundcolor;
  final double radius;
  final double borderWidth;

  const Avatar({
    @required this.image,
    this.bordercolor,
    this.backgroundcolor,
    this.radius = 30,
    this.borderWidth = 5,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: bordercolor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
          backgroundColor: silver,
        ),
      ),
    );
  }
}
