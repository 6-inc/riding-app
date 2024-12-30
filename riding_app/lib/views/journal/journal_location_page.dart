import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JournalLocationPage extends StatefulWidget {
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String) onLocationSelected;

  const JournalLocationPage({
    Key? key,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<JournalLocationPage> createState() => _JournalLocationPageState();
}

class _JournalLocationPageState extends State<JournalLocationPage> {
  late final TextEditingController _searchController;
  PickResult? selectedPlace;
  static const LatLng _initialPosition = LatLng(35.6895, 139.6917); // 東京
  List<Map<String, String>> _searchResults = [];

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
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              onSubmitted: (value) {
                _performSearch(value);
              },
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

  void _performSearch(String query) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey&location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=5000');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = (data['results'] as List).map((place) {
          return {
            'name': place['name'] as String,
            'address': place['formatted_address'] as String,
          };
        }).toList();
      });
    } else {
      print('Failed to load places');
    }
  }
}
