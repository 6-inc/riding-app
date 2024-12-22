import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:intl/intl.dart';

class HorseAddPage extends StatefulWidget {
  final Function(String)? onHorseAdded;

  HorseAddPage({this.onHorseAdded});

  @override
  _HorseAddPageState createState() => _HorseAddPageState();
}

class _HorseAddPageState extends State<HorseAddPage> {
  final _formKey = GlobalKey<FormState>();
  String _horseName = '';
  String? _breed;
  String? _color;
  DateTime? _birthDate;
  String? _note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('馬を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '馬の名前'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _horseName = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '品種'),
                onSaved: (value) {
                  _breed = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '毛色'),
                onSaved: (value) {
                  _color = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'メモ'),
                onSaved: (value) {
                  _note = value ?? '';
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _birthDate == null
                        ? '誕生日を選択'
                        : '誕生日: ${DateFormat('yyyy-MM-dd').format(_birthDate!)}',
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _birthDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (_horseName.isNotEmpty) {
                      Provider.of<HorseService>(context, listen: false)
                          .addHorse({
                        'name': _horseName,
                        'breed': _breed ?? '',
                        'color': _color ?? '',
                        'birthDate': _birthDate?.toIso8601String() ?? '',
                        'note': _note ?? '',
                      });
                      if (widget.onHorseAdded != null) {
                        widget.onHorseAdded!(_horseName);
                      }
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('名前の入力は必須です。')),
                      );
                    }
                  }
                },
                child: Text('追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
