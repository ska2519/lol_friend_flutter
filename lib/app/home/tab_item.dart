import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { search, chat, account }

class TabItemData {
  const TabItemData({@required this.radius, @required this.color, @required this.title, @required this.icon, @required this.size});
  final String title;
  final IconData icon;
  final double size;
  final Color color;
  final int radius;
  

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.search: TabItemData(title: '', icon: FontAwesomeIcons.times,
    size: 30, color: Color(0xFFFE3C72),radius: 28),
    TabItem.chat: TabItemData(title: '', icon: FontAwesomeIcons.solidStar,
    size: 22, color: Color(0xFFFE3C72),radius: 21),
    TabItem.account: TabItemData(title: '', icon: FontAwesomeIcons.solidHeart, size: 28, color: Color(0xFF84F0D5),radius: 28),

    
  };
}
