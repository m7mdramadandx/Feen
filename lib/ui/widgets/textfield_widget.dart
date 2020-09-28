import 'package:Feen/ui/widgets/constants.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class TextFieldWidget extends StatelessWidget {
  final Function onchanged;
  final String labeltext;
  final TextInputType inputType;
  final String hintText;
  final bool obsecureText;
  final IconData prefixIcon;
  final Function validator;

  const TextFieldWidget({
    @required this.onchanged,
    @required this.labeltext,
    @required this.validator,
    this.inputType,
    this.hintText,
    this.obsecureText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        validator: validator,
        textDirection: TextDirection.rtl,
        keyboardType: inputType,
        onChanged: onchanged,
        decoration: kRoundedDecoration.copyWith(
            labelText: labeltext,
            hintText: hintText,
            hintStyle: TextStyle(fontFamily: 'Cairo', color: grey),
            prefixIcon: Icon(prefixIcon, color: grey)),
      ),
    );
  }
}

class PasswordFieldWidget extends StatelessWidget {
  final Function onchanged;
  final Function onpressed;
  final String labeltext;
  final TextInputType inputType;
  final String hintText;
  final bool obsecureText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Function validator;

  const PasswordFieldWidget({
    @required this.onchanged,
    @required this.labeltext,
    @required this.validator,
    @required this.obsecureText,
    @required this.onpressed,
    this.inputType,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        validator: validator,
        textDirection: TextDirection.rtl,
        obscureText: obsecureText,
        keyboardType: inputType,
        onChanged: onchanged,
        decoration: kRoundedDecoration.copyWith(
          labelText: labeltext,
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Cairo', color: Colors.black54),
          prefixIcon: Icon(prefixIcon, color: grey),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon, color: grey),
            onPressed: onpressed,
          ),
        ),
      ),
    );
  }
}
