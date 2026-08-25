import 'dart:developer' as developer;
import 'dart:io';
import 'dart:convert';

void main() async {
  final arbFile = File('lib/l10n/app_en.arb');
  if (!arbFile.existsSync()) {
    developer.log('Error: app_en.arb not found.');
    return;
  }

  final Map<String, dynamic> arbData = jsonDecode(await arbFile.readAsString());
  final Map<String, String> staticStrings = {};

  // Extract only static strings (no metadata, no ICU placeholders)
  arbData.forEach((key, value) {
    if (!key.startsWith('@') && value is String && !value.contains('{')) {
      staticStrings[key] = value;
    }
  });

  final dir = Directory('lib');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  int totalReplacements = 0;

  for (final file in files) {
    String content = await file.readAsString();
    bool fileChanged = false;

    staticStrings.forEach((key, value) {
      final escapedValue = RegExp.escape(value);

      // Match Text('value') or Text("value")
      final textRegex = RegExp(
        r"Text\(\s*['\x22]" + escapedValue + r"['\x22]\s*\)",
      );
      if (textRegex.hasMatch(content)) {
        content = content.replaceAll(textRegex, 'Text(context.l10n.$key)');
        fileChanged = true;
        totalReplacements++;
      }

      // Match msg: 'value' or msg: "value" (for fluttertoast)
      final msgRegex = RegExp(r"msg:\s*['\x22]" + escapedValue + r"['\x22]");
      if (msgRegex.hasMatch(content)) {
        content = content.replaceAll(msgRegex, 'msg: context.l10n.$key');
        fileChanged = true;
        totalReplacements++;
      }
    });

    if (fileChanged) {
      // Add the l10n extension import if missing so context.l10n compiles
      if (!content.contains('l10n_extension.dart') &&
          !content.contains('app_localizations.dart')) {
        content =
            "import 'package:crabpay/core/extensions/l10n_extension.dart';\n$content";
      }
      await file.writeAsString(content);
    }
  }

  developer.log('Success: Replaced $totalReplacements static strings safely.');
}
