import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// On-device NSFW moderation (free, offline)
///
/// Expects a TFLite model at assets/models/nsfw.tflite
/// Input is assumed to be [1, H, W, 3] float32 normalized to [0,1].
/// Output is assumed [1,2] (SFW, NSFW) or [1,1] (NSFW score). If shape unknown, we fail-open (allow).
class NsfwModerationService {
  static Interpreter? _interpreter;
  static int _inputSize = 224; // will try to detect from model input shape
  static bool _initializing = false;
  static bool _initialized = false;

  /// Threshold for rejection when output is a single NSFW score or the second logit of [SFW, NSFW].
  static double threshold = 0.7;

  static Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;
    try {
      // Asset path must match pubspec assets entry
      _interpreter = await Interpreter.fromAsset('assets/models/nsfw.tflite');

      // Try to infer input size from model shape, e.g. [1, 224, 224, 3]
      try {
        final input = _interpreter!.getInputTensor(0);
        final shape = input.shape; // e.g. [1, H, W, 3]
        if (shape.length >= 3) {
          // Usually index 1 is height
          _inputSize = shape[shape.length - 3];
        }
      } catch (_) {}

      _initialized = true;
    } catch (_) {
      // model not present or failed to load
      _interpreter = null;
      _initialized = false;
    } finally {
      _initializing = false;
    }
  }

  /// Returns true if image is allowed; fail-open (true) on errors.
  static Future<bool> isImageAllowed(Uint8List bytes) async {
    if (_interpreter == null) {
      await initialize();
    }
    if (_interpreter == null) {
      // Fail-open if model not available
      return true;
    }
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return true;

      // Resize to model's expected size
      final resized = img.copyResize(
        decoded,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.average,
      );

      // Build input tensor as nested lists: [1, H, W, 3] with floats in [0,1]
      final h = _inputSize;
      final w = _inputSize;
      final input = List.generate(
        1,
        (_) => List.generate(
          h,
          (_) => List.generate(
            w,
            (_) => List.filled(3, 0.0),
          ),
        ),
      );

      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final p = resized.getPixel(x, y);
          final r = p.r / 255.0;
          final g = p.g / 255.0;
          final b = p.b / 255.0;
          input[0][y][x][0] = r;
          input[0][y][x][1] = g;
          input[0][y][x][2] = b;
        }
      }

      // Prepare output per model's output shape
      final outTensor = _interpreter!.getOutputTensor(0);
      final outShape = outTensor.shape; // e.g., [1,2] or [1,1]

      if (outShape.length == 2) {
        final n = outShape[1];
        final output = List.generate(1, (_) => List.filled(n, 0.0));
        _interpreter!.run(input, output);

        double nsfwScore;
        if (n >= 2) {
          // Assume [SFW, NSFW]
          nsfwScore = output[0][1];
        } else {
          // Assume single score
          nsfwScore = output[0][0];
        }
        // Allowed when under threshold
        return nsfwScore < threshold;
      }

      if (outShape.length == 1) {
        final n = outShape[0];
        final output = List.filled(n, 0.0);
        _interpreter!.run(input, output);
        final nsfwScore = output[0];
        return nsfwScore < threshold;
      }

      // Unknown output shape -> fail-open
      return true;
    } catch (_) {
      // Any error -> fail-open
      return true;
    }
  }

  static void dispose() {
    try {
      _interpreter?.close();
    } catch (_) {}
    _interpreter = null;
    _initialized = false;
  }
}
