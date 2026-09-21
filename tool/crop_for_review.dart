import 'dart:io';
import 'package:image/image.dart' as img;
void main() {
  final source = img.decodeImage(File('ocr_test_whatsapp.jpeg').readAsBytesSync())!;
  final crop = img.copyCrop(source, x: 0, y: 450, width: 720, height: 700);
  final large = img.copyResize(crop, width: 1440, interpolation: img.Interpolation.cubic);
  File('ocr_test_panel.jpg').writeAsBytesSync(img.encodeJpg(large, quality: 92));
}

