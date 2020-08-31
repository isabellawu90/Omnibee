import 'package:Henfam/auth/authentication.dart';
import 'package:Henfam/pages/explore/deliveryCard.dart';
import 'package:Henfam/pages/explore/orderCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentOrders extends StatelessWidget {
  final _firestore = Firestore.instance;
  BaseAuth _auth = Auth();
  // TODO: move to main db logic file
  Future<String> _getUserId() async {
    final user = await _auth.getCurrentUser();
    return user.uid;
  }

  // TODO: move to main db logic file
  Stream<QuerySnapshot> _getUserOrders(String uid) {
    final ordersRef = _firestore.collection('orders');
    return ordersRef.where('user_id.uid', isEqualTo: uid).snapshots();
  }

  // TODO: move to main db logic file
  Stream<QuerySnapshot> _getUserDeliveries(String uid) {
    final ordersRef = _firestore.collection('orders');
    return ordersRef.where('user_id.runner', isEqualTo: uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getUserId(),
        builder: (BuildContext context, AsyncSnapshot<String> uid) {
          if (uid.hasData) {
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                StreamBuilder(
                  stream: _getUserOrders(uid.data),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    // TODO: move to main db logic file
                    return ExpansionTile(
                      title: Text(
                        'Your Orders',
                        style: TextStyle(fontSize: 18),
                      ),
                      children: snapshot.data.documents
                          .map<Widget>((doc) => OrderCard(
                                context,
                                document: doc,
                              ))
                          .toList(),
                    );
                  },
                ),
                StreamBuilder(
                  stream: _getUserDeliveries(uid.data),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ExpansionTile(
                      title: Text(
                        'Your Deliveries',
                        style: TextStyle(fontSize: 18),
                      ),
                      // TODO: move to main db logic file
                      children: snapshot.data.documents
                          .map<Widget>((doc) => DeliveryCard(
                                context,
                                document: doc,
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
