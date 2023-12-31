import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class EditTask extends StatefulWidget {
  final Task task;
  final void Function(Task updatedTask) onUpdateTask;

  EditTask({required this.task, required this.onUpdateTask});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.personal;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _selectedDate = widget.task.date;
    _selectedCategory = widget.task.category;
  }

  void _submitTaskData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter the title of the task.'),
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

    widget.onUpdateTask(
      Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context); 
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
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
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