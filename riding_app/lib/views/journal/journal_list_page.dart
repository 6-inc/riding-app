import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/views/journal/journal_detail_page.dart';
import 'package:riding_app/views/journal/journal_style_selection_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JournalListPage extends StatelessWidget {
  const JournalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<JournalService>(
        builder: (context, journalService, child) {
          final entries = journalService.getEntries();
          if (entries.isEmpty) {
            return Center(
              child: Text(
                '記録がありません',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          // Formatter for date and time
          final dateFormatter = DateFormat('yyyy/MM/dd');
          final timeFormatter = DateFormat('HH:mm');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];

              // Display the first 30 characters of the content
              String snippet = entry.content;
              if (snippet.length > 30) {
                snippet = snippet.substring(0, 30) + '...';
              }

              // Format date and time strings
              final dateString = dateFormatter.format(entry.date);
              final startTimeString = timeFormatter.format(entry.startTime);
              final endTimeString = timeFormatter.format(entry.endTime);

              return Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalDetailPage(entry: entry),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with date (top-right) and time (below date)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  dateString,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '$startTimeString - $endTimeString',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Horse icon and horse name
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.horseHead,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.horse,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Content snippet
                        Text(
                          snippet,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the style selection page for adding a new entry.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalStyleSelectionPage(
                onStyleSelected: (style) {
                  // Handle style selection for new entry.
                },
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
