import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class PageViewModel extends StatelessWidget {
  final String title;
  final Widget bodyWidget;
  final Widget image;

  PageViewModel(
      {required this.title, required this.bodyWidget, required this.image});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: image,
            ),
            SizedBox(
              height: 64,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: AutoSizeText(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            bodyWidget
          ],
        ),
      ),
    );
  }
}
