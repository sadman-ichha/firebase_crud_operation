// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _detailsEditingController = TextEditingController();
  XFile? _courseImage;
  String? imageUrl;

  chooseImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  writeData() async {
    File _imgFile = File(_courseImage!.path);
    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _upLoadTask =
        _storage.ref("Image").child(_courseImage!.name).putFile(_imgFile);
    TaskSnapshot snapshot = await _upLoadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);
    CollectionReference _course =
        FirebaseFirestore.instance.collection("courses");
    _course.add({
      'course_name': _titleEditingController.text,
      'course_details': _detailsEditingController.text,
      'image': imageUrl,
    });
    print("Successfully Added");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(
                hintText: "course title",
              ),
            ),
            TextField(
              controller: _detailsEditingController,
              decoration: InputDecoration(
                hintText: "course details",
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: Center(
                child: Material(
                  child: _courseImage == null
                      ? IconButton(
                          onPressed: () => chooseImageFromGallery(),
                          icon: Icon(Icons.add_photo_alternate_outlined),
                        )
                      : Image.file(File(_courseImage!.path), fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
                onPressed: () => writeData(), child: Text("Add New Course")),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
