import 'package:image_picker/image_picker.dart';
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
  static Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
  }
}