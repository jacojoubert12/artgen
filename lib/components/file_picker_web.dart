import 'dart:typed_data';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<String?> uploadFile(
    BuildContext context, FirebaseStorage storage) async {
  String filename = "";
  final result = await FilePickerWeb.platform
      .pickFiles(allowMultiple: false, type: FileType.image);

  if (result == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No file was selected"),
      ),
    );
    return null;
  } else {
    Uint8List uploadFile = result.files.single.bytes!;
    filename = result.files.single.name;
    if (uploadFile.length / 1000.0 / 1000.0 > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload file too large. Max size = 5MB"),
        ),
      );
      print("upload size too large");
      return null;
    }

    try {
      await storage
          .ref('uploads/$filename')
          .putData(uploadFile, SettableMetadata(contentType: 'image/png'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload completed")),
      );
      print("Upload done");
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  return await storage.ref('uploads/$filename').getDownloadURL();
}
