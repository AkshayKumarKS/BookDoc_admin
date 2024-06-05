import 'package:flutter/foundation.dart';

class BookingProvider with ChangeNotifier {
  List<bool> _isSendList = [];

  List<bool> get isSendList => _isSendList;

  void initializeList(int length) {
    _isSendList = List<bool>.filled(length, false);
    notifyListeners();
  }

  void setSendStatus(int index, bool status) {
    _isSendList[index] = status;
    notifyListeners();
  }
}
