// lib/utils/objectbox_utils.dart
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:recall/objectbox.g.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Future<Store?> openStore() async {
  if (kIsWeb) {
    return null;
  }
  try {
    final docsDir = await getApplicationDocumentsDirectory();
    return Store(getObjectBoxModel(), directory: '${docsDir.path}/objectbox');
  } catch (e) {
    logger.i("Error opening objectbox: $e");
    return null;
  }
}
