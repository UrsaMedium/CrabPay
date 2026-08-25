import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

void main() {
  final file = File('lib/l10n/app_en.arb');
  if (!file.existsSync()) return;

  final Map<String, dynamic> data = jsonDecode(file.readAsStringSync());
  final Map<String, dynamic> updatedData = {};

  data.forEach((key, value) {
    updatedData[key] = value;
    // If it's a standard translation key and lacks an @ counterpart, add empty metadata
    if (!key.startsWith('@') && !data.containsKey('@$key')) {
      updatedData['@$key'] = {};
    }
  });

  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(updatedData),
  );
  developer.log('Success: Added empty metadata to app_en.arb to silence warnings.');
}
