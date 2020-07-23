import 'package:Henfam/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:Henfam/widgets/largeTextSection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodInfo {
  String name;
  double price;
  FoodInfo({this.name, this.price});

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };
}

class FoodDocument {
  final DocumentSnapshot document;
  final int index;
  List<FoodInfo> order;
  FoodDocument({this.document, this.index, this.order});
}

class MenuOrderForm extends StatefulWidget {
  BaseAuth auth = new Auth();

  @override
  _MenuOrderFormState createState() => _MenuOrderFormState();
}

List<String> selectedAddons = [];

class _MenuOrderFormState extends State<MenuOrderForm> {
  @override
  Widget build(BuildContext context) {
    final FoodDocument foodDoc = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        foodDoc.document['food'][foodDoc.index]['name'],
      )),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Text(
                  foodDoc.document['food'][foodDoc.index]['desc'],
                  //args.desc,
                  style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: LargeTextSection("Add-ons"),
            ),
            SliverToBoxAdapter(child: LargeTextSection("Special Requests")),
            SliverToBoxAdapter(
              child: Container(
                  child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Requests',
                ),
              )),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll:
                  true, // Set true to change overscroll behavior. Purely preference.
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: RaisedButton(
                    child: Text('Add to Cart',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).scaffoldBackgroundColor)),
                    onPressed: () {
                      if (foodDoc.order != null) {
                        foodDoc.order.add(FoodInfo(
                          name: foodDoc.document['food'][foodDoc.index]['name'],
                          price: foodDoc.document['food'][foodDoc.index]
                              ['price'],
                        ));
                      } else {
                        foodDoc.order = [
                          FoodInfo(
                            name: foodDoc.document['food'][foodDoc.index]
                                ['name'],
                            price: foodDoc.document['food'][foodDoc.index]
                                ['price'],
                          )
                        ];
                      }
                      Navigator.pop(
                          context,
                          FoodDocument(
                            document: foodDoc.document,
                            index: foodDoc.index,
                            order: foodDoc.order,
                          ));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
