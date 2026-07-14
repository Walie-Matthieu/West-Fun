enum GameMode {
  whoWould('Who would...'),
  shesA10But('She\'s a 10 but...'),
  neverHaveIEver('Never have I ever...'),
  truthOrDare('Truth or Dare'),
  wouldYouRather('Would you rather...');

  const GameMode(this.label);
  final String label;
}

enum PartyTheme {
  friendsNight('Friends night'),
  couple('Couple'),
  eighteenPlus('18+'),
  mix('Mix');

  const PartyTheme(this.label);
  final String label;
}

class Player {
  Player(this.name, {this.score = 0});

  final String name;
  int score;
}
