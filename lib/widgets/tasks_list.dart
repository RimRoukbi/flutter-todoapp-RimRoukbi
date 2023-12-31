import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/firestore.dart';
import 'package:todo_list_app/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  TasksList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final taskLists = snapshot.data!.docs;
          List<Task> taskItems =
              taskLists.map((doc) => Task.fromDocumentSnapshot(doc)).toList();


              

          return ListView.builder(
            itemCount: taskItems.length,
            itemBuilder: (ctx, index) {
              return TaskItem(taskItems[index], firestoreService);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          // Handle the case where snapshot doesn't have data
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}