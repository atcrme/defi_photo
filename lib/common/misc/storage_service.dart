import 'dart:io';

import 'package:defi_photo/common/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

abstract class StorageService {
  static Future<String> uploadImage(User student, XFile image) async {
    return await uploadFile(student, File(image.path));
  }

  static Future<String> uploadFile(User student, File file) async {
    var ref = FirebaseStorage.instance
        .ref('/${student.id}/${file.hashCode}${extension(file.path)}');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
