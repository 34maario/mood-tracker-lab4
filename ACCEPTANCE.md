

The Save entry button is always enabled. Validation happens when the user taps it,
and every error is shown as visible text on the screen, next to the field it refers to.
Note length counts every character.

1. Given no score is selected, when I tap Save entry, then the message
   "Choose a score from 1 to 10" appears below the score selector and nothing
   is added to the history.

2. Given a score is selected and the note has 2001 characters, when I tap Save entry,
   then the message "Note must be at most 2000 characters" appears below the note
   field, nothing is added to the history, and the note text is still in the field.

3. Given a score is selected and the note has exactly 2000 characters, when I tap
   Save entry, then a new entry with that score and note appears in the history
   and no error message is shown.

4. Given no score is selected and the note has 2001 characters, when I tap Save entry,
   then both messages "Choose a score from 1 to 10" and "Note must be at most
   2000 characters" are visible and nothing is added to the history.

5. Given the message "Choose a score from 1 to 10" is visible, when I select a score,
   then that message disappears.

6. Given a score is selected and the note is empty, when I tap Save entry, then a new
   entry with that score appears in the history and no error message is shown.

7. Given an entry was saved successfully, when I look at the form, then no score is
   selected, the note field is empty, and no error message is shown.