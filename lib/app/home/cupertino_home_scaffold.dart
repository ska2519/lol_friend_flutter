import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/tab_item.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:lol_friend_flutter/app/ui/dashboard.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

 

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    int currentTabIndex = 2;
    List<Widget> tabs = [
        Dashboard(),
        Dashboard(),
        Dashboard(),
    ];

    if(isIos){
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.jobs),
            _buildItem(TabItem.entry),
            _buildItem(TabItem.account),
          ],
          //enum value can be accessed by index
          onTap: (index) => onSelectTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item](context),
          );
        },
      );
    } else {
      return Scaffold(
        body: tabs[currentTabIndex],
              bottomNavigationBar: SizedBox(
                height: 90,
                child: BottomNavigationBar(
                  elevation: 0,
                  iconSize: 27.0,
                  currentIndex: currentTabIndex,
                  backgroundColor: Colors.grey[50],
                  items: [
                    _buildItem(TabItem.jobs),
                    _buildItem(TabItem.entry),
                    _buildItem(TabItem.account),
                  ],
                ),
              ),
      );
    }
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Color(0xFF0091EA) : itemData.color;
    return BottomNavigationBarItem(
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        radius: double.parse('${itemData.radius}'),
              child: Icon(
          itemData.icon,
          color: color,
          size: itemData.size,
        ),
      ),
      title: Text(
        itemData.title,
        style: TextStyle(fontSize: 1,color: color),
      ),
    );
  }
}
