import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/data/sample_entries.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood_entry.dart';
import 'package:mood_tracker/widgets/mood_card.dart';
import 'package:mood_tracker/widgets/mood_score_selector.dart';

// Self-check for Lab 4, Exercises 1 and 2. Run it with: flutter test
//
// Both tests fail on the starter code and pass once Exercise 2 is done.
// Exercise 3 changes what the Save button should do. Part of that task is
// to update these tests so they check the new requirement.

/// Renders the app in a window tall enough for every card to be built.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MoodTrackerApp());
}

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');
Finder get noteField => find.byType(TextField);

const scoreError = 'Choose a score from 1 to 10';
const noteError = 'Note must be at most $maxNoteLength characters';

Future<void> chooseScore(WidgetTester tester, int score) async {
  await tester.tap(find.widgetWithText(ChoiceChip, '$score'));
  await tester.pump();
}

Future<void> tapSave(WidgetTester tester) async {
  await tester.tap(saveButton);
  await tester.pump();
}

String noteText(WidgetTester tester) =>
    tester.widget<TextField>(noteField).controller!.text;

void main() {
  // Criterion 1. This test used to check that Save was disabled without a
  // score; the new requirement keeps Save enabled and shows a message instead.
  testWidgets('Save without a score shows an error and adds nothing', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

    await tapSave(tester);

    expect(find.text(scoreError), findsOneWidget);
    expect(
      tester.getTopLeft(find.text(scoreError)).dy,
      greaterThan(tester.getBottomLeft(find.byType(MoodScoreSelector)).dy),
    );
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  // Criterion 2.
  testWidgets('a note one character too long shows an error and is kept', (
    tester,
  ) async {
    await pumpApp(tester);
    final tooLong = 'a' * (maxNoteLength + 1);

    await chooseScore(tester, 5);
    await tester.enterText(noteField, tooLong);
    await tapSave(tester);

    expect(
      find.descendant(of: noteField, matching: find.text(noteError)),
      findsOneWidget,
    );
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
    expect(noteText(tester), tooLong);
  });

  // Criterion 3.
  testWidgets('a note of exactly the maximum length is saved', (tester) async {
    await pumpApp(tester);
    final longest = 'a' * maxNoteLength;

    await chooseScore(tester, 7);
    await tester.enterText(noteField, longest);
    await tapSave(tester);

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text(longest),
      ),
      findsOneWidget,
    );
    expect(find.text(scoreError), findsNothing);
    expect(find.text(noteError), findsNothing);
  });

  // Criterion 4.
  testWidgets('no score and a too-long note show both errors', (tester) async {
    await pumpApp(tester);

    await tester.enterText(noteField, 'a' * (maxNoteLength + 1));
    await tapSave(tester);

    expect(find.text(scoreError), findsOneWidget);
    expect(find.text(noteError), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  // Criterion 5.
  testWidgets('choosing a score hides the score error', (tester) async {
    await pumpApp(tester);

    await tapSave(tester);
    expect(find.text(scoreError), findsOneWidget);

    await chooseScore(tester, 4);

    expect(find.text(scoreError), findsNothing);
  });

  // Criterion 6.
  testWidgets('an entry with a score and no note is saved', (tester) async {
    await pumpApp(tester);

    await chooseScore(tester, 8);
    await tapSave(tester);

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('No note'),
      ),
      findsOneWidget,
    );
    expect(find.text(scoreError), findsNothing);
    expect(find.text(noteError), findsNothing);
  });

  // Criterion 7.
  testWidgets('the form is reset after a successful save', (tester) async {
    await pumpApp(tester);

    // Make an error appear first, so we also check it is gone afterwards.
    await tapSave(tester);
    await chooseScore(tester, 6);
    await tester.enterText(noteField, 'Coffee with a friend');
    await tapSave(tester);

    final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip));
    expect(chips.where((chip) => chip.selected), isEmpty);
    expect(noteText(tester), isEmpty);
    expect(find.text(scoreError), findsNothing);
    expect(find.text(noteError), findsNothing);
  });

  testWidgets('saving an entry puts it at the top of the history', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '3'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Rainy walk home');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('Rainy walk home'),
      ),
      findsOneWidget,
    );
  });
}
