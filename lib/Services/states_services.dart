import 'dart:convert';

import 'package:corona/Model/WorldStatesModel.dart';
import 'package:corona/Services/utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetchCountryList() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
