import 'package:package_info_plus/package_info_plus.dart';

late final PackageInfo packageInfo;

Future<void> initInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}
