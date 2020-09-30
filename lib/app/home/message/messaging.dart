import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key key, this.currentUser, this.selectedUser}) : super(key: key);
  final UserProfile currentUser, selectedUser;



  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}