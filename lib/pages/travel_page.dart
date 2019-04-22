import 'package:flutter/material.dart';
import 'package:my_trip/dao/travel_tab_dao.dart';
import 'package:my_trip/model/travel_tab_model.dart';
import 'package:my_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      _controller = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.only(left: 20, right: 10, bottom: 5),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
              ),
              tabs: tabs.map<Tab>((TravelTab tab) {
                return Tab(
                  text: tab.labelName,
                );
              }).toList(),
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _controller,
              children: tabs.map((TravelTab tab) {
                return TravelTabPage(
                  travelUrl: travelTabModel.url,
                  groupChannelCode: tab.groupChannelCode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
