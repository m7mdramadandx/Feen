import 'package:Feen/services/Auth.dart';
import 'package:Feen/services/Validate.dart';
import 'package:Feen/ui/widgets/button_widget.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:Feen/ui/widgets/textfield_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'Login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgotpassword_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthServices authService = AuthServices();
  String email;

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Ionicons.md_arrow_round_forward,
                          color: primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 2),
                    Container(
                      child: AutoSizeText(
                        "الخطوة الأولى",
                        maxFontSize: 40,
                        minFontSize: 20.0,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: Image.asset('lib/assets/icons/lock.png'),
                    height: screenHeight * .2),
                Center(
                  child: AutoSizeText(
                    'تغيير كلمة المرور',
                    textAlign: TextAlign.center,
                    style: kSloganTextStyle.apply(color: primaryColor),
                    minFontSize: 14,
                    maxFontSize: 22,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  height: screenHeight * 0.4,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AutoSizeText(
                            'سوف يتم ارسال رسالة إلى بريدك الألكتروني تحتوي على رابط لتغيير كلمة المرور.',
                            textAlign: TextAlign.center,
                            style: kSloganTextStyle.copyWith(
                              color: Colors.black45,
                            ),
                            minFontSize: 14,
                            maxFontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFieldWidget(
                          validator: (value) {
                            return EmailValidator.validate(value);
                          },
                          onchanged: (value) {
                            email = value;
                          },
                          labeltext: 'البريد الألكتروني',
                          prefixIcon: FlutterIcons.email_outline_mco,
                          obsecureText: false,
                          inputType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RoundedButton(
                    onPressed: () {
                      authService.resetPassword(email);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                    title: 'التالي',
                    leftMarginValue: 0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
