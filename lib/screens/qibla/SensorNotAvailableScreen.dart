import 'package:flutter/cupertino.dart';

class SensorNotSupported extends StatelessWidget {
  const SensorNotSupported({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Sensors not supported'),
    );
  }
}
