import 'package:cloud_store/Screen/CategoryWiseImages.dart';
import 'package:cloud_store/Controllers/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController categoryEditor = TextEditingController();

  @override
  void initState() {
    categoryEditor.text = '';
    category.getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cloud Store"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Text('CATEGORY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
          (Obx(() => (category.listOfCategory.length.isEqual(0))
              ? Container(
            child: Center(
              child: Text(
                  "You havn't added any of the category.\n Start adding category"),
            ),
          )
              : Expanded(
                child: ListView.separated(
            itemCount: category.listOfCategory.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryWiseImages(
                            category: category.listOfCategory[index])));
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.photo),
                      SizedBox(
                        width: 20,
                      ),
                      Text(category.listOfCategory[index].toUpperCase()),
                    ],
                  ),
              ),
            ),
          ),
              )))
        ],
      ),
      floatingActionButton: GestureDetector(
        child: CircleAvatar(
          child: Icon(Icons.add),
        ),
        onTap: () {
          addCategory(context);
        },
      ),
    );
  }

  Future addCategory(BuildContext context) {
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
          TextFormField(
            controller: categoryEditor,
            decoration: InputDecoration(
                hintText: 'Add Category', labelText: 'Add Category'),
          ),
          ElevatedButton(
              onPressed: () async {
                await category.storeCategory(categoryEditor.text.trim());
                Navigator.pop(context);
                category.getCategory();

              },
              child: Text('Submit'))
        ],
      ),
    );
  }
}
