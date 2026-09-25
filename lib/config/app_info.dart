
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String? version;
  static String? versionCode;

  static Future<void> init() async {
    final info = await getAppInfo();
    version = info.version;
    versionCode = info.buildNumber;
  }

  static Future<PackageInfo> getAppInfo() async {
    final info = await PackageInfo.fromPlatform();

    return info;
  }
}
