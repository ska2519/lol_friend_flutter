import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
    Color disabledColor = const Color(0xFFFFB5B5), color = const Color(0xFFED6A6A),
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: color,
          borderRadius: 4.0,
          onPressed: onPressed,
          disabledColor: disabledColor,

        );
}
