import 'package:flutter/material.dart';

enum AppLanguage { fr, en }

class AppText {
  AppText(this.language);

  final AppLanguage language;

  static AppText of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppText(locale.languageCode.toLowerCase().startsWith('en')
        ? AppLanguage.en
        : AppLanguage.fr);
  }

  static const Map<String, Map<AppLanguage, String>> _values = {
    'play': {AppLanguage.fr: 'Jouer', AppLanguage.en: 'Play'},
    'players': {AppLanguage.fr: 'Joueurs', AppLanguage.en: 'Players'},
    'addPlayer': {
      AppLanguage.fr: 'Ajouter un joueur',
      AppLanguage.en: 'Add player'
    },
    'start': {AppLanguage.fr: 'Commencer', AppLanguage.en: 'Start'},
    'themes': {AppLanguage.fr: 'Thèmes', AppLanguage.en: 'Themes'},
    'modes': {AppLanguage.fr: 'Modes de jeu', AppLanguage.en: 'Game modes'},
    'next': {AppLanguage.fr: 'Suivant', AppLanguage.en: 'Next'},
    'activePlayer': {
      AppLanguage.fr: 'Joueur actif',
      AppLanguage.en: 'Active player'
    },
    'questionsLeft': {
      AppLanguage.fr: 'Questions restantes',
      AppLanguage.en: 'Questions left'
    },
    'agreeVotes': {
      AppLanguage.fr: 'Votes d\'accord',
      AppLanguage.en: 'Agree votes'
    },
    'others': {
      AppLanguage.fr: 'autres joueurs',
      AppLanguage.en: 'other players'
    },
    'scoreboard': {
      AppLanguage.fr: 'Tableau des scores',
      AppLanguage.en: 'Scoreboard'
    },
    'winner': {AppLanguage.fr: 'Gagnant', AppLanguage.en: 'Winner'},
    'finalScores': {
      AppLanguage.fr: 'Scores finaux',
      AppLanguage.en: 'Final scores'
    },
    'replay': {AppLanguage.fr: 'Rejouer', AppLanguage.en: 'Play again'},
    'player': {AppLanguage.fr: 'Joueur', AppLanguage.en: 'Player'},
    'scoresRevealedAtEnd': {
      AppLanguage.fr: 'Les scores seront reveles a la fin de la partie.',
      AppLanguage.en: 'Scores will be revealed at the end of the game.',
    },
    'minTwoPlayers': {
      AppLanguage.fr: 'Ajoutez au moins 2 joueurs.',
      AppLanguage.en: 'Add at least 2 players.',
    },
    'theme': {AppLanguage.fr: 'Thème', AppLanguage.en: 'Theme'},
  };

  String get play => _value('play');
  String get players => _value('players');
  String get addPlayer => _value('addPlayer');
  String get start => _value('start');
  String get themes => _value('themes');
  String get modes => _value('modes');
  String get next => _value('next');
  String get activePlayer => _value('activePlayer');
  String get questionsLeft => _value('questionsLeft');
  String get agreeVotes => _value('agreeVotes');
  String get others => _value('others');
  String get scoreboard => _value('scoreboard');
  String get winner => _value('winner');
  String get finalScores => _value('finalScores');
  String get replay => _value('replay');
  String get player => _value('player');
  String get scoresRevealedAtEnd => _value('scoresRevealedAtEnd');
  String get minTwoPlayers => _value('minTwoPlayers');
  String get theme => _value('theme');

  String _value(String key) => _values[key]?[language] ?? '';
}
