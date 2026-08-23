import 'dart:io';
import 'dart:convert';

void main() async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Error: run this from the root of your project.');
    return;
  }

  // Regex looks for Text('...') or msg: '...' (handles both single and double quotes)
  final RegExp stringPattern = RegExp(r"(?:Text\(\s*|msg:\s*)(['\x22])(.*?)\1");

  final Map<String, dynamic> extractedStrings = {"@@locale": "en"};

  final List<FileSystemEntity> files = libDir.listSync(recursive: true);
  int count = 0;

  for (final file in files) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();
      final matches = stringPattern.allMatches(content);

      for (final match in matches) {
        final rawString = match.group(2); // Group 2 contains the actual text
        if (rawString != null && rawString.trim().isNotEmpty) {
          // Ignore strings that look like pure variables (e.g., '$myVar')
          if (rawString.startsWith(r'$') && !rawString.contains(' ')) continue;

          final key = _generateArbKey(rawString);
          extractedStrings[key] = rawString;
          count++;
        }
      }
    }
  }

  // Output to the standard ARB file
  final outDir = Directory('lib/l10n');
  if (!outDir.existsSync()) outDir.createSync();

  final outFile = File('lib/l10n/app_en.arb');
  await outFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(extractedStrings),
  );

  print('Success: Extracted $count strings to lib/l10n/app_en.arb');
}

/// Converts "Hello World!" into "helloWorld"
String _generateArbKey(String text) {
  final cleanText = text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  final words = cleanText
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();

  if (words.isEmpty) return 'emptyKey';

  String key = words[0].toLowerCase();
  for (int i = 1; i < words.length; i++) {
    if (i > 4) break; // Keep keys reasonably short (max 5 words)
    key +=
        words[i].substring(0, 1).toUpperCase() +
        words[i].substring(1).toLowerCase();
  }
  return key;
}
