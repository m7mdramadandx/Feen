import 'package:Feen/ui/widgets/button_widget.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import 'SignUp.dart';

// ignore: must_be_immutable
class VerificationScreen extends StatefulWidget {
  String phone;
  final String verificationId;

  VerificationScreen({this.verificationId, this.phone});

  static String id = 'verification_page';

  @override
  _VerificationScreenState createState() =>
      _VerificationScreenState(phone: phone);
}

class _VerificationScreenState extends State<VerificationScreen> {
  final String phone;
  final _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _VerificationScreenState({this.phone});

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
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
                        "الخطوة الثانية",
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
              ),
              Container(
                  child: Image.asset('lib/assets/icons/valid.png'),
                  height: screenHeight * .2),
              Center(
                child: AutoSizeText(
                  'تأكيد رقم الهاتف',
                  style: kSloganTextStyle.apply(color: primaryColor),
                  minFontSize: 14,
                  maxFontSize: 22,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: AutoSizeText(
                  'يرجى التحقق من رسائلك بحثًا عن رمز أمان مكون من ستة أرقام وإدخله في الاسفل',
                  textAlign: TextAlign.center,
                  style: kSloganTextStyle.copyWith(
                    color: Colors.black38,
                  ),
                  minFontSize: 14,
                  maxFontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: PinEntryTextField(
                    fields: 6,
                    fontSize: screenHeight * .03,
                    fieldWidth: screenWidth * .085,
                    onSubmit: (String pin) {
                      _smsController.text = pin;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.topLeft,
                child: RoundedButton(
                  onPressed: _signInWithPhoneNumber,
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
    );
  }

  void _signInWithPhoneNumber() async {
    String errorMessage;
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: widget.verificationId,
      smsCode: _smsController.text,
    );
    AuthResult result;
    await _auth.signInWithCredential(credential).then((u) async {
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(result.user.uid == currentUser.uid);
      if (result.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SignUpScreen(phone: phone)));
      } else {
        Fluttertoast.showToast(msg: "فشل في محاولة تسجيل الدخول");
      }
    }).catchError((error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_INVALID_VERIFICATION_CODE":
          errorMessage = "الرمز اللذي ادخاته غير صحيح";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
      if (errorMessage != null) {
        Fluttertoast.showToast(msg: errorMessage);
      }
    });
  }
}
