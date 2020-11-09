import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maglis_app/controllers/authMemory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:provider/provider.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login(context, email, password) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Color.fromRGBO(170, 44, 94, 1)),
      ),
    ));
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      final document = await Firestore.instance
          .collection('employee')
          .document(user.uid)
          .get();

      if (!document.exists) {
        Get.dialog(
          Center(
            child: AlertDialog(
              title: Text('Validation Error'),
              content: Text('This user is not recognised in the System'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('OK!'),
                )
              ],
            ),
          ),
        );
        FirebaseAuth.instance.signOut();
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
      print("Success");
      return true;
    } catch (e) {
      Get.back();
      print(e.message);
      print("Failed");
      return false;
    }
  }
}
