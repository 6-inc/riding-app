import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HorseAddPage extends StatefulWidget {
  final Function(String)? onHorseAdded;

  HorseAddPage({this.onHorseAdded});

  @override
  _HorseAddPageState createState() => _HorseAddPageState();
}

class _HorseAddPageState extends State<HorseAddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _horseNameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _birthDate;
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void dispose() {
    _horseNameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrl = _imageFile!.path;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 入力内容をHorseServiceに渡して馬を追加する
  void _saveHorse() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // onSavedで各変数が更新される

      if (_horseNameController.text.isNotEmpty) {
        // HorseServiceへ登録 (Map形式で受ける実装例)
        Provider.of<HorseService>(context, listen: false).addHorse({
          'name': _horseNameController.text,
          'breed': _breedController.text ?? '',
          'color': _colorController.text ?? '',
          'birthDate': _birthDate?.toIso8601String() ?? '',
          'note': _noteController.text ?? '',
          'imageUrl': _imageUrl ?? '',
        });

        // コールバックがあれば呼ぶ
        if (widget.onHorseAdded != null) {
          widget.onHorseAdded!(_horseNameController.text);
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('名前の入力は必須です。')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('馬を追加'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // 画像選択ボタン (丸い枠で表示)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: _imageFile != null
                              ? ClipOval(
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.add_a_photo, size: 40),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 馬の名前
                      TextFormField(
                        controller: _horseNameController,
                        decoration: const InputDecoration(labelText: '馬の名前'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '名前を入力してください';
                          }
                          return null;
                        },
                      ),

                      // 品種
                      TextFormField(
                        controller: _breedController,
                        decoration: const InputDecoration(labelText: '品種'),
                      ),

                      // 毛色
                      TextFormField(
                        controller: _colorController,
                        decoration: const InputDecoration(labelText: '毛色'),
                      ),

                      // メモ
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(labelText: 'メモ'),
                      ),
                      const SizedBox(height: 20),

                      // 誕生日の選択
                      Row(
                        children: [
                          Text(
                            _birthDate == null
                                ? '誕生日を選択'
                                : '誕生日: ${DateFormat('yyyy-MM-dd').format(_birthDate!)}',
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
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
                      const SizedBox(height: 20),

                      // 追加ボタン
                      ElevatedButton(
                        onPressed: _saveHorse,
                        child: const Text('追加'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
