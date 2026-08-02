import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class MaterialColorExtractor {
  static Future<int?> extractColorScheme({
    required ImageProvider imageProvider,
    Size targetSize = const Size(100, 100),
  }) async {
    final ImageProvider resizedProvider = ResizeImage(
      imageProvider,
      width: targetSize.width.toInt(),
      height: targetSize.height.toInt(),
    );

    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = resizedProvider.resolve(
      const ImageConfiguration(),
    );

    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool synchronnousCall) {
        completer.complete(info.image);
        stream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    final ui.Image image = await completer.future;

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );

    if (byteData == null) {
      return null;
    }

    final Uint8List bytes = byteData.buffer.asUint8List();
    final List<int> rgbPixels = [];

    for (int i = 0; i < bytes.length; i += 4) {
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      final int rgb = (0 << 24) | (r << 16) | (g << 8) | b;
      rgbPixels.add(rgb);
    }

    final QuantizerResult result = await QuantizerCelebi().quantize(
      rgbPixels,
      16,
    );

    final List<int> rankedSeedColors = Score.score(result.colorToCount);

    final int? primarySeedRgb = rankedSeedColors.isNotEmpty
        ? rankedSeedColors.first
        : null;

    if (primarySeedRgb == null) return null;

    return primarySeedRgb;
  }
}
