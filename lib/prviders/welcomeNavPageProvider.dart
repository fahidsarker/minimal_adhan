import 'package:flutter/cupertino.dart';

class WelcomeNavProvider with ChangeNotifier {
  var _currentPage = 0;
  final lastPage;

  WelcomeNavProvider(this.lastPage);

  int get currentPage {
    return _currentPage;
  }

  void changeCurrentPage(int newPage) {
    _currentPage = newPage;
    notifyListeners();
  }
}
