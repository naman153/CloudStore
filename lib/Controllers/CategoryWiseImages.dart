import 'dart:io';

import 'package:cloud_store/Controllers/CategoryWiseImages.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class CategoryImage{
  String? imageUrl;
  String? about;

CategoryImage.fromJson(Map<String, dynamic> json){
imageUrl= json['imageUrl'];
about= json['about'];
}

}

class CategoryWiseImages{
  var listOfCategoryImages= <CategoryImage>[].obs;
  final db = FirebaseFirestore.instance;

  Future<String> storeImageToCloudStorage(File file,String category, int number) async {
    var url;
    try {
      final storageRef =
      FirebaseStorage.instance.ref(category.toLowerCase() + '/' + (number+1).toString());
      await storageRef.putFile(file).whenComplete(() async {
        url = await storageRef.getDownloadURL();
        print(url);
      });
    } on FirebaseException catch (e) {
      print(e);
      url = "";
      throw (e);
    }
    return url;
  }


  getCategoryImages(String category) async {
    try{
      List<CategoryImage> tempCategory= [];
      await db.collection(category.toLowerCase()).get().then((value){
        value.docs.forEach((element) {
          tempCategory.add(CategoryImage.fromJson(element.data()));
        });
      });
      listOfCategoryImages.value= tempCategory;
    }catch(e){
      print(e);
      throw(e);
    }
  }


  storeCategoryImage(File file,String category, int number, String about) async{
    try{
      var url = await storeImageToCloudStorage(file, category, number);
      await db.collection(category.toLowerCase()).add({'imageUrl': url, 'about': about});
    }catch(e){
      print(e);
      throw(e);
    }
  }

}
CategoryWiseImages categoryWiseImages= CategoryWiseImages();