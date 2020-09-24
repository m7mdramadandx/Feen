import 'package:Fen/data/model/userData.dart';
import 'package:Fen/ui/screen/ForgotPassword.dart';
import 'package:Fen/ui/screen/PhoneInsertion.dart';
import 'package:Fen/ui/service/Auth.dart';
import 'package:Fen/ui/service/Validate.dart';
import 'package:Fen/util/animation/FadeAnimation.dart';
import 'package:Fen/util/button_widget.dart';
import 'package:Fen/util/colors.dart';
import 'package:Fen/util/constants.dart';
import 'package:Fen/util/textfield_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dashboard.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static String id = 'login_page';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginScreenState();

  bool obsecureText;

  @override
  void initState() {
    super.initState();
    obsecureText = true;
  }

  final _formKey = GlobalKey<FormState>();

  String email;
  String pass;

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, screenHeight * 0.15, 16, 8),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Container(
                        child: Image.asset('lib/assets/icons/Fen Logo.png'),
                        height: screenHeight * .2),
                  ),
                  SizedBox(height: 8),
                  FadeAnimation(
                    1.2,
                    AutoSizeText(
                      'وفر وقتك. وفر مجهودك.',
                      minFontSize: 12.0,
                      maxFontSize: 18.0,
                      textAlign: TextAlign.center,
                      style: kSloganTextStyle,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  FadeAnimation(
                    1.4,
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                FadeAnimation(
                                  1.6,
                                  TextFieldWidget(
                                    validator: (value) {
                                      return EmailValidator.validate(value);
                                    },
                                    onchanged: (value) {
                                      email = value;
                                    },
                                    labeltext: 'البريد الألكتروني',
                                    hintText: 'abcd@example.com',
                                    inputType: TextInputType.emailAddress,
                                    obsecureText: false,
                                    prefixIcon: FlutterIcons.user_circle_faw5s,
                                  ),
                                ),
                                FadeAnimation(
                                  1.8,
                                  PasswordFieldWidget(
                                    onchanged: (value) {
                                      pass = value;
                                    },
                                    labeltext: 'كلمة المرور',
                                    validator: (value) {
                                      return PasswordValidator.validate(value);
                                    },
                                    obsecureText: obsecureText,
                                    prefixIcon: Ionicons.ios_lock,
                                    suffixIcon: obsecureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    onpressed: () {
                                      setState(() {
                                        obsecureText = !obsecureText;
                                      });
                                    },
                                  ),
                                ),
                                FadeAnimation(
                                  2.0,
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ForgotPasswordScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'نسيت كلمة السر؟',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  FadeAnimation(
                    2.2,
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RoundedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              signIn(email, pass);
                            }
                          },
                          title: 'تسجيل الدخول',
                          textColor: Colors.white,
                          color: primaryColor,
                          leftMarginValue: 0),
                    ),
                  ),
                  FadeAnimation(
                    2.4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(
                              fontFamily: 'Cairo', color: Colors.black87),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, PhoneInsertionScreen.id);
                            },
                            child: Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<String> signIn(String email, String password) async {
    String errorMessage;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UserData userdata = await AuthServices().CurrentUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DashboardScreen(userSurvey: userdata.survey);
          },
        ),
      );
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "البريد الأكتروني غير صحيح";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "كلمة المروم غير صحيحة";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "البريد الأكتروني غير مسجل";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "اعد المحاولة لاحقا";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
    }

    if (errorMessage != null) {
      Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
