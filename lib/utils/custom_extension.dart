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
    final format = DateFormat("dd MMMM yyyy", locale);
    return format.format(this);
  }
}
