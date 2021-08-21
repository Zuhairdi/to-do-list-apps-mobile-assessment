/* This class will help to decide the string output that will be shown in the card.
*  It takes a datetime parameter and check whether the date has passed current time or not.
*  The handler will return a string accordingly, which will be used in displaying a time elapsed in the card.
*/

class TimeHandler {
  DateTime start;
  DateTime end;
  DateTime now = DateTime.now();

  TimeHandler({this.start, this.end});

  String calculate() {
    if (now.isAfter(end)) return 'Expired!';
    if (start.isAfter(now)) {
      Duration different = start.difference(now);
      int days = different.inDays;
      if (days == 0) return 'Ongoing';
      return '$days days before starting date';
    }
    Duration different = end.difference(now);
    int days = different.inDays;
    int hour = different.inHours % 24;
    int minute = different.inMinutes % 60;
    int seconds = different.inSeconds % 60;
    return '$days days $hour hours $minute minutes $seconds second';
  }
}
