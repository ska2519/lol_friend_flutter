import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    Color textColor,
    Color color,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          key: key,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          borderRadius: 8.0,
          onPressed: onPressed,
        );
}
