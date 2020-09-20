import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/message/message_page.dart';
import 'package:lol_friend_flutter/app/home/search/search_page.dart';
import 'package:lol_friend_flutter/app/home/account/account_page.dart';
import 'package:lol_friend_flutter/app/home/account/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 50,backgroundColor: Colors.white,
        bottom: TabBar(isScrollable: false,
          indicatorColor: Colors.white,
          labelColor: Color(0xFFFE3C72),
          unselectedLabelColor: Colors.grey,
          tabs: [      
            Tab(icon: Icon(EvaIcons.activity)),
            Tab(icon: Icon(EvaIcons.loaderOutline)),
            Tab(icon: Icon(EvaIcons.personOutline)),
          ],
        ),
      ),
    body: TabBarView(
    physics: NeverScrollableScrollPhysics(),
    children: [
      SearchPage(),
      MessagePage(),
      AccountPage(),
    ],
    ),
    );
  }
}