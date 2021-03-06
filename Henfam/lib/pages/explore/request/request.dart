import 'package:Henfam/pages/explore/request/widgets/deliveryOptions.dart';
import 'package:Henfam/pages/explore/request/widgets/locationDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Henfam/pages/explore/request/requestConfirm.dart';
import 'package:Henfam/auth/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Request extends StatefulWidget {
  final BaseAuth auth = new Auth();
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  var _deliveryDate = DateTime.now();
  var _endDeliveryDate = DateTime.now().add(new Duration(hours: 1));
  String _location = '';
  bool _place_order_disabled = true;
  Position _locationCoordinates = Position();

  void _setDeliveryDate(DateTime _newDate) {
    setState(() {
      _deliveryDate = _newDate;
    });
  }

  void _setEndDeliveryDate(DateTime _newDate) {
    setState(() {
      _endDeliveryDate = _newDate;
    });
  }

  void _setLocation(String loc, Position locationCoords) {
    setState(() {
      _location = loc;
      _locationCoordinates = locationCoords;
      _place_order_disabled = false;
    });
  }

  Future<String> _getUserID() async {
    final result = await widget.auth.getCurrentUser();
    return result.uid;
  }

  // why is this hardcoded...?
  Future<String> _getUserName(String uid) async {
    Future<String> s = Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot document) {
      return document['name'];
    });
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Request',
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: <Widget>[
                      DeliveryOptions(_setDeliveryDate, _setEndDeliveryDate),
                      LocationDetails(_setLocation),
                      // PaymentSection(),
                    ],
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: RaisedButton(
                      child: Text(
                        'Place Request',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      onPressed: () {
                        _place_order_disabled
                            ? null
                            : _getUserID().then((String s) {
                                _getUserName(s).then((String name) {
                                  StripePayment.paymentRequestWithCardForm(
                                          CardFormPaymentRequest())
                                      .then((paymentMethod) {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => RequestConfirm(
                                        _deliveryDate,
                                        _endDeliveryDate,
                                        s,
                                        _location,
                                        _locationCoordinates,
                                        name,
                                        paymentMethod.id,
                                      ),
                                    );
                                  });
                                });
                              });
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
