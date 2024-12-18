import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_style_selection_page.dart';
import 'package:riding_app/views/journal/journal_timer_page.dart';
import 'package:riding_app/views/journal/journal_location_page.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';
import 'package:riding_app/views/journal/journal_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';

class JournalAddPage extends StatefulWidget {
  final String selectedStyle;

  JournalAddPage({required this.selectedStyle});

  @override
  _JournalAddPageState createState() => _JournalAddPageState();
}

class _JournalAddPageState extends State<JournalAddPage> {
  String? _selectedStyle;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _location;
  String? _selectedHorse;

  void _navigateToStyleSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalStyleSelectionPage(
          onStyleSelected: (style) {
            setState(() {
              _selectedStyle = style;
            });
            _navigateToTimer();
          },
        ),
      ),
    );
  }

  void _navigateToTimer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalTimerPage(
          onTimeSelected: (start, end) {
            setState(() {
              _startTime = start;
              _endTime = end;
            });
            _navigateToHorseSelection();
          },
        ),
      ),
    );
  }

  void _navigateToHorseSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalHorseSelectionPage(
          onHorseSelected: (horse) {
            setState(() {
              _selectedHorse = horse;
            });
            _navigateToLocation();
          },
        ),
      ),
    );
  }

  void _navigateToLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalLocationPage(
          onLocationSelected: (location) {
            setState(() {
              _location = location;
            });
            _navigateToEntryDetails();
          },
        ),
      ),
    );
  }

  void _navigateToEntryDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryPage(
          location: _location ?? 'Default Location',
          horse: _selectedHorse ?? 'Default Horse',
          style: _selectedStyle ?? 'Default Style',
          startTime: _startTime ?? DateTime.now(),
          endTime: _endTime ?? DateTime.now(),
          onSave: _saveEntry,
        ),
      ),
    );
  }

  void _saveEntry(String title, String content) {
    print('Saving entry: $title, $content');
    Provider.of<JournalService>(context, listen: false).addEntry(
      title,
      content,
      _selectedStyle ?? 'Default Style',
      _selectedHorse ?? 'Default Horse',
      _location ?? 'Default Location',
      _startTime ?? DateTime.now(),
      _endTime ?? DateTime.now(),
    );
    print('Entry saved, navigating to journal list');
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('Attempting to save entry');
            _saveEntry('タイトル', '内容');
          },
          child: Text('保存'),
        ),
      ),
    );
  }
}
