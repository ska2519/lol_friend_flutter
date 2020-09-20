import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_friend_flutter/app/home/home_page.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/repositories/data_repository.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:provider/provider.dart';

import 'app/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF01579B),
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
          return MultiProvider(
            providers: [
              Provider<AuthBase>(
                create: (context) => Auth()),
              Provider<DataRepository>(
                create:(_) => DataRepository(
                apiService: APIService(API.development()))),
              Provider<Summoner>(
                create: (_) => Summoner()),
            ],
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'lol friend',
            theme: ThemeData(),
            home: DefaultTabController(
              length: 3,
              child: HomePage(),
            ),
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}