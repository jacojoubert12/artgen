import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageListView extends StatefulWidget {
  final Set<dynamic>? selectedImages;
  final Set<String>? selectedImageUrls;
  final Function? updateSelectedImages;

  const ImageListView(
      {Key? key,
      this.updateSelectedImages,
      this.selectedImages,
      this.selectedImageUrls})
      : super(key: key);

  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  Set<dynamic>? _selectedImages;
  Set<String>? _selectedImageUrls;
  List<String> _imageUrls = [];
  List<dynamic> _images = [];

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //   FutureBuilder(
  //     future: FireStoreDataBase().getData(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text(
  //           "Something went wrong",
  //         );
  //       }
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return NetworkImage(
  //           snapshot.data.toString(),
  //         );
  //       }
  //       return const Center(child: SpinKitThreeBounce(color: Colors.pink)());
  //     },
  //   ),
  // );

  // getFireStoreImg(
  //     [String filename = "WhatsApp Image 2023-01-24 at 20.44.20.jpeg"]) {
  //   return FutureBuilder(
  //     future: storage.ref('uploads/$filename').getDownloadURL(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         print(snapshot.error);
  //         return const Text(
  //           "Something went wrong",
  //         );
  //       }
  //       if (snapshot.hasData) {
  //         print(snapshot.data.toString());
  //         // var url = snapshot.data.toString();
  //         // setState(() {
  //         //   _selectedImageUrls!.add(url);
  //         //   _selectedImages!.add(url);
  //         //   // uploading = false;
  //         // });
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return NetworkImage(
  //             snapshot.data.toString(),
  //           );
  //         }
  //       }
  //       return const Center(child: SpinKitThreeBounce(color: Colors.pink)());
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _imageUrls = _selectedImageUrls!.toList();
    _images = _selectedImages!.toList();
  }

  @override
  Widget build(BuildContext context) {
    _imageUrls = _selectedImageUrls!.toList();
    _images = _selectedImages!.toList();
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          final imageUrl = _imageUrls[index];
          final imageFull = _images[index];
          final isSelected = _selectedImageUrls!.contains(imageUrl);

          return Container(
            margin: EdgeInsets.all(1.0),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: isSelected ? Colors.blue : Colors.transparent,
            //     width: 2.0,
            //   ),
            // ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedImageUrls!.remove(imageUrl);
                    _selectedImages!.remove(imageFull);
                  } else {
                    _selectedImageUrls!.add(imageUrl);
                    _selectedImages!.add(imageFull);
                  }
                  widget.updateSelectedImages!(
                      _selectedImages, _selectedImageUrls);
                });
              },
              child: Image.network(imageUrl), //getFireStoreImg(),
            ),
          );
        },
      ),
    );
  }
}
