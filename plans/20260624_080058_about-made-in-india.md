# Plan: Add "Made with ❤️ from India" to About screen footer

## Issue / Request
Add a footer line — **Made with ❤️ from India** (with a red heart) — at the bottom of
the About screen, matching the attached screenshot.

## Files to change
- `mantra_japa_counter/lib/screens/about_screen.dart`

## Plan for the change
- In the `ListView` children, after the existing "Om Namah Shivaya" `Center` block
  (currently the last child), add:
  - A `SizedBox(height: 24)` spacer.
  - A `Center` containing a `Row` (mainAxisSize.min) with:
    - `Text('Made with ')` in grey
    - `Icon(Icons.favorite, color: Colors.red, size: 16)`
    - `Text(' from India')` in grey
  - Use a small font size (~14) consistent with the existing footer styling.

No other files, logic, or behavior change. Purely presentational, offline-safe.
