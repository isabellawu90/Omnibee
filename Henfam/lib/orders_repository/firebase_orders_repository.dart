import 'dart:async';
import 'package:Henfam/orders_repository/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Henfam/orders_repository/orders_repository.dart';
import 'entities/entities.dart';

class FirebaseOrdersRepository implements OrdersRepository {
  final orderCollection = Firestore.instance.collection('orders');

  @override
  Future<void> addOrder(Order order) {
    return orderCollection.add(order.toEntity().toDocument());
  }

  @override
  Future<void> deleteOrder(Order order) {
    return orderCollection.document(order.docID).delete();
  }

  @override
  Future<void> updateTodo(Order order) {
    return orderCollection
        .document(order.docID)
        .updateData(order.toEntity().toDocument());
  }
}
