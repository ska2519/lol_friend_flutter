import 'package:flutter/material.dart';

const kSearchTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: '소환사 검색',
  fillColor: Color(0xFFFCE4EC),
  filled: true,
 enabledBorder: OutlineInputBorder(
   borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: Colors.pink, width: 1.0),
  ),
);