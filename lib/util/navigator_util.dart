import 'package:flutter/material.dart';
/// 页面跳转工具
class NavigationUtil {
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
