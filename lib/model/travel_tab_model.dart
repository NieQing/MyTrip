/// 旅拍类别模型
class TravelTabModel {
  String url;
  List<TravelTab> tabs;

  TravelTabModel({this.url, this.tabs});

  TravelTabModel.fromJson(Map<String, dynamic> json) {
    this.url = json['url'];
    this.tabs = (json['tabs'] as List) != null
        ? (json['tabs'] as List).map((i) => TravelTab.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['tabs'] =
        this.tabs != null ? this.tabs.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class TravelTab {
  String labelName;
  String groupChannelCode;

  TravelTab({this.labelName, this.groupChannelCode});

  TravelTab.fromJson(Map<String, dynamic> json) {
    this.labelName = json['labelName'];
    this.groupChannelCode = json['groupChannelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelName'] = this.labelName;
    data['groupChannelCode'] = this.groupChannelCode;
    return data;
  }
}

class HeadBean {
  String cid;
  String ctok;
  String cver;
  String lang;
  String sid;
  String syscode;
  String auth;
  List<ExtensionListBean> extension;

  HeadBean(
      {this.cid,
      this.ctok,
      this.cver,
      this.lang,
      this.sid,
      this.syscode,
      this.auth,
      this.extension});

  HeadBean.fromJson(Map<String, dynamic> json) {
    this.cid = json['cid'];
    this.ctok = json['ctok'];
    this.cver = json['cver'];
    this.lang = json['lang'];
    this.sid = json['sid'];
    this.syscode = json['syscode'];
    this.auth = json['auth'];
    this.extension = (json['extension'] as List) != null
        ? (json['extension'] as List)
            .map((i) => ExtensionListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['ctok'] = this.ctok;
    data['cver'] = this.cver;
    data['lang'] = this.lang;
    data['sid'] = this.sid;
    data['syscode'] = this.syscode;
    data['auth'] = this.auth;
    data['extension'] = this.extension != null
        ? this.extension.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class PageParaBean {
  int pageIndex;
  int pageSize;
  int sortType;
  int sortDirection;

  PageParaBean(
      {this.pageIndex, this.pageSize, this.sortType, this.sortDirection});

  PageParaBean.fromJson(Map<String, dynamic> json) {
    this.pageIndex = json['pageIndex'];
    this.pageSize = json['pageSize'];
    this.sortType = json['sortType'];
    this.sortDirection = json['sortDirection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['sortType'] = this.sortType;
    data['sortDirection'] = this.sortDirection;
    return data;
  }
}

class ExtensionListBean {
  String name;
  String value;

  ExtensionListBean({this.name, this.value});

  ExtensionListBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
