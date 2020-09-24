import 'package:Fen/ui/screen/Dashboard.dart';
import 'package:Fen/ui/screen/Introduction.dart';
import 'package:Fen/ui/screen/Landing.dart';
import 'package:Fen/ui/screen/Login.dart';
import 'package:Fen/ui/screen/PhoneInsertion.dart';
import 'package:Fen/ui/screen/SignUp.dart';
import 'package:Fen/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AtmFinder());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
}

class AtmFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: primaryColor,
            accentColor: primaryColor,
            textSelectionColor: lightGreen,
            cursorColor: primaryColor,
            textSelectionHandleColor: gold),
        home: LandingPage(),
        routes: {
          IntroductionScreen.id: (context) => IntroductionScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          PhoneInsertionScreen.id: (context) => PhoneInsertionScreen(),
          DashboardScreen.id: (context) => DashboardScreen(),
        });
  }
}
