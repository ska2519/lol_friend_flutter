import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';

import 'package:lol_friend_flutter/app/repositories/data_repository.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:lol_friend_flutter/app/ui/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<DataRepository>(
      create:(_) => DataRepository(
        apiService: APIService(API.development()))),
      Provider<Summoner>(
        create: (_) => Summoner(),
      )
    ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lol friend',
      theme: ThemeData(),
      home: Dashboard(),
      ),
    );
  }
}