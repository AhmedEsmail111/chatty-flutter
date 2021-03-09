import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(
      {required BuildContext context, required String mainPath, required String image}) async {
    return await FirebaseStorage.instance
        .ref()
        .child(mainPath)
        .child(image)
        .getDownloadURL()
        .whenComplete(() => print('done'));
  }

  // upload the image to the firebase storage
  static uploadImage({File?/*?*/ image, required String rootChild, required String/*!*/ child}) async {
    if (image != null) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child(rootChild)
          .child(child.toLowerCase());
      await reference.putFile(image).whenComplete(() => print('DONE'));
    }
  }
  // // upload the image to the firebase storage
  // void uploadImage(File image, String rootChild, String imagePath) async {
  //   if (image != null) {
  //     // String fileName = path.basename(_image.path);
  //     Reference reference =
  //     FirebaseStorage.instance.ref().child(rootChild).child(imagePath);
  //     await reference.putFile(image).whenComplete(() => print('DONE'));
  //   }
  // }
}

// // take a url and turns it to an image
//   Future<Widget> getImage(BuildContext context, String imageName) async {
//     Image image;
//     await FireStorageService.loadImage(context, imageName).then((value) {
//       image = Image.network(
//         value.toString(),
//         width: 55.0,
//         height: 55.0,
//         fit: BoxFit.fill,
//       );
//     });
//     return image;
//   }
