import 'package:intl/intl.dart';


class Adhan {
  final int type;
  final String title;
  DateTime startTime;
  DateTime endTime;
  final int notifyBefore;
  bool isCurrent = false;
  final int manualCorrection;
  final String localCode;
  final DateTime startingPrayerTime;

  Adhan(
      {required this.type,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.manualCorrection,
      required this.notifyBefore,
      required this.localCode,
      required this.startingPrayerTime,
      required bool shouldCorrect}) {
    startTime = startTime.add(Duration(minutes: manualCorrection));

    if (shouldCorrect) {
      final currentTime = DateTime.now();

      if (currentTime.isAfter(DateTime(currentTime.year, currentTime.month, currentTime.day)) &&
          currentTime.isBefore(startingPrayerTime)) {
        startTime = startTime.subtract(const Duration(days: 1));
        endTime = endTime.subtract(const Duration(days: 1));
      }

      isCurrent = (DateTime.now().isAfter(startTime) &&
          DateTime.now().isBefore(endTime));
    }
  }

  String get formattedStartTime {
    return DateFormat('hh:mm a', localCode).format(startTime);
  }

  String get formattedEndTime {
    return DateFormat('hh:mm a', localCode).format(endTime);
  }


  @override
  String toString() {
    return 'Adhan{title: $title, startTime: $startTime, endTime: $endTime, isCurrent: $isCurrent}';
  }

  Duration get timeOfWaqt{
    return endTime.difference(startTime);
  }

  void modifyForNotification(){
    //final waqt = timeOfWaqt.inMinutes;
    startTime = startTime.add(Duration(minutes: notifyBefore));
    //endTime = endTime.add(Duration(minutes: notifyBefore < waqt ? (waqt*-1)+1 : notifyBefore));
    isCurrent = (DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime));
  }

}
