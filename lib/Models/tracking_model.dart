import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final trackingModel = trackingModelFromJson(jsonString);

import 'dart:convert';

import 'package:marathon/utils/extensions/date_extension.dart';

List<TrackingModel> trackingModelFromJson(String str) => List<TrackingModel>.from(json.decode(str).map((x) => TrackingModel.fromJson(x)));

String trackingModelToJson(List<TrackingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackingModel {
  String? id;
  String? userid;
  String? trackingid;
  String? marathonid;
  String? lat;
  String? lon;
  DateTime? createdAt;
  String? activity;
  double? distance;
  String? trackingtype;

  TrackingModel({this.id, this.userid, this.trackingid, this.marathonid, this.lat, this.lon, this.createdAt, this.activity, this.distance, this.trackingtype});

  static toDoubleVal(var distance) {
    if(distance==null){
      return 0.0;
    }
    if(distance is double){
      return distance;
    }
    if(distance is int){
      return distance.toDouble();
    }
    return 0.0;
  }

  factory TrackingModel.fromJson(Map<String, dynamic> json) => TrackingModel(
        id: json["id"],
        userid: json["userid"],
        trackingid: json["trackingid"],
        marathonid: json["marathonid"],
        lat: json["lat"],
        lon: json["lon"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).add(DateTime.now().timeZoneOffset),
        activity: json["activity"],
        distance: toDoubleVal(json["distance"]),
        trackingtype: json["trackingtype"],
        
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "trackingid": trackingid,
        "marathonid": marathonid,
        "lat": lat,
        "lon": lon,
        "createdAt": createdAt?.toIso8601String(),
        "activity": activity,
        "distance":distance,
        "trackingtype": trackingtype,
      };
}
