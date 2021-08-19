import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:minimal_adhan/localization/supportedLangs.dart';

String getformatDuration(Duration _left, intl.NumberFormat formatter,
    {bool showSeconds = true,
    String hour = ':',
    String minute = ':',
    String second: ''}) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = formatter.format(int.parse(twoDigits(_left.inMinutes.remainder(60))));
  String twoDigitSeconds = showSeconds ? formatter.format(int.parse(twoDigits(_left.inSeconds.remainder(60)))) : '';

  return "${formatter.format(int.parse(twoDigits(_left.inHours)))}$hour$twoDigitMinutes$minute$twoDigitSeconds$second";
}



class Countdown extends StatefulWidget {
  final DateTime to;
  final DateTime from;
  final TextStyle? style;
  final void Function()? countDownComplete;
  final String prefix;
  final String suffix;
  final String locale;
  final bool rtl;
  final intl.NumberFormat formatter;

  Countdown(this.to,
      {this.countDownComplete,
      this.style,
      this.prefix = '',
      this.suffix = '',
      required this.locale,
      required this.rtl})
      : this.from = DateTime.now(),
        formatter = intl.NumberFormat('00', locale);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Duration _left;
  late Timer _timer;

  @override
  void initState() {
    _left = widget.to.difference(widget.from);
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void updateTime() {
    _left = widget.to.difference(DateTime.now());
    if (_left.isNegative) {
      widget.countDownComplete?.call();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefix}${getformatDuration(_left, widget.formatter)}${widget.suffix}',
      style: widget.style,
    );
  }
}
