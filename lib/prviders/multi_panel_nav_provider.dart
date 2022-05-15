import 'package:flutter/cupertino.dart';
import '../screens/adhan/adhanScreen.dart';

class MultiPanelNavProvider with ChangeNotifier{
  int _currentIndex = 0;
  Widget _currentPage = const AdhanScreen();

  int get currentIndex => _currentIndex;
  Widget get currentPage => _currentPage;

  void Function()? popALl;

  void navigate(Widget page, int index){
    if(index == _currentIndex){
      return;
    }
    popALl?.call();
    _currentPage = page;
    _currentIndex = index;
    notifyListeners();
  }


}