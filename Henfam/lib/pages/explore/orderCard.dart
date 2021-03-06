import 'package:Henfam/services/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:Henfam/models/models.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(BuildContext context, {this.order});

  List<Widget> _itemsToOrder(Order order) {
    List<Widget> children = [];
    for (int i = 0; i < order.basket.length; i++) {
      children.add(ListTile(
        title: Text(
          order.basket[i]['name'],
        ),
        trailing: Text(order.basket[i]['price'].toString()),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    if (order.isComplete()) return Container();
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
            ExpansionTile(
                leading: Icon(Icons.fastfood),
                title: Text(order.name + ": " + order.restaurantName),
                subtitle: Text(order.restaurantName +
                    ": " +
                    order.startTime +
                    "-" +
                    order.endTime),
                children: _itemsToOrder(order)),
            Image(
              image: AssetImage("assets/oishii_bowl_pic1.png"),
              fit: BoxFit.cover,
            ),
            OrderCardButtonBar(order, context),
          ],
        ),
      ),
    );
  }
}

class OrderCardButtonBar extends StatelessWidget {
  final Order order;
  final BuildContext context;

  OrderCardButtonBar(this.order, this.context);

  MainAxisAlignment _getAlignment() {
    if (order.isDelivered != true) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.spaceAround;
    }
  }

  void _markOrderComplete(Order order, BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Confirming delivery, please wait one moment....'),
    );
    Scaffold.of(context).showSnackBar(snackBar);

    double pCharge = order.price;
    double applicationFee = order.applicationFee;

    print(
        "MarkOrderComplete: pcharge is $pCharge and applicationFee is $applicationFee");

    PaymentService.paymentTransfer(order, context, pCharge, applicationFee,
        order.paymentMethodId, order.stripeAccountId);
  }

  bool _isNotExpired(Order order) {
    return order.expirationTime.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch;
  }

  List<Widget> _getButtons(BuildContext context) {
    List<Widget> buttons = [
      FlatButton(
        child: const Text(
          'VIEW DETAILS',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/order_card_page', arguments: order);
        },
      ),
    ];

    if (order.isDelivered == true && _isNotExpired(order)) {
      buttons.insert(
          0,
          RaisedButton(
            color: Color(0xffFD9827),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: const Text(
              'CONFIRM DELIVERY',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              _markOrderComplete(order, context);
            },
          ));
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: _getAlignment(),
      children: _getButtons(context),
    );
  }
}
