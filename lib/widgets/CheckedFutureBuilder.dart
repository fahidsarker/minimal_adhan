import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/loading.dart';

class CheckedFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) builder;
  final Widget onLoading;
  final Widget onFailed;

  CheckedFutureBuilder(
      {required this.future,
      required this.builder,
      this.onLoading = const Loading(),
      this.onFailed = const Text("Failed")});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (_, snap) {
        final data = snap.data;
        if (data == null) {
          return onLoading;
        }

        return builder(data);

      },
    );
  }
}
