# West-Fun

West-Fun is a Flutter party game app with local multiplayer gameplay.

## Features

- Home screen with app title and **Play** button
- Local player setup (no account/login)
- Theme selection: **Friends night**, **Couple**, **18+**
- 5 game modes:
  - Who would...
  - She's a 10 but...
  - Never have I ever...
  - Truth or Dare
  - Would you rather...
- English question banks for every mode and theme
- Turn-by-turn voting and scoring
- Always-visible scoreboard during gameplay
- End-game ranking with winner and final scores

## Scoring

For each turn, one player is active and the others vote:

- 100% agree -> maximum points gained
- 50/50 -> no score change
- 0% agree -> points lost

Score change is computed linearly between -10 and +10 based on agreement percentage.

## Structure

The app uses a clean local-only structure:

- `lib/models`: game domain models and engine
- `lib/data`: local question banks
- `lib/screens`: UI screens
- `lib/widgets`: reusable UI widgets
- `lib/l10n`: localization-friendly text mapping
