import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:todo_list_app/models/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasks.add({
      'taskTitle': task.title.toString(),
      'taskDesc': task.description.toString(),
      'taskCategory': task.category.toString(),
    });
  }

  Stream<QuerySnapshot> getTasks() {
    return tasks.snapshots();
  }

  Future<void> deleteTask(String taskId) {
    return tasks.doc(taskId).delete();
  }
  Future<void> updateTask(Task updatedTask) {
    return tasks.doc(updatedTask.id).update({
      'taskTitle': updatedTask.title,
      'taskDesc': updatedTask.description,
      'taskCategory': updatedTask.category.toString(),
    });
  }
}
  