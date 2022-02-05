import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class divide{
  final int a;
  final int b;

  const divide(this.a, this.b):assert(b > 5);

  double call (){
    return a/b;
  }

}

main() {

  print(const divide(1, 6)());

  /*http.Client()
      .get(Uri.parse(
          'https://www.google.com/maps/search/mosque+near+me/@22.4136245,114.1142983,10z'))
      .then((val) {
        final bosy = val.body.replaceAll('null', '').replaceAll('[', '').replaceAll(']', '').replaceAll('\\', '');
        print(bosy);
        final doc = parse(val.body);
        print(bosy.contains('Ammar'));
        //print(doc.body);
      });*/
}
