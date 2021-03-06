import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_trip/dao/home_dao.dart';
import 'package:my_trip/model/common_model.dart';
import 'package:my_trip/model/grid_nav_model.dart';
import 'package:my_trip/model/home_model.dart';
import 'package:my_trip/model/sales_box_model.dart';
import 'package:my_trip/pages/search_page.dart';
import 'package:my_trip/util/navigator_util.dart';
import 'package:my_trip/widget/grid_nav.dart';
import 'package:my_trip/widget/loading_container.dart';
import 'package:my_trip/widget/local_nav.dart';
import 'package:my_trip/widget/sales_box.dart';
import 'package:my_trip/widget/search_bar.dart';
import 'package:my_trip/widget/sub_nav.dart';
import 'package:my_trip/widget/webview.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

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
    Future.delayed(Duration(seconds: 3), () {
      FlutterSplashScreen.hide();
    });
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
                  onRefresh: _handleRefresh),
            ),
            _appBar,
          ],
        ),
      ),
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)],
          ),
        ),
      ],
    );
  }

  _jumpToSearch() {
    NavigationUtil.push(
      context,
      SearchPage(
        hint: SEARCH_BAR_DEFAULT_TEXT,
      ),
    );
  }

  _jumpToSpeak() {}

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
              CommonModel model = bannerList[index];
              NavigationUtil.push(
                  context,
                  WebView(
                    url: model.url,
                    title: model.title,
                    hideAppBar: model.hideAppBar,
                  ));
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
