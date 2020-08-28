import 'package:Henfam/auth/authentication.dart';
import 'package:Henfam/pages/account/widgets/profileContact.dart';
import 'package:Henfam/pages/account/widgets/profileHeader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Following is for payments account setup. Will need to move to a different
// location after success
import 'package:url_launcher/url_launcher.dart';
import 'package:Henfam/services/paymentService.dart';

class Profile extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  Profile(this.auth, this.logoutCallback, this.userId);

  signOut() async {
    try {
      await auth.signOut();
      logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getName() async {
    final _firestore = Firestore.instance;
    final docSnapShot =
        await _firestore.collection('users').document(userId).get();
    return docSnapShot['name'];
  }

  Future<String> _getEmail() async {
    final _firestore = Firestore.instance;
    final docSnapShot =
        await _firestore.collection('users').document(userId).get();
    return docSnapShot['email'];
  }

  static void launchURL(String s) async {
    String url = s;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _setupStripeAccount() {
    print("setupStripeAccount");
    _getEmail().then((val) {
      PaymentService.createAccount(val);
      // launchURL('https://connect.stripe.com/express/onboarding/CAftIeGFz9oj');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: FutureBuilder<String>(
          future: _getName(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Center(child: Text('Loading...'));
            return ListView(
              children: <Widget>[
                ProfileHeader(snapshot.data, 'gmm22'),
                /* ProfileErrandSnapshot(),
            Divider(),
            ProfileEarnings(14.69, 3.65),
            Divider(),
            ProfilePointsBar(350),
            Divider(),
            ProfilePrefs(),
            Divider(), */
                Divider(),
                CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: Text("Setup Payments"),
                    onPressed: () {
                      _setupStripeAccount();
                    }),
                Divider(),
                ProfileContact(signOut),
              ],
            );
          }),
    );
  }
}
