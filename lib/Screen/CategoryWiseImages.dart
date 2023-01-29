import 'dart:io';

import 'package:cloud_store/Controllers/CategoryWiseImages.dart';
import 'package:cloud_store/Screen/AboutImage.dart';
import 'package:cloud_store/Utils/Snackbars.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CategoryWiseImages extends StatefulWidget {
  String category;

  CategoryWiseImages({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryWiseImages> createState() => _CategoryWiseImagesState();
}

class _CategoryWiseImagesState extends State<CategoryWiseImages> {
  File editImage = File('');
  TextEditingController categoryTextEditor = TextEditingController();

  @override
  void initState() {
    categoryTextEditor.text = '';
    categoryWiseImages.getCategoryImages(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.toUpperCase()),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'CATEGORY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            (Obx(() => (categoryWiseImages.listOfCategoryImages.length
                    .isEqual(0))
                ? Container(
                    child: Center(
                      child: Text(
                          "You havn't added any image in category.\n Start adding images"),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (15/18)
                        ),
                        shrinkWrap: true,
                        controller: ScrollController(keepScrollOffset: true),
                        itemCount:
                            categoryWiseImages.listOfCategoryImages.length,
                        itemBuilder: (context, index) => GestureDetector(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutImage(image: categoryWiseImages.listOfCategoryImages[index], category: widget.category,)));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image(
                                        image: NetworkImage(categoryWiseImages
                                            .listOfCategoryImages[index]
                                            .imageUrl!),
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 150,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ExpandableText(
                                        categoryWiseImages
                                                .listOfCategoryImages[index]
                                                .about!,
                                        expandText: 'read more',
                                        maxLines: 1,
                                        linkColor: Colors.black,
                                        linkStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  )))
          ],
        ),
        floatingActionButton: GestureDetector(
          child: CircleAvatar(
            child: Icon(Icons.add),
          ),
          onTap: () {
            addCategoryImage(context);
          },
        ));
  }

  pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source:
              ImageSource.gallery); // add image quality and other parameters
      if (image == null) return;
      final imagetemporary = File(image.path);
      setState(() => this.editImage = imagetemporary);
    } on PlatformException catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  uploadImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera); // add image quality and other parameters
      if (image == null) return;
      final imagetemporary = File(image.path);
      setState(() => this.editImage = imagetemporary);
    } on PlatformException catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  Future addCategoryImage(BuildContext context) {
    return showSlidingBottomSheet(context,
        resizeToAvoidBottomInset: true,
        builder: (context) => SlidingSheetDialog(
              isDismissable: true,
              color: Colors.white,
              cornerRadius: 16,
              avoidStatusBar: true,
              snapSpec: const SnapSpec(
                snappings: [0.7],
              ),
              headerBuilder: (context, state) {
                return Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Container(
                      width: 40, height: 6, color: Colors.grey.shade50),
                );
              },
              builder: (context, state) => Material(child: categoryForm()),
            ));
  }

  Widget categoryForm() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Add Images:',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  var isLoading;
                  try {
                    await uploadImage();
                    isLoading = ScaffoldMessenger.of(context)
                        .showSnackBar(sbLoading('Updating Profile Picture.'));
                    isLoading.close();
                    ScaffoldMessenger.of(context).showSnackBar(
                        sbSuccess('Picture Successfully Updated.'));
                  } catch (e) {
                    isLoading.close();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(sbError('Error while updating picture.'));
                    throw (e);
                  }
                  setState(() {});
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.folder,
                  size: 30,
                ),
                onPressed: () async {
                  var isLoading;
                  try {
                    await pickImage();

                    isLoading = ScaffoldMessenger.of(context)
                        .showSnackBar(sbLoading('Updating Profile Picture.'));
                    isLoading.close();
                    ScaffoldMessenger.of(context).showSnackBar(
                        sbSuccess('Picture Successfully Updated.'));
                  } catch (e) {
                    isLoading.close();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(sbError('Error while updating picture.'));
                    throw (e);
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          TextFormField(
            controller: categoryTextEditor,
            decoration: InputDecoration(
                hintText: 'About the image..', labelText: 'About Image'),
          ),
          ElevatedButton(
              onPressed: () async {
                await categoryWiseImages.storeCategoryImage(
                    editImage,
                    widget.category,
                    categoryWiseImages.listOfCategoryImages.length,
                    categoryTextEditor.text);
                Navigator.pop(context);
                categoryWiseImages.getCategoryImages(widget.category);
              },
              child: Text('Submit'))
        ],
      ),
    );
  }


}
