import 'package:Henfam/pages/explore/deliveryCard.dart';
import 'package:Henfam/pages/explore/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Henfam/bloc/blocs.dart';

class PreviousOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderStateLoadSuccess) {
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            ExpansionTile(
              title: Text(
                'Your Orders',
                style: TextStyle(fontSize: 18),
              ),
              children: state
                  .getPrevUserOrders()
                  .map<Widget>((order) => OrderCard(
                        context,
                        order: order,
                      ))
                  .toList(),
            ),
            ExpansionTile(
              title: Text(
                'Your Deliveries',
                style: TextStyle(fontSize: 18),
              ),
              children: state
                  .getPrevUserDeliveries()
                  .map<Widget>((order) => DeliveryCard(
                        context,
                        order: order,
                      ))
                  .toList(),
            ),
          ],
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }
}
