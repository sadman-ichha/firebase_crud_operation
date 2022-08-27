import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_operation/views/add_new_course.dart';
import 'package:firebase_crud_operation/views/update_course.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addNewCourse() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => AddNewCourse());
  }

  Future<void> deleteCourse(selectedDocument) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(selectedDocument)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Course has been Deleted'))
        .catchError((error) => Fluttertoast.showToast(msg: error));
  }

  updateACourse(selectedDocumentId, title, details, img) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            UpdateACourse(selectedDocumentId, title, details, img));
  }

  final Stream<QuerySnapshot> _coruseStream =
      FirebaseFirestore.instance.collection("courses").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        actions: [
          IconButton(
            onPressed: () => addNewCourse(),
            icon: Icon(Icons.add_circle_outline_sharp),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _coruseStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      height: 235.0,
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          Expanded(child: Image.network(data['image'])),
                          SizedBox(height: 8.0),
                          Text(
                            data['course_name'],
                            style: TextStyle(fontSize: 25.0),
                          ),
                          Text(data['course_details']),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: Card(
                        elevation: 3.0,
                        child: Container(
                          height: 60.0,
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () => updateACourse(
                                      document.id,
                                      data['course_name'],
                                      data['course_details'],
                                      data['image']),
                                  icon: Icon(Icons.edit_outlined)),
                              IconButton(
                                onPressed: () => deleteCourse(document.id),
                                icon: Icon(Icons.delete_outline_outlined),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      )),
                ]);
              }).toList(),
            );
          }),
    );
  }
}
