import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/firestore.dart';
import 'package:todo_list_app/widgets/edit_task.dart';
class TaskItem extends StatelessWidget {
  const TaskItem(this.task, this.firestoreService, {Key? key})
      : super(key: key);

  final FirestoreService firestoreService;
  final Task task;

  void _openEditTaskOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditTask(task: task, onUpdateTask: _updateTask),
    );
  }

  void _updateTask(Task task) {
    firestoreService.updateTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.pink,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            task.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _openEditTaskOverlay(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                firestoreService.deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}