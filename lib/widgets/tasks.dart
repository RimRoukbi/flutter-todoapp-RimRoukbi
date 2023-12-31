import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/widgets/new_task.dart';
import 'package:todo_list_app/widgets/tasks_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/services/firestore.dart';
class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService= FirestoreService();
  final List<Task> _registeredTasks = [
    Task(
      title: 'Apprendre Flutter',
      description: 'Suivre le cours pour apprendre de nouvelles compétences',
      date: DateTime.now(),
      category: Category.work,
    ),
    Task(
      title: 'Faire les courses',
      description: 'Acheter des provisions pour la semaine',
      date: DateTime.now().subtract(Duration(days: 1)),
      category: Category.shopping,
    ),
    Task(
      title: 'Rediger un CR',
      description: '',
      date: DateTime.now().subtract(Duration(days: 2)),
      category: Category.personal,
    ),
    
  ];

  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  void _addTask(Task task) { 
    setState(() { 
      _registeredTasks.add(task); 
      firestoreService.addTask(task); 
      Navigator.pop(context); 
      }
      );

}
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ToDoList'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TasksList(), 
          ),
        ],
      ),
    );
  }
}