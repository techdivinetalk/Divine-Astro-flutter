import 'dart:convert';
import 'dart:io';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:http/http.dart' as http;

import 'common_functions.dart';

Future<String?> uploadImageFileToAws(File imageFile) async {
  var token = await preferenceService.getToken();

  var uri =
      Uri.parse("${ApiProvider.baseUrl}uploadImage");

  var request = http.MultipartRequest('POST', uri);

  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-type': 'application/json',
    'Accept': 'application/json',
  });

  // Attach the image file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'image',
    imageFile.path,
  ));
  request.fields.addAll({"module_name": "pooja"});

  var response = await request.send();

  // Listen for the response
  print(response);
  print("responseresponseresponse");

  if (response.statusCode == 200) {
    print("Image uploaded successfully.");
    response.stream.transform(utf8.decoder).listen((value) {
      return jsonDecode(value)["data"]
          ["full_path"]; // Handle the response from the server
    });
  } else {
    return null;
  }
}
