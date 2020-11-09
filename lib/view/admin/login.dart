import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/auth.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final user = snapshot.data;
              if (user != null) {
                return FutureBuilder<bool>(
                    future: checkLogin(user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 220,
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            // Username Login Field
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Colors.blueGrey[600].withOpacity(0.9),
                                      width: 2.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: username,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: 'Username',
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                    border: InputBorder.none),
                              ),
                            ),
                            // Password Login Field
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueGrey[600]
                                            .withOpacity(0.9),
                                        width: 2.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: password,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  await Auth().login(
                                      context, username.text, password.text);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.blueGrey[600].withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 220,
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    // Username Login Field
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueGrey[600].withOpacity(0.9),
                              width: 2.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Username',
                            hintStyle: TextStyle(fontWeight: FontWeight.w600),
                            border: InputBorder.none),
                      ),
                    ),
                    // Password Login Field
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueGrey[600].withOpacity(0.9),
                                width: 2.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          obscureText: true,
                          controller: password,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: 'Password',
                              hintStyle: TextStyle(fontWeight: FontWeight.w600),
                              border: InputBorder.none),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          await Auth()
                              .login(context, username.text, password.text);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[600].withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Future<bool> checkLogin(FirebaseUser user) async {
    print(user.uid);
    final document = await Firestore.instance
        .collection('employee')
        .document(user.uid)
        .get();

    print(document.data);
    if (!document.exists) {
      showDialog(
        context: context,
        child: Center(
          child: AlertDialog(
            title: Text('Validation Error'),
            content: Text('This user is not recognised in the System'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK!'),
              )
            ],
          ),
        ),
      );
      return false;
    }

    final userData = document.data();

    Provider.of<UserProvider>(context, listen: false)
        .setUser(User(name: userData['name'], type: userData['type']));
    if (userData['type'] == 'admin') {
      await FirebaseMessaging().subscribeToTopic('admin');
      Navigator.pushNamedAndRemoveUntil(context, '/admin', (route) => false);
    } else if (userData['type'] == 'operation') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/operation', (route) => false);
    } else if (userData['type'] == 'sales') {
      Navigator.pushNamedAndRemoveUntil(context, '/sales', (route) => false);
    } else if (userData['type'] == 'warehouse') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/warehouse', (route) => false);
    }
    return true;
  }
}
