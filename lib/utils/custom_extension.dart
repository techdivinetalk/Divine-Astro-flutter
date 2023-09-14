import 'package:country_state_city/country_state_city.dart';
import 'package:intl/intl.dart';

extension SearchCity on List<City> {
  List<City> search(String? value) {
    if (value == null) return this;
    return where(
      (element) =>
          element.name.toLowerCase().startsWith(value.toLowerCase().trim()) ||
          element.name.toLowerCase().contains(value.toLowerCase().trim()),
    ).toList();
  }
}

extension SearchCountry on List<Country> {
  List<Country> search(String? value) {
    if (value == null) return this;
    return where(
      (element) =>
          element.name.toLowerCase().startsWith(value.toLowerCase().trim()) ||
          element.name.toLowerCase().contains(value.toLowerCase().trim()),
    ).toList();
  }
}

extension StringToDate on String {
  DateTime toDate({String locale = "en_US"}) {
    final format = DateFormat("dd MMMM yyyy", locale);
    return format.parse(this);
  }
}

extension DateToString on DateTime {
  String toFormattedString() {
    final format = DateFormat("dd-MM-yyyy");
    return format.format(this);
  }

  String toCustomFormattedString({String locale = "en_US"}) {
    final format = DateFormat("d\'\' MMM yyyy", locale);
    return format.format(this);
  }

  String toCustomFormat() {
    String day = this.day.toString();
    String month = DateFormat.MMM().format(this);
    String year = this.year.toString();
    //String hour = DateFormat('hh').format(this);
    // String minute = DateFormat('mm').format(this);
    // String period = DateFormat('a').format(this).toUpperCase();

    String daySuffix;
    if (day.endsWith('1') && day != '11') {
      daySuffix = 'st';
    } else if (day.endsWith('2') && day != '12') {
      daySuffix = 'nd';
    } else if (day.endsWith('3') && day != '13') {
      daySuffix = 'rd';
    } else {
      daySuffix = 'th';
    }

    return '$day$daySuffix $month $year';
  }
}

/*String getOrdinalDate(DateTime dateTime){
  return  DateFormat("dd${getDayOrdinal(dateTime.day)} MMM yyyy hh:mM aa").format(dateTime);
}
String getDayOrdinal(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}*/

String? extractYoutubeVideoID(String videoUrl) {
  RegExp regExp = RegExp(
    r"(?:https?:\/\/(?:www\.)?youtube\.com\/watch\?v=|https?:\/\/youtu\.be\/)([\w-]{11})(?:&|\z|$)",
    caseSensitive: false,
    multiLine: false,
  );

  RegExpMatch? match = regExp.firstMatch(videoUrl);
  if (match != null && match.groupCount >= 1) {
    return match.group(1);
  }

  return null;
}

String getYoutubeThumbnail(String url) {
  return "https://img.youtube.com/vi/${extractYoutubeVideoID(url.toString())}/0.jpg";
}
