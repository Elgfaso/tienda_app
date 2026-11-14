import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../config/app_info.dart';

class HttpService {
  Future<Map<String, dynamic>> checkLatestVersionApp() async {
    try {
      final versionCode = AppInfo.versionCode;
      final url = Uri.parse(
        'https://raw.githubusercontent.com/Elgfaso/tienda_app/refs/heads/v1.1.0_3/version.json',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String lastVersionCloud = data['latest_version']; // Ej: "1.1.0"
        String lastVersionCodeCloud = data['version_code']; // Ej: "1.1.0"
        String urlDrive = data['apk_url'];

        if (lastVersionCodeCloud != versionCode) {
          return {
            'update': true,
            'url': urlDrive,
            'version': '$lastVersionCloud($lastVersionCodeCloud)',
          };
        } else {
          return {'update': false};
        }
      }
      return {'update': false};
    } catch (e) {
      return {'update': false};
    }
  }
}
