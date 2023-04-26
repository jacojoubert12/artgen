import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<String?> uploadFile(
    BuildContext context, FirebaseStorage storage) async {
  String filename = "";

  final result = await FilePicker.platform
      .pickFiles(allowMultiple: false, type: FileType.image);

  if (result == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No file was selected"),
      ),
    );
    return null;
  } else {
    final path = result.files.single.path!;
    filename = result.files.single.name;
    File file = File(path);
    int len = await file.length();
    if (len / 1000.0 / 1000.0 > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload file too large. Max size = 5MB"),
        ),
      );
      return null;
    }

    try {
      await storage.ref('uploads/$filename').putFile(file);
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
