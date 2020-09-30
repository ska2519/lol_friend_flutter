import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lol_friend_flutter/app/home/matches/match_page.dart';
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
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3,vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>
    (create:(_) => DataRepository(
      apiService: APIService(API.development())),
        child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
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
        body: 
        TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [    
            SearchPage(),
            MatchPage(),
            AccountPage(),
          ],
        ),
      ),
    );
  }
}
      
    
  
