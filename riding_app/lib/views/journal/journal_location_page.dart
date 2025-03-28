import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';

class JournalLocationPage extends StatefulWidget {
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String) onLocationSelected;

  const JournalLocationPage({
    super.key,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onLocationSelected,
  });

  @override
  State<JournalLocationPage> createState() => _JournalLocationPageState();
}

class _JournalLocationPageState extends State<JournalLocationPage> {
  late final TextEditingController _searchController;
  final List<Map<String, String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('場所を選択')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '場所を検索',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  title: Text(place['name'] ?? 'Unknown'),
                  subtitle: Text(place['address'] ?? 'No address'),
                  onTap: () {
                    _navigateToHorseSelection(place['name'] ?? '');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHorseSelection(String location) {
    widget.onLocationSelected(location);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalHorseSelectionPage(
          location: location,
          style: widget.style,
          onHorseSelected: (horse) {
            // 馬の選択後の処理
          },
        ),
      ),
    );
  }
}
