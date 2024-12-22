import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:intl/intl.dart';

class HorseAddPage extends StatefulWidget {
  @override
  _HorseAddPageState createState() => _HorseAddPageState();
}

class _HorseAddPageState extends State<HorseAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('馬を追加')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: '毛色'),
            ),
            TextField(
              controller: _breedController,
              decoration: InputDecoration(labelText: '品種'),
            ),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: '誕生日',
                hintText: _selectedBirthDate == null
                    ? '日付を選択'
                    : DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedBirthDate = pickedDate;
                  });
                }
              },
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'メモ'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  // 名前が空の場合、エラーメッセージを表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('名前の入力は必須です。')),
                  );
                  return;
                }
                Provider.of<HorseService>(context, listen: false).addHorse({
                  'name': _nameController.text,
                  'color': _colorController.text,
                  'breed': _breedController.text,
                  'birthDate': _selectedBirthDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)
                      : null,
                  'note': _noteController.text,
                });
                Navigator.pop(context);
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
