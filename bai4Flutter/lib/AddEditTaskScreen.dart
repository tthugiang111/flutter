import 'package:flutter/material.dart';
import 'task.dart';
import 'db_helper.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  _saveTask() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      // Hiển thị thông báo nếu thông tin trống
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Task newTask = Task(title: title, description: description);

    if (widget.task == null) {
      // Thêm mới công việc
      await DBHelper().insertTask(newTask);
    } else {
      // Cập nhật công việc hiện tại
      newTask.id = widget.task!.id;
      await DBHelper().updateTask(newTask);
    }

    Navigator.pop(context, true); // Trả về kết quả và quay lại màn hình chính
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Thêm Công Việc' : 'Chỉnh Sửa Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Tiêu Đề'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Mô Tả'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(widget.task == null ? 'Thêm Công Việc' : 'Cập Nhật Công Việc'),
            ),
          ],
        ),
      ),
    );
  }
}
