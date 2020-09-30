import 'package:Feen/ui/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/screens/Dashboard.dart';
import 'ui/screens/Introduction.dart';
import 'ui/screens/Landing.dart';
import 'ui/screens/Login.dart';
import 'ui/screens/PhoneInsertion.dart';
import 'ui/screens/SignUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Feen());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
}

class Feen extends StatelessWidget {
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
          textSelectionHandleColor: gold,
          fontFamily: 'Cairo',
        ),
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
