import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [uri] outside the app (Safari, Phone). Returns whether it opened.
/// Overridden in tests.
final externalLauncherProvider = Provider<Future<bool> Function(Uri uri)>(
  (ref) =>
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
);

/// Opens the iOS share sheet with a JSON file. [origin] anchors the sheet on
/// iPad. Overridden in tests.
final fileSharerProvider =
    Provider<
      Future<void> Function({
        required String fileName,
        required String json,
        Rect? origin,
      })
    >(
      (ref) => ({required fileName, required json, origin}) async {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                Uint8List.fromList(utf8.encode(json)),
                mimeType: 'application/json',
                name: fileName,
              ),
            ],
            fileNameOverrides: [fileName],
            sharePositionOrigin: origin,
          ),
        );
      },
    );

/// "1.0.0 (3)" style version label. Overridden in tests.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version} (${info.buildNumber})';
});
