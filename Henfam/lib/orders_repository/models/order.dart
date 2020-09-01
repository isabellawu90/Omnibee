import 'package:Henfam/orders_repository/entities/order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Order {
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

  Order(
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

  Order copyWith(
      {String name,
      String uid,
      GeoPoint user_coordinates,
      String rest_name_used,
      GeoPoint restaurant_coordinates,
      List<Map<dynamic, dynamic>> basket,
      String location,
      String start_time,
      String end_time,
      Timestamp expiration_time,
      bool is_accepted,
      String runner_uid,
      String restaurant_pic,
      String pmID,
      String docID}) {
    return Order(
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
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      uid.hashCode ^
      user_coordinates.hashCode ^
      rest_name_used.hashCode ^
      restaurant_coordinates.hashCode ^
      basket.hashCode ^
      location.hashCode ^
      start_time.hashCode ^
      end_time.hashCode ^
      expiration_time.hashCode ^
      is_accepted.hashCode ^
      runner_uid.hashCode ^
      restaurant_pic.hashCode ^
      pmID.hashCode ^
      docID.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid &&
          user_coordinates == other.user_coordinates &&
          rest_name_used == other.rest_name_used &&
          restaurant_coordinates == other.restaurant_coordinates &&
          basket == other.basket &&
          location == other.location &&
          start_time == other.start_time &&
          end_time == other.end_time &&
          expiration_time == other.expiration_time &&
          is_accepted == other.is_accepted &&
          runner_uid == other.runner_uid &&
          restaurant_pic == other.restaurant_pic &&
          pmID == other.pmID &&
          docID == other.docID;

  @override
  String toString() {
    return 'Order { name: $name, uid: $uid, user_coordinates: $user_coordinates, rest_name_used: $rest_name_used, restaurant_coordinates: $restaurant_coordinates, basket: $basket, location: $location, start_time: $start_time, end_time: $end_time, expiration_time: $expiration_time, is_accepted: $is_accepted, runner: $runner_uid, restaurant_pic: $restaurant_pic, pmID: $pmID, docID: $docID }';
  }

  OrderEntity toEntity() {
    return OrderEntity(
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
    );
  }

  static Order fromEntity(OrderEntity entity) {
    return Order(
      entity.name,
      entity.uid,
      entity.user_coordinates,
      entity.rest_name_used,
      entity.restaurant_coordinates,
      entity.basket,
      entity.location,
      entity.start_time,
      entity.end_time,
      entity.expiration_time,
      entity.is_accepted,
      entity.runner_uid,
      entity.restaurant_pic,
      entity.pmID,
      entity.docID,
    );
  }
}
