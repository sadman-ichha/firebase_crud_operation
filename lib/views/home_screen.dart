import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_operation/views/add_new_course.dart';
import 'package:flutter/material.dart';

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
                return Container(
                  height: 235.0,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                );
              }).toList(),
            );
          }),
    );
  }
}
