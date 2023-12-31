import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
const uuid = Uuid();

enum Category { personal, work, shopping, others }

class Task {
  Task({
    required this.title,
    required this.description,
    required this.date,
    String? id, 
    required this.category,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final Category category;

  factory Task.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Task(
      id: snapshot.id,
      title: data['taskTitle'] ?? '',
      description: data['taskDesc'] ?? '',
      date: DateTime.tryParse(data['taskDate'] ?? '') ?? DateTime.now(),
      category: _getCategoryFromString(data['taskCategory'] ?? ''),
    );
  }

  static Category _getCategoryFromString(String categoryString) {
    switch (categoryString) {
      case 'personal':
        return Category.personal;
      case 'work':
        return Category.work;
      case 'shopping':
        return Category.shopping;
      default:
        return Category.others;
    }
  }
}
