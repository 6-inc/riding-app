import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

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
              onSubmitted: (value) {
                // 検索処理を実装
              },
            ),
          ),
          Expanded(
            child: PlacePicker(
              apiKey: "YOUR-API-KEY",
              onPlacePicked: (PickResult result) {
                setState(() {
                  selectedPlace = result;
                  _searchController.text = result.formattedAddress ?? '';
                });
              },
              initialPosition: _initialPosition,
              useCurrentLocation: true,
              resizeToAvoidBottomInset: false,
              selectedPlaceWidgetBuilder:
                  (_, selectedPlace, state, isSearchBarFocused) {
                return isSearchBarFocused
                    ? Container()
                    : FloatingCard(
                        bottomPosition: 0,
                        leftPosition: 0,
                        rightPosition: 0,
                        child: state == SearchingState.Searching
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      selectedPlace?.formattedAddress ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedPlace != null) {
                                          _navigateToHorseSelection(
                                              selectedPlace.formattedAddress ??
                                                  '');
                                        }
                                      },
                                      child: const Text('この場所を選択'),
                                    ),
                                  ],
                                ),
                              ),
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
