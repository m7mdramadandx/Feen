import 'package:Feen/models/userData.dart';
import 'package:Feen/services/Auth.dart';
import 'package:Feen/ui/screens/Dashboard.dart';
import 'package:Feen/ui/widgets/button_widget.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/introScreenContent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Login.dart';

class IntroductionScreen extends StatefulWidget {
  static String id = 'introscreen';

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserData currentUser;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    if (_auth.currentUser != null) {
      currentUser = await AuthServices().CurrentUser();
    } else {
      Route route = MaterialPageRoute(builder: (builder) => LoginScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ScreenContent(),
          RoundedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DashboardScreen(userSurvey: currentUser.survey);
                  },
                ),
              );
            },
            leftMarginValue: 0,
            title: 'ابدأ',
            color: primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
