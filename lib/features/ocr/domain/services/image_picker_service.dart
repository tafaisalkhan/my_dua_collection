enum DuaImageSource { camera, gallery }

abstract interface class DuaImagePickerService {
  Future<String?> pick(DuaImageSource source);
  Future<String?> retrieveLostImage();
}
