import 'package:flutter/foundation.dart';

class AdminMode extends ChangeNotifier{
  bool isAdmin=false;

  changeIsAdmin(bool value){
    isAdmin=value;
    notifyListeners();
  }
}