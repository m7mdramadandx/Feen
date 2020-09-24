import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'constants.dart';

class ScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    return Padding(
        padding: EdgeInsets.fromLTRB(16, screenHeight * .1, 16, 0),
        child: CarouselSlider(
            autoPlay: true,
            enableInfiniteScroll: true,
            initialPage: 0,
            reverse: false,
            viewportFraction: 1.0,
            autoPlayInterval: Duration(seconds: 7),
            autoPlayAnimationDuration: Duration(milliseconds: 600),
            pauseAutoPlayOnTouch: Duration(seconds: 15),
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            height: screenHeight * .8,
            items: [0, 1, 2].map((index) {
              return Builder(builder: (BuildContext context) {
                return LayoutBuilder(builder: (ctx, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                    Container(
                        height: constraints.maxHeight * .8,
                        child: LayoutBuilder(builder: (ctx, cns) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(imagePath[index],
                                    height: cns.maxHeight * .6),
                                SizedBox(height: cns.maxHeight * .05),
                                Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Padding(
                                        padding: EdgeInsets.all(screenHeight*0.03),
                                        child: AutoSizeText(description[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 18.0,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600),
                                            maxFontSize: 18.0,
                                            minFontSize: 12.0)))
                              ]);
                        })),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.35),
                      child: Container(
                          height: constraints.maxHeight * .03,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, int _index) {
                                return Container(
                                    margin: EdgeInsets.only(
                                        right: _index != 2 ? 16 : 0),
                                    width: screenWidth * .03,
                                    height: screenHeight * .05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: grey),
                                        shape: BoxShape.circle,
                                        color:
                                            index == _index ? gold : silver));
                              })),
                    )
                  ]);
                });
              });
            }).toList()));
  }
}
