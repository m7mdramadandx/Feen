import 'dart:io';

import 'package:Feen/services/Validate.dart';
import 'package:Feen/ui/widgets/button_widget.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:Feen/ui/widgets/textfield_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Login.dart';
import 'SignUp.dart';
import 'Verification.dart';

class PhoneInsertionScreen extends StatefulWidget {
  PhoneInsertionScreen({Key key}) : super(key: key);

  static String id = 'phoneinsertion_screen';

  @override
  _PhoneInsertionScreenState createState() => _PhoneInsertionScreenState();
}

class _PhoneInsertionScreenState extends State<PhoneInsertionScreen> {
  _PhoneInsertionScreenState();

  String phone;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    phone = "";
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      noInternetConnection();
    }
  }

  Future<bool> noInternetConnection() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: new AlertDialog(
              title: new Text('عذرا ، لا يوجد اتصال بالإنترنت',
                  style: TextStyle(fontFamily: 'Cairo', color: primaryColor)),
              content: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset('lib/assets/icons/noInternet.png')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    return Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        child: Image.asset('lib/assets/icons/sms.png'),
                        height: screenHeight * .2),
                    AutoSizeText(
                      'تسجيل رقم الهاتف',
                      textAlign: TextAlign.center,
                      style: kSloganTextStyle.apply(color: primaryColor),
                      minFontSize: 14,
                      maxFontSize: 22,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      height: screenHeight * .4,
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
                              padding: const EdgeInsets.all(4),
                              child: AutoSizeText(
                                'سوف يتم ارسال رسالة تحتوي على ستة أرقام للرقم الذي سيتم ادخاله.',
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
                                return PhoneNumberValidator.validate(value);
                              },
                              onchanged: (value) {
                                phone = value;
                              },
                              labeltext: 'رقم الهاتف',
                              prefixIcon: FlutterIcons.mobile_phone_faw,
                              obsecureText: false,
                              inputType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.topLeft,
                      child: RoundedButton(
                        onPressed: () {
                          checkInternet();
                          if (_formKey.currentState.validate()) {
                            phoneNumber();
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
        ));
  }

  void phoneNumber() async {
    showDialog(
        context: context,
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: new Text('رجاء الأنتظار',
                  style: TextStyle(fontFamily: 'Cairo', color: primaryColor)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: Container(height: 120, child: loadResult()),
            ),
          );
        });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      final AuthResult result =
          (await _auth.signInWithCredential(phoneAuthCredential));

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(result.user.uid == currentUser.uid);

      if (result.user != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SignUpScreen(phone: phone)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Fluttertoast.showToast(msg: "اعد المحاولة لاحقا");
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'عذرا, رقم الهاتف غير صحيح');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerificationScreen(
                  verificationId: verificationId, phone: phone)));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};

    await _auth.verifyPhoneNumber(
        phoneNumber: "+2$phone",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
