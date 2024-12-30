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
  String _horseName = '';
  String? _breed;
  String? _color;
  DateTime? _birthDate;
  String? _note;
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  /// ギャラリーから画像を選択し、アプリ専用フォルダに保存
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // アプリ専用フォルダを取得
      final directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // ギャラリーから取得した画像をアプリ専用フォルダにコピー
      final File localImage =
          await File(pickedFile.path).copy('$path/$fileName');

      setState(() {
        _imageFile = localImage;
        _imageUrl = localImage.path; // ローカルファイルのパスを保持
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// 入力内容をHorseServiceに渡して馬を追加する
  void _saveHorse() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // onSavedで各変数が更新される

      if (_horseName.isNotEmpty) {
        // HorseServiceへ登録 (Map形式で受ける実装例)
        Provider.of<HorseService>(context, listen: false).addHorse({
          'name': _horseName,
          'breed': _breed ?? '',
          'color': _color ?? '',
          'birthDate': _birthDate?.toIso8601String() ?? '',
          'note': _note ?? '',
          'imageUrl': _imageUrl ?? '',
        });

        // コールバックがあれば呼ぶ
        if (widget.onHorseAdded != null) {
          widget.onHorseAdded!(_horseName);
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
                        decoration: const InputDecoration(labelText: '馬の名前'),
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

                      // 品種
                      TextFormField(
                        decoration: const InputDecoration(labelText: '品種'),
                        onSaved: (value) {
                          _breed = value ?? '';
                        },
                      ),

                      // 毛色
                      TextFormField(
                        decoration: const InputDecoration(labelText: '毛色'),
                        onSaved: (value) {
                          _color = value ?? '';
                        },
                      ),

                      // メモ
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'メモ'),
                        onSaved: (value) {
                          _note = value ?? '';
                        },
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
