import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/account/profile_page.dart';
import 'package:lol_friend_flutter/app/home/home_page.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'services/database.dart';

class LandingPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final userProfile = Provider.of<UserProfile>(context, listen: false); 
  
    return StreamBuilder<User>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if(userProfile==null) {
            return ProfilePage();
          } 
          
          return Provider<User>.value(
            value: user,
            child: Provider<DataBase>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}