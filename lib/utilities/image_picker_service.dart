import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // launching the camera and getting the photo he is
  // gonna capture back ana assign it to the our image variable
  static Future<File?> imgFromCamera() async {
    File? file;
    try {
      PickedFile image = (await (ImagePicker()
          .getImage(source: ImageSource.camera, imageQuality: 40)))!;

      file = File(image.path);
    } catch (e) {
      print(e);
    }
    return file;
  }

  // launching the library and getting the photo he is
  // gonna choose back ana assign it to the our image variable
  static Future<File?> imgFromGallery() async {
    File? file;
    try {
      PickedFile image = (await (ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 45)))!;

      file = File(image.path);
    } catch (e) {
      print(e);
    }
    return file;
  }
}
