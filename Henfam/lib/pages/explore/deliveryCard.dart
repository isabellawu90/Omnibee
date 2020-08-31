import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryCard extends StatelessWidget {
  final DocumentSnapshot document;

  DeliveryCard(BuildContext context, {this.document});

  void _markOrderComplete(DocumentSnapshot doc) {
    final db = Firestore.instance;
    db
        .collection('orders')
        .document(doc.documentID)
        .setData({'is_delivered': true}, merge: true);
  }

  // TODO: move to main db logic file
  bool _isOrderComplete(DocumentSnapshot doc) {
    return doc['is_delivered'] != null && doc['is_received'] != null;
  }

  // TODO: move to main db logic file
  String _getEarnings() {
    double minEarnings = 0.0;
    for (int j = 0; j < document['user_id']['basket'].length; j++) {
      minEarnings += document['user_id']['basket'][j]['price'] * .33;
    }

    return minEarnings.toStringAsFixed(2);
  }

  // TODO: move to main db logic file
  List<Widget> _itemsToOrder(DocumentSnapshot document) {
    List<Widget> children = [];
    for (int i = 0; i < document['user_id']['basket'].length; i++) {
      children.add(ListTile(
        title: Text(
          document['user_id']['basket'][i]['name'],
        ),
        trailing: Text(document['user_id']['basket'][i]['price'].toString()),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    if (_isOrderComplete(document)) return Container();
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // TODO: move to main db logic file
            ExpansionTile(
                leading: Icon(Icons.fastfood),
                title: Text(document['user_id']['name'] +
                    ": " +
                    document['user_id']['rest_name_used']),
                subtitle: Text(document['user_id']['rest_name_used'] +
                    ": " +
                    document['user_id']['delivery_window']['start_time'] +
                    "-" +
                    document['user_id']['delivery_window']['end_time'] +
                    "\nEarnings: \$${_getEarnings()}"),
                children: _itemsToOrder(document)),
            DeliveryCardButtonBar(document, context),
          ],
        ),
      ),
    );
  }
}

class DeliveryCardButtonBar extends StatelessWidget {
  final DocumentSnapshot document;
  final BuildContext context;

  DeliveryCardButtonBar(this.document, this.context);
  // TODO: move to main db logic file
  void _markOrderComplete(DocumentSnapshot doc) {
    final db = Firestore.instance;
    db
        .collection('orders')
        .document(doc.documentID)
        .setData({'is_delivered': true}, merge: true);
  }

  List<Widget> _getButtons() {
    List<Widget> buttons = [
      RaisedButton(
        color: Color(0xffFD9827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: const Text(
          'MARK DELIVERED',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () {
          _markOrderComplete(document);
        },
      ),
      FlatButton(
        child: const Text(
          'VIEW DETAILS',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/delivery_card_page',
              arguments: document);
        },
      ),
    ];

    if (document['is_delivered'] != null) {
      buttons.removeAt(0);
      buttons.insert(
        0,
        Text('Waiting for confirmation...'),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      children: _getButtons(),
    );
  }
}
