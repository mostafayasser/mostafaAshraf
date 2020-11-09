import 'package:flutter/cupertino.dart';

class User {
  String name;
  String type;
  User({this.name, this.type});
}

class UserProvider with ChangeNotifier {
  User _user;
  void setName(String name) {
    _user.name = name;
    notifyListeners();
  }

  void setType(String type) {
    _user.type = type;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  User get user {
    return _user;
  }
}
