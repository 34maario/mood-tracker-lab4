import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'mood_score_selector.dart';

/// A form for recording a new mood entry.
class MoodEntryForm extends StatefulWidget {
  const MoodEntryForm({super.key, required this.onSubmit});

  /// Called with the new entry when the user saves it.
  final ValueChanged<MoodEntry> onSubmit;

  @override
  State<MoodEntryForm> createState() => _MoodEntryFormState();
}

class _MoodEntryFormState extends State<MoodEntryForm> {
  int? _score;

  /// Error messages shown under each field. `null` means no error.
  String? _scoreError;
  String? _noteError;

  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    // Check every field first, so the user sees all problems at once.
    setState(() {
      _scoreError = _score == null ? 'Choose a score from 1 to 10' : null;
      _noteError = _noteController.text.length > maxNoteLength
          ? 'Note must be at most $maxNoteLength characters'
          : null;
    });

    if (_scoreError != null || _noteError != null) return;

    final note = _noteController.text.trim();
    final entry = MoodEntry(
      score: _score!,
      note: note.isEmpty ? null : note,
      createdAt: DateTime.now(),
    );

    widget.onSubmit(entry);

    setState(() {
      _score = null;
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            MoodScoreSelector(
              selectedScore: _score,
              onChanged: (score) {
                setState(() {
                  _score = score;
                  _scoreError = null;
                });
              },
            ),
            if (_scoreError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _scoreError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                errorText: _noteError,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _save, child: const Text('Save entry')),
          ],
        ),
      ),
    );
  }
}
