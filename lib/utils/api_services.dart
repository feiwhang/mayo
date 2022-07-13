import 'dart:convert';

import 'package:http/http.dart' as http;

const String uri =
    "https://opend.data.go.th/get-ckan/datastore_search?resource_id=3562f2c5-2501-44a9-b32f-901867431644";

Future<List<String>> getAllOfficalGymsName() async {
  final resp = await http.get(
    Uri.parse(uri),
    headers: {
      'api-key': 'zSNSYJdOVgfEV6ehpSzCHmHxdhWXN4WV',
    },
  );

  if (resp.statusCode != 200) {
    return [];
  }

  Map<String, dynamic> json = jsonDecode(resp.body);

  List records = json['result']['records'];

  return records.map((record) => record['ชื่อค่ายมวย'] as String).toList();
}
