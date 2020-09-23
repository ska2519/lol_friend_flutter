import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lol_friend_flutter/app/home/account/profile_page.dart';
import 'package:lol_friend_flutter/app/home/message/message_page.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/home/search/search_page.dart';
import 'package:lol_friend_flutter/app/home/account/account_page.dart';
import 'package:lol_friend_flutter/app/repositories/dataRepository.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

  
  final userProfile = Provider.of<UserProfile>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,backgroundColor: Colors.white,
        bottom: TabBar(
          isScrollable: false,
          indicatorColor: Colors.white,
          labelColor: Color(0xFFFE3C72),
          unselectedLabelColor: Colors.grey,
          tabs: [      
            Tab(icon: Icon(FontAwesomeIcons.burn)),
            Tab(icon: Icon(FontAwesomeIcons.meteor)),
            Tab(icon: Icon(FontAwesomeIcons.userAstronaut)),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          userProfile == null ? ProfilePage.show(context) 
                :     
                SearchPage(),
                MessagePage(),
                Provider<DataRepository>(
                      create:(_) => DataRepository(
                      apiService: APIService(API.development())),
                      child: AccountPage(),),
        ],
      ),
    );
  }
}
      
    
  
