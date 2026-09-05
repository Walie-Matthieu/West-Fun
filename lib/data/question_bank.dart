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
      'She\'s a 10 but she hates your parents.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever pretended to know a song I didn\'t know.',
      'Never have I ever sent a text to the wrong person.',
      'Never have I ever laughed at the wrong moment.',
    ],
    GameMode.wouldYouRather: [
      'Would you rather never use social media again OR never watch movies again?',
      'Would you rather always be 10 minutes late OR 20 minutes early?',
      'Would you rather lose your phone OR lose your wallet?',
    ],
    GameMode.truthOrDare: [
      'What is your most embarrassing nickname?',
      'Speak in an accent for the next two minutes.',
      'What is a harmless lie you tell often?',
      'Do your best celebrity impression.',
      'What is the most childish thing you still do?',
      'Let someone send one message from your phone.',
      'What is the worst gift you have ever received?',
      'Do 10 push-ups right now.',
      'What is a secret talent no one knows about?',
      'Speak only in questions for the next round.',
    ],
    GameMode.crazySituations: [
      'You can only use one app for a year: explain why your choice makes sense.',
      'You wake up famous overnight: explain your first 3 moves to stay sane.',
      'You can swap lives with one person for a week: explain why this is your best pick.',
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
      'She\'s a 10 but she says "we\'re almost there" for 40 minutes.',
      'She\'s a 10 but she sleeps diagonally on the bed.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever forgotten an important anniversary date.',
      'Never have I ever checked my partner\'s playlist secretly.',
      'Never have I ever watched our series without my partner.',
    ],
    GameMode.wouldYouRather: [
      'Would you rather have date night at home OR go out every week?',
      'Would you rather travel often OR save for a dream home?',
      'Would you rather always choose the movie OR always choose dinner?',
    ],
    GameMode.truthOrDare: [
      'What little habit of mine do you secretly like?',
      'Give your best romantic movie speech.',
      'What was your first impression of me?',
      'Recreate our first date in 30 seconds.',
      'What song reminds you of us?',
      'Serenade your partner with any song.',
      'What is the sweetest thing I have ever done for you?',
      'Write a 3-line poem about your partner right now.',
      'What would you change about our first date?',
      'Recreate your most romantic memory in mime.',
    ],
    GameMode.crazySituations: [
      'Your partner plans a surprise trip tomorrow: explain how you would organize everything tonight.',
      'You both must live without your phones for one weekend: explain your plan to make it fun.',
      'You can relive one date together: explain why that one deserves a remake.',
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
      'She\'s a 10 but she writes "seen" and nothing else.',
      'She\'s a 10 but she still stalks her ex online.',
    ],
    GameMode.neverHaveIEver: [
      'Never have I ever gone on two dates in one day.',
      'Never have I ever kissed someone in a public place.',
      'Never have I ever sent a risky message and regretted it.',
    ],
    GameMode.wouldYouRather: [
      'Would you rather reveal your crush OR reveal your last awkward message?',
      'Would you rather have no first-date nerves OR no break-up sadness?',
      'Would you rather always text first OR never text first?',
    ],
    GameMode.truthOrDare: [
      'What is your biggest dating red flag?',
      'Send a funny compliment to your last chat contact.',
      'What is your wildest first-date story?',
      'Do your best flirty wink and say a cheesy pickup line.',
      'What is the most embarrassing thing you have searched online?',
      'Call someone and sing happy birthday, even if it is not their birthday.',
      'What is your most awkward flirting attempt?',
      'Text your crush an emoji — nothing else.',
      'What is the boldest thing you have done to impress someone?',
      'Read out the last thing you searched on your phone.',
    ],
    GameMode.crazySituations: [
      'You must send one honest voice note to your crush right now: explain what you would say and why.',
      'You are stuck at a party with your ex and your current crush: explain your survival strategy.',
      'You can erase one awkward moment from your dating history: explain your pick.',
    ],
  },
};

const Map<PartyTheme, Map<String, List<String>>> truthOrDareBank = {
  PartyTheme.friendsNight: {
    'truth': [
      'What is your most embarrassing nickname?',
      'What is a harmless lie you tell often?',
      'What is the most childish thing you still do?',
      'What is the worst gift you have ever received?',
      'What is a secret talent no one knows about?',
    ],
    'dare': [
      'Speak in an accent for the next two minutes.',
      'Do your best celebrity impression.',
      'Let someone send one message from your phone.',
      'Do 10 push-ups right now.',
      'Speak only in questions for the next round.',
    ],
  },
  PartyTheme.couple: {
    'truth': [
      'What little habit of mine do you secretly like?',
      'What was your first impression of me?',
      'What song reminds you of us?',
      'What is the sweetest thing I have ever done for you?',
      'What would you change about our first date?',
    ],
    'dare': [
      'Give your best romantic movie speech.',
      'Recreate our first date in 30 seconds.',
      'Serenade your partner with any song.',
      'Write a 3-line poem about your partner right now.',
      'Recreate your most romantic memory in mime.',
    ],
  },
  PartyTheme.eighteenPlus: {
    'truth': [
      'What is your biggest dating red flag?',
      'What is your wildest first-date story?',
      'What is the most embarrassing thing you have searched online?',
      'What is your most awkward flirting attempt?',
      'What is the boldest thing you have done to impress someone?',
    ],
    'dare': [
      'Send a funny compliment to your last chat contact.',
      'Do your best flirty wink and say a cheesy pickup line.',
      'Call someone and sing happy birthday, even if it is not their birthday.',
      'Text your crush an emoji — nothing else.',
      'Read out the last thing you searched on your phone.',
    ],
  },
};

