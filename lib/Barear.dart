class BerearToken {
  int? statusCode;
  String? data;
  String? timestamp;

  BerearToken({this.statusCode, this.data, this.timestamp});
/*
  BerearToken.fromJson(Map<String, dynamic> json) {
  statusCode = json['statusCode'];
  data = json['data'];
  timestamp = json['timestamp'];
  }

 */
  factory BerearToken.fromJson(Map<String, dynamic> parsedJson) {

    return BerearToken(
      statusCode: parsedJson['statusCode'],
      data: parsedJson['data'],
      timestamp: parsedJson['timestamp'],
    );
  }
  Map<dynamic, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['statusCode'] = this.statusCode;
  data['data'] = this.data;
  data['timestamp'] = this.timestamp;
  return data;
  }
  }