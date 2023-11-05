import 'package:flutter/material.dart';
import 'package:touchbase/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(String newUser) {
    _user = userFromJson(newUser);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}