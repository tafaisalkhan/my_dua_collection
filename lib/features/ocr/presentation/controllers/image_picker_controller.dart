import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/device_image_picker.dart';
import '../../domain/services/image_picker_service.dart';

final imagePickerServiceProvider = Provider<DuaImagePickerService>(
  (r) => DeviceImagePicker(),
);
final imagePickerControllerProvider =
    AsyncNotifierProvider<ImagePickerController, String?>(
      ImagePickerController.new,
    );

class ImagePickerController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() =>
      ref.read(imagePickerServiceProvider).retrieveLostImage();
  Future<String?> pick(DuaImageSource source) async {
    state = const AsyncLoading();
    try {
      final p = await ref.read(imagePickerServiceProvider).pick(source);
      state = AsyncData(p);
      return p;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    }
  }
}
