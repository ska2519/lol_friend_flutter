import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/search/search_page.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        //authStateChanges를 통해 보여주는 페이지 변경
        stream: auth.authStateChanges,
        builder: (context, snapshot) {
          print('$snapshot'); //ConnectionState.waiting ➡ ConnectionState.active
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            //value로 추가 provider 장착
            return Provider<User>.value(
              value: user,
              child: Provider<DataBase>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: SearchPage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
