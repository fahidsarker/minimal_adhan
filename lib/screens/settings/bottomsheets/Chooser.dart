import 'package:flutter/material.dart';
import 'package:minimal_adhan/dragger.dart';
import 'package:minimal_adhan/extensions.dart';

Widget choosingContainer({
  required BuildContext context,
  required double percentageUpto,
  required String title,
  required List<String> titles,
  required List<String> subtitles,
  required bool Function(int) selected,
  required void Function(int) onChoosen,
}) {
  final list = [
    const SizedBox(
      height: 8.0,
    ),
    Dragger(),
    const SizedBox(
      height: 8.0,
    ),
    Text(
      title,
      style: context.textTheme.headline5
          ?.copyWith(color: context.textTheme.headline6?.color),
    ),
  ];

  for (int i = 0; i < titles.length; i++) {
    list.add(
      ListTile(
        title: Text(
          titles[i],
          textDirection: TextDirection.ltr,
        ),
        subtitle: subtitles.isNotEmpty
            ? Text(
                subtitles[i],
                textDirection: TextDirection.ltr,
              )
            : null,
        selected: selected(i),
        onTap: () {
          onChoosen(i);
        },
      ),
    );
  }

  if (subtitles.isNotEmpty) {
    assert(titles.length == subtitles.length);
  }

  //todo: check without second gesture detector
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(
      onTap: () {},
      child: DraggableScrollableSheet(
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          margin: const EdgeInsets.only(top: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: list,
            ),
          ),
        ),
      ),
    ),
  );
}
