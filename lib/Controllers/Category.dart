import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category{
  var listOfCategory= <String>[].obs;
  final db = FirebaseFirestore.instance;


  getCategory() async {
    try{
      List<String> tempCategory= [];
      await db.collection('Category').get().then((value){
        value.docs.forEach((element) {
          tempCategory.add(element.data().values.first);
        });
      });
      listOfCategory.value= tempCategory;
    }catch(e){
      print(e);
      throw(e);
    }
  }

  storeCategory(String category) async{
    try{
      await db.collection('Category').add({'category': category.toLowerCase()});
    }catch(e){
      print(e);
      throw(e);
    }
  }
}
final Category category= Category();