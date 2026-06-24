# Change Log: Add "Made with ❤️ from India" to About screen footer

Implements plan: `plans/20260624_080058_about-made-in-india.md`

## What changed
- `mantra_japa_counter/lib/screens/about_screen.dart`
  - Added a footer below the "Om Namah Shivaya" line: a 24px spacer followed by a
    centered `Row` containing "Made with ", a red `Icons.favorite` heart (size 16),
    and " from India" — both text segments in grey at fontSize 14.

No logic or behavior change; presentational only.
