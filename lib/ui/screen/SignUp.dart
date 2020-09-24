import 'package:Fen/ui/screen/Introduction.dart';
import 'package:Fen/ui/service/Auth.dart';
import 'package:Fen/ui/service/Validate.dart';
import 'package:Fen/util/button_widget.dart';
import 'package:Fen/util/colors.dart';
import 'package:Fen/util/constants.dart';
import 'package:Fen/util/textfield_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SignUpScreen extends StatefulWidget {
  final String phone;

  SignUpScreen({this.phone});

  static String id = 'signup_page';

  @override
  _SignUpScreen createState() => _SignUpScreen(phone: this.phone);
}

class _SignUpScreen extends State<SignUpScreen> {
  final String phone;

  _SignUpScreen({this.phone});

  AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool obsecureText;

  @override
  void initState() {
    super.initState();
    obsecureText = true;
  }

  String email;
  String password;
  String confirmPassword;
  String firstName;
  String mobileNumber;
  String lastName;
  int _selected;
  String job;

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    return Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              "الخطوة الثالثة",
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
                          child: Image.asset('lib/assets/icons/form.png'),
                          height: screenHeight * .2),
                      AutoSizeText(
                        'إنشاء حساب',
                        minFontSize: 16,
                        maxFontSize: 26,
                        textAlign: TextAlign.center,
                        style: kSloganTextStyle.copyWith(
                            fontSize: 26.0, color: primaryColor),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: screenHeight * 0.5,
                        child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: SingleChildScrollView(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: <Widget>[
                                      TextFieldWidget(
                                        validator: (value) {
                                          return NameValidator.validate(value);
                                        },
                                        onchanged: (value) {
                                          firstName = value;
                                        },
                                        labeltext: 'الأسم الاول',
                                        hintText: 'الأسم الأول',
                                        obsecureText: false,
                                        prefixIcon:
                                            FlutterIcons.user_circle_faw5s,
                                      ),
                                      TextFieldWidget(
                                        validator: (value) {
                                          return NameValidator.validate(value);
                                        },
                                        onchanged: (value) {
                                          lastName = value;
                                        },
                                        labeltext: 'أسم العائلة',
                                        hintText: 'أسم العائلة',
                                        obsecureText: false,
                                        prefixIcon:
                                            FlutterIcons.user_circle_faw5s,
                                      ),
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
                                        prefixIcon:
                                            FlutterIcons.email_outline_mco,
                                      ),
                                      PasswordFieldWidget(
                                        validator: (value) {
                                          return PasswordValidator.validate(
                                              value);
                                        },
                                        onchanged: (value) {
                                          password = value;
                                        },
                                        labeltext: 'كلمة المرور',
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
                                      PasswordFieldWidget(
                                        validator: (value) {
                                          return ConfirmPasswordValidator
                                              .validate(password, value);
                                        },
                                        labeltext: 'تأكيد كلمة المرور',
                                        onchanged: (value) {
                                          confirmPassword = value;
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Radio(
                                            activeColor: lightGreen,
                                            value: 0,
                                            groupValue: _selected,
                                            onChanged: (value) {
                                              setState(() {
                                                _selected = value;
                                              });
                                            },
                                          ),
                                          Text('متقاعد',
                                              style: kLabelTextStyle),
                                          Radio(
                                            activeColor: lightGreen,
                                            value: 1,
                                            groupValue: _selected,
                                            onChanged: (value) {
                                              setState(() {
                                                _selected = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            'تعمل',
                                            style: kLabelTextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(height: 16),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: RoundedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (_selected == 0) {
                                job = 'متقاعد';
                              } else {
                                job = 'تعمل';
                              }
                              dynamic result = await _auth.createAuthUser(email,
                                  password, firstName, lastName, phone, job);
                              if (result != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            IntroductionScreen()));
                              }
                            }
                          },
                          color: primaryColor,
                          textColor: Colors.white,
                          title: 'التالي',
                          leftMarginValue: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
