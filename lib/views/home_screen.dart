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
        context: context, builder: (context) => AddNewCourse());
  }

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
    );
  }
}
