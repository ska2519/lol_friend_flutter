import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_friend_flutter/app/landing_page.dart';
import 'package:provider/provider.dart';
import 'app/services/auth.dart';

void main() {
  // `runApp()` 전에 호출한다.
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFED6A6A),
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget { //ignore: must_be_immutable
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider<AuthBase>(
            create: (_) => Auth(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'lol friend',
              theme: ThemeData(
                fontFamily: 'Jua',
                brightness: Brightness.light,
                primaryColor: Color(0xFFED6A6A),
                accentColor: Color(0xFFA71736),
                primarySwatch: Colors.amber,
              ),
              home: DefaultTabController(
                length: 3,
                child: LandingPage(),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}