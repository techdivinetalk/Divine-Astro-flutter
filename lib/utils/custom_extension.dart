import 'package:country_state_city/country_state_city.dart';

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
