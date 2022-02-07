import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/models/Tasbih.dart';

class TasbihProvider with ChangeNotifier {
  List<Tasbih> _tasbis = [];

  Future<List<Tasbih>> get allTasbih async{
    if(_tasbis.isNotEmpty){
      return [..._tasbis];
    }
    return await _fromDatabase;
  }

  Future<List<Tasbih>> get _fromDatabase async {
   /* final res = (await getSharedPref()).getStringList('tasbih_list') ?? [];
    _tasbis = res.map((e) => Tasbih.fromString(e)).toList();*/
    return _tasbis;
  }

  Future<List<Tasbih>> get _allTasbih async{
    return [
      Tasbih.create(name: "Allahu"),
      Tasbih.create(name: "Alhamdulillah"),
      Tasbih.create(name: "Allahu Akbar"),
    ];
  }

  void addNewTasbih (Tasbih tasbih) async{
    _tasbis.add(tasbih);
    notifyListeners();
    await writeToStorage;
  }

  Future get writeToStorage async{
    /*final strList = _tasbis.map((e) => e.toString()).toList();
    (await getSharedPref()).setStringList(KEY_TASBIH_LIST, strList);*/
  }

}
