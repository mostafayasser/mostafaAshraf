import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maglis_app/controllers/authMemory.dart';

class RevenuesController {
  void addRevenue(String type, String name, String date, String price) async {
    var uid = await AuthMemory().getPrefs();
    await Firestore.instance
        .collection("salesUsers")
        .document(uid)
        .collection('revenues')
        .add({"type": type, "name": name, "date": date, "price": price})
        .then((result) => {})
        .catchError((err) => print(err));
  }

  Future getRevenues()async {
    var uid = await AuthMemory().getPrefs();
    var data =await Firestore.instance.collection('salesUsers').document(uid).get();
    return data.data;
  }
}
