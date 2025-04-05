// lib/utils/objectbox_utils.dart
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:recall/objectbox.g.dart';
import 'package:recall/utils/logger.dart'; // Adjust path if needed

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
