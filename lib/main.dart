import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_friend_flutter/app/home/home_page.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/repositories/data_repository.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
   SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF01579B),
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DataRepository>(
        create:(_) => DataRepository(
          apiService: APIService(API.development()))),
        Provider<Summoner>(
          create: (_) => Summoner(),
        ),
    ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lol friend',
      theme: ThemeData(),
      home: HomePage(),
      ),
    );
  }
}