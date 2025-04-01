import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/models/horse.dart';
import 'package:riding_app/services/horse_service.dart';

class HorseEditPage extends StatefulWidget {
  final Horse horse;
  const HorseEditPage({Key? key, required this.horse}) : super(key: key);

  @override
  _HorseEditPageState createState() => _HorseEditPageState();
}

class _HorseEditPageState extends State<HorseEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _descriptionController;
  DateTime? _birthDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.horse.name);
    _breedController = TextEditingController(text: widget.horse.breed ?? '');
    _colorController = TextEditingController(text: widget.horse.color ?? '');
    _descriptionController =
        TextEditingController(text: widget.horse.description ?? '');
    _birthDate = widget.horse.birthDate;
    _imagePath = widget.horse.imageUrl;
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Widget _buildInputCard({required String label, required Widget child}) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: (_imagePath != null && _imagePath!.isNotEmpty)
                    ? FileImage(File(_imagePath!))
                    : null,
                child: (_imagePath == null || _imagePath!.isEmpty)
                    ? Text(
                        '画像なし',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              child: const Text('画像変更'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('馬編集'),
        titleTextStyle: const TextStyle(fontSize: 16),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImagePicker(),
              _buildInputCard(
                label: '名前',
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '馬の名前を入力',
                    border: InputBorder.none,
                  ),
                ),
              ),
              _buildInputCard(
                label: '品種',
                child: TextField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    hintText: '馬の品種を入力',
                    border: InputBorder.none,
                  ),
                ),
              ),
              _buildInputCard(
                label: '毛色',
                child: TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    hintText: '馬の毛色を入力',
                    border: InputBorder.none,
                  ),
                ),
              ),
              _buildInputCard(
                label: '誕生日',
                child: InkWell(
                  onTap: () => _selectBirthDate(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _birthDate != null
                            ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                            : '日付を選択してください',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
              _buildInputCard(
                label: 'メモ',
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: '馬に関するメモを入力',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedHorse = Horse(
                        id: widget.horse.id,
                        name: _nameController.text,
                        breed: _breedController.text,
                        color: _colorController.text,
                        birthDate: _birthDate,
                        description: _descriptionController.text,
                        imageUrl: _imagePath,
                      );
                      await Provider.of<HorseService>(context, listen: false)
                          .updateHorse(updatedHorse);
                      Navigator.pop(context, updatedHorse);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('保存'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
