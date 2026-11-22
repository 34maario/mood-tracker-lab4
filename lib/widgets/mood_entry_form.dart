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

  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (_score == null) return;

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
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _score == null ? null : _save,
              child: const Text('Save entry'),
            ),
          ],
        ),
      ),
    );
  }
}
