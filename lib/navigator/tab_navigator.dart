import 'package:flutter/material.dart';
import 'package:my_trip/pages/home_page.dart';
import 'package:my_trip/pages/my_page.dart';
import 'package:my_trip/pages/search_page.dart';
import 'package:my_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          TravelPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _bottomNavigationBarItem('首页', Icons.home,           0),
          _bottomNavigationBarItem('搜索', Icons.search,         1),
          _bottomNavigationBarItem('旅拍', Icons.camera,         2),
          _bottomNavigationBarItem('我的', Icons.account_circle, 3),
        ],
      ),
    );
  }

  _bottomNavigationBarItem(String title, IconData iconData, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        iconData,
        color: _activeColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: _currentIndex == index ? _activeColor : _defaultColor),
      ),
    );
  }
}
