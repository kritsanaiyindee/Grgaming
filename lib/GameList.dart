class GameList {
  int? statusCode;
  List<Data>? data;
  String? timestamp;

  GameList({this.statusCode, this.data, this.timestamp});

  GameList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  String? code;
  String? name;
  String? nameTh;
  String? type;
  bool? active;
  int? order;
  String? gameImageUrl;

  Data(
      {this.code,
        this.name,
        this.nameTh,
        this.type,
        this.active,
        this.order,
        this.gameImageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameTh = json['nameTh'];
    type = json['type'];
    active = json['active'];
    order = json['order'];
    gameImageUrl = json['gameImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['nameTh'] = this.nameTh;
    data['type'] = this.type;
    data['active'] = this.active;
    data['order'] = this.order;
    data['gameImageUrl'] = this.gameImageUrl;
    return data;
  }
}