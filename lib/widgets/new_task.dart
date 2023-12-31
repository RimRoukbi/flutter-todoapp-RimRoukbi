import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class NewTask extends StatefulWidget {
  const NewTask({Key? key, required this.onAddTask}) : super(key: key);

  final void Function(Task task) onAddTask;

  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  Category _selectedCategory = Category.personal;
  DateTime _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitTaskData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter the title of the task to add to the list'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddTask(
      Task(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        category: _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          Row(
            children: [
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                        _dateController.text =
                            "${_selectedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  });
                },
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : "${_selectedDate.toLocal()}".split(' ')[0],
                ),
              ),
              ElevatedButton(
                onPressed: _submitTaskData,
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}