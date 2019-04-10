import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_trip/dao/home_dao.dart';
import 'package:my_trip/model/common_model.dart';
import 'package:my_trip/model/grid_nav_model.dart';
import 'package:my_trip/model/home_model.dart';
import 'package:my_trip/model/sales_box_model.dart';
import 'package:my_trip/widget/grid_nav.dart';
import 'package:my_trip/widget/loading_container.dart';
import 'package:my_trip/widget/local_nav.dart';
import 'package:my_trip/widget/sales_box.dart';
import 'package:my_trip/widget/sub_nav.dart';
import 'package:my_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  _onScroll(offset) {
    debugPrint('$offset');
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    debugPrint('$appBarAlpha');
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        bannerList = model.bannerList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: RefreshIndicator(
                  child: NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child: _listView,
                  ),
                  onRefresh: _handleRefresh
              ),
            ),
            _appBar,
          ],
        ),
      ),
    );
  }

  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.only(left: 7, top: 4, right: 7, bottom: 4),
          child: LocalNav(
            localNavList: localNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, top: 4, right: 7, bottom: 4),
          child: GridNav(
            gridNavModel: gridNavModel,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, top: 4, right: 7, bottom: 4),
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, top: 4, right: 7, bottom: 4),
          child: SalesBox(
            salesBox: salesBoxModel,
          ),
        ),
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 220.0,
      child: Swiper(
        itemCount: 3,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                CommonModel model = bannerList[index];
                return WebView(
                  url: model.url,
                  title: model.title,
                  hideAppBar: model.hideAppBar,
                );
              }));
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }
}