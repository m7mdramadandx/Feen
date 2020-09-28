import 'package:Feen/models/userData.dart';
import 'package:Feen/services/Auth.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';
import 'Login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserData currentUser;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    if (await _auth.currentUser() != null) {
      currentUser = await AuthServices().CurrentUser();
      Route route = MaterialPageRoute(
          builder: (builder) =>
              DashboardScreen(userSurvey: currentUser.survey));
      Navigator.pushReplacement(context, route);
    } else {
      Route route = MaterialPageRoute(builder: (builder) => LoginScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Scaffold(backgroundColor: primaryColor);
      },
    );
  }
}
