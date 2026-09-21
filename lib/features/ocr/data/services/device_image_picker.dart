import 'package:image_picker/image_picker.dart';
import '../../domain/services/image_picker_service.dart';

class DeviceImagePicker implements DuaImagePickerService {
  DeviceImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;
  @override
  Future<String?> pick(DuaImageSource source) async => (await _picker.pickImage(
    source: source == DuaImageSource.camera
        ? ImageSource.camera
        : ImageSource.gallery,
    imageQuality: 92,
    maxWidth: 2400,
  ))?.path;
  @override
  Future<String?> retrieveLostImage() async {
    final r = await _picker.retrieveLostData();
    if (r.isEmpty || r.files == null || r.files!.isEmpty) return null;
    return r.files!.first.path;
  }
}
