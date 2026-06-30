import 'package:west_fun/models/game_models.dart';

const Map<PartyTheme, Map<GameMode, List<String>>> questionBank = {
  PartyTheme.friendsNight: {
    GameMode.whoWould: [
      'Who would survive the longest on a desert island?',
      'Who would accidentally start a fire while cooking?',
      'Who would become famous first?',
    ],
    GameMode.shesA10But: [
      'She\'s a 10 but she claps when the plane lands.',
      'She\'s a 10 but she replies after 3 business days.',
      'She\'s a 10 but she sings loudly in every store.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever pretended to know a song I didn\'t know.',
      'Never have I ever sent a text to the wrong person.',
      'Never have I ever laughed at the wrong moment.',
    ],
    GameMode.truthOrDare: [
      'Truth: What is your most embarrassing nickname?',
      'Dare: Speak in an accent for the next round.',
      'Truth: What is a harmless lie you tell often?',
    ],
    GameMode.wouldYouRather: [
      'Would you rather never use social media again OR never watch movies again?',
      'Would you rather always be 10 minutes late OR 20 minutes early?',
      'Would you rather lose your phone OR lose your wallet?',
    ],
  },
  PartyTheme.couple: {
    GameMode.whoWould: [
      'Who would apologize first after an argument?',
      'Who would plan the perfect weekend getaway?',
      'Who would cry first during a sad movie?',
    ],
    GameMode.shesA10But: [
      'She\'s a 10 but she steals your fries every time.',
      'She\'s a 10 but she says “we\'re almost there” for 40 minutes.',
      'She\'s a 10 but she sleeps diagonally on the bed.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever forgotten an important anniversary date.',
      'Never have I ever checked my partner\'s playlist secretly.',
      'Never have I ever watched our series without my partner.',
    ],
    GameMode.truthOrDare: [
      'Truth: What little habit of mine do you secretly like?',
      'Dare: Give your best romantic movie speech.',
      'Truth: What was your first impression of me?',
    ],
    GameMode.wouldYouRather: [
      'Would you rather have date night at home OR go out every week?',
      'Would you rather travel often OR save for a dream home?',
      'Would you rather always choose the movie OR always choose dinner?',
    ],
  },
  PartyTheme.eighteenPlus: {
    GameMode.whoWould: [
      'Who would flirt with a stranger first?',
      'Who would send the boldest late-night text?',
      'Who would keep a secret crush the longest?',
    ],
    GameMode.shesA10But: [
      'She\'s a 10 but she asks for your zodiac chart on the first date.',
      'She\'s a 10 but she writes “seen” and nothing else.',
      'She\'s a 10 but she still stalks her ex online.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever gone on two dates in one day.',
      'Never have I ever kissed someone in a public place.',
      'Never have I ever sent a risky message and regretted it.',
    ],
    GameMode.truthOrDare: [
      'Truth: What is your biggest dating red flag?',
      'Dare: Send a funny compliment to your last chat contact.',
      'Truth: What is your wildest first-date story?',
    ],
    GameMode.wouldYouRather: [
      'Would you rather reveal your crush OR reveal your last awkward message?',
      'Would you rather have no first-date nerves OR no break-up sadness?',
      'Would you rather always text first OR never text first?',
    ],
  },
};
