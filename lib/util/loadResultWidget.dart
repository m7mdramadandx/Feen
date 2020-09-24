import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

// ignore: camel_case_types
class loadResultWidget {
  static Widget loadResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: SpinKitChasingDots(
          size: 50,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: index.isEven ? primaryColor : grey,
              ),
            );
          },
        ),
      ),
    );
  }
  static Widget noResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: SpinKitChasingDots(
          size: 50,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: index.isEven ? error : grey,
              ),
            );
          },
        ),
      ),
    );
  }

}
