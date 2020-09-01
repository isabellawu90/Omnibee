import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String name;
  final String uid;
  final GeoPoint user_coordinates;
  final String rest_name_used;
  final GeoPoint restaurant_coordinates;
  final List<Map<dynamic, dynamic>> basket;
  final String location;
  final String start_time;
  final String end_time;
  final Timestamp expiration_time;
  final bool is_accepted;
  final String runner_uid;
  final String restaurant_pic;
  final String pmID;
  final String docID;

  const OrderEntity(
    this.name,
    this.uid,
    this.user_coordinates,
    this.rest_name_used,
    this.restaurant_coordinates,
    this.basket,
    this.location,
    this.start_time,
    this.end_time,
    this.expiration_time,
    this.is_accepted,
    this.runner_uid,
    this.restaurant_pic,
    this.pmID,
    this.docID,
  );

  Map<String, Object> toJson() {
    return {
      "name": name,
      "uid": uid,
      "user_coordinates": user_coordinates,
      "rest_name_used": rest_name_used,
      "restaurant_coordinates": restaurant_coordinates,
      "basket": basket,
      "location": location,
      "start_time": start_time,
      "end_time": end_time,
      "expiration_time": expiration_time,
      "is_accepted": is_accepted,
      "runner": runner_uid,
      "restaurant_pic": restaurant_pic,
      "pmID": pmID,
      "docID": docID,
    };
  }

  @override
  List<Object> get props => [
        name,
        uid,
        user_coordinates,
        rest_name_used,
        restaurant_coordinates,
        basket,
        location,
        start_time,
        end_time,
        expiration_time,
        is_accepted,
        runner_uid,
        restaurant_pic,
        pmID,
        docID,
      ];

  @override
  String toString() {
    return 'OrderEntity { name: $name, uid: $uid, user_coordinates: $user_coordinates, rest_name_used: $rest_name_used, restaurant_coordinates: $restaurant_coordinates, basket: $basket, location: $location, start_time: $start_time, end_time: $end_time, expiration_time: $expiration_time, is_accepted: $is_accepted, runner: $runner_uid, restaurant_pic: $restaurant_pic, pmID: $pmID, docID: $docID }';
  }

  static OrderEntity fromJson(Map<String, Object> json) {
    return OrderEntity(
      json["name"] as String,
      json["uid"] as String,
      json["user_coordinates"] as GeoPoint,
      json["rest_name_used"] as String,
      json["restaurant_coordinates"] as GeoPoint,
      json["basket"] as List<Map<dynamic, dynamic>>,
      json["location"] as String,
      json["start_time"] as String,
      json["end_time"] as String,
      json["expiration_time"] as Timestamp,
      json["is_accepted"] as bool,
      json["runner_uid"] as String,
      json["restaurant_pic"] as String,
      json["pmID"] as String,
      json["docID"] as String,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "user_id": {
        "name": name,
        "uid": uid,
        "user_coordinates": user_coordinates,
        "rest_name_used": rest_name_used,
        "restaurant_coordinates": restaurant_coordinates,
        "basket": basket,
        "location": location,
        "delivery_window": {
          "start_time": start_time,
          "end_time": end_time,
        },
        "expiration_time": expiration_time,
        "is_accepted": is_accepted,
        "runner": runner_uid,
        "restaurant_pic": restaurant_pic,
        "pmID": pmID,
      }
    };
  }
}
