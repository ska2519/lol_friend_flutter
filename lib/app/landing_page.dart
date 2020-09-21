import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/home_page.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'services/database.dart';

class LandingPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    
    return StreamBuilder<User>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
         //ConnectionState.waiting ➡ ConnectionState.active
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return HomePage();
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