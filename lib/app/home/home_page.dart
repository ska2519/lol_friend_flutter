import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/cupertino_home_scaffold.dart';
import 'package:lol_friend_flutter/app/home/tab_item.dart';
import 'package:lol_friend_flutter/app/ui/dashboard.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  //각 탭에 대한 global key를 배정 후 Map을 CupertinoHomeScaffold에 argument(인수)로 전달
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entry: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  //define a map that we can use to get the correct.
  //can declare the widget builders as key value pairs
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => Dashboard(),
      TabItem.entry: (context) => Dashboard(),
      TabItem.account: (_) => Dashboard(),
    };
  }

  //tab switching
  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      //pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    //Control back button on Android
    //close and return a future of type boll
    //called Every time we press on the back button
    return WillPopScope(
      //- maybePop() more than 1 route -> pop and return true / rotue 0 시 false 하지만 !<< 때문에 true
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
