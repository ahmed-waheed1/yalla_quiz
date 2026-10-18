import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The app name shown by each platform: "Yalla Quiz", and "يلا كويز" where the
/// platform localizes it (Android values-ar, iOS ar.lproj).
void main() {
  String read(String path) => File(path).readAsStringSync();

  test('Android: label comes from strings.xml (en + ar)', () {
    expect(
      read('android/app/src/main/AndroidManifest.xml'),
      contains('android:label="@string/app_name"'),
    );
    expect(
      read('android/app/src/main/res/values/strings.xml'),
      contains('<string name="app_name">Yalla Quiz</string>'),
    );
    expect(
      read('android/app/src/main/res/values-ar/strings.xml'),
      contains('<string name="app_name">يلا كويز</string>'),
    );
  });

  test('iOS: display name localized via InfoPlist.strings, bundled by Xcode', () {
    expect(
      read('ios/Runner/en.lproj/InfoPlist.strings'),
      contains('"CFBundleDisplayName" = "Yalla Quiz";'),
    );
    expect(
      read('ios/Runner/ar.lproj/InfoPlist.strings'),
      contains('"CFBundleDisplayName" = "يلا كويز";'),
    );
    final plist = read('ios/Runner/Info.plist');
    expect(plist, contains('<key>CFBundleLocalizations</key>'));
    expect(plist, contains('<string>ar</string>'));
    final project = read('ios/Runner.xcodeproj/project.pbxproj');
    expect(project, contains('path = en.lproj/InfoPlist.strings'));
    expect(project, contains('path = ar.lproj/InfoPlist.strings'));
    expect(project, contains('InfoPlist.strings in Resources */,'));
    expect(RegExp(r'knownRegions = \([^)]*\bar,', multiLine: true).hasMatch(project), isTrue);
  });

  test('Web: title and manifest name', () {
    final html = read('web/index.html');
    expect(html, contains('<title>Yalla Quiz</title>'));
    expect(html, contains('content="Yalla Quiz"'));
    final manifest = jsonDecode(read('web/manifest.json')) as Map<String, dynamic>;
    expect(manifest['name'], 'Yalla Quiz');
    expect(manifest['short_name'], 'Yalla Quiz');
  });
}
