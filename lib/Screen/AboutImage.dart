import 'package:cloud_store/Controllers/Category.dart';
import 'package:cloud_store/Controllers/CategoryWiseImages.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class AboutImage extends StatefulWidget {
  CategoryImage? image;
  String? category;


   AboutImage({Key? key, required this.image, this.category}) : super(key: key);

  @override
  State<AboutImage> createState() => _AboutImageState();
}

class _AboutImageState extends State<AboutImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true,
      title: Text(widget.category!),),
      body: Center(
        child: ClipRRect(borderRadius: BorderRadius.circular(5),child: PhotoView(imageProvider: NetworkImage(widget.image!.imageUrl!)),),
      ),
      bottomSheet: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text(widget.image!.about!, textAlign: TextAlign.center,)]),
    );
  }
}
