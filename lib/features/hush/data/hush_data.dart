import 'package:flutter/material.dart';
import '../models/hush_story.dart';
import '../../../core/theme/hush_colors.dart';

final List<HushStory> hushStories = [
  HushStory(
    id: 'neighbor',
    title: 'The Neighbor Upstairs',
    background: const LinearGradient(
      colors: [Color(0xFF0C2E3A), Color(0xFF164050)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF0C2E3A), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Caleb Storm',
    tags: ['Forbidden', 'Proximity', 'Tension'],
    meta: '8 Episodes • 3h 28m • Caleb Storm',
    liveCount: '3.1K listening',
    description:
        'The walls are paper-thin. You hear everything—his music, his phone calls, his laughter. When the plumbing breaks and he knocks on your door shirtless at midnight, you realize the real problem isn\'t the noise. It\'s the tension.',
    episodes: [
      const HushEpisode(title: 'Move-In Day', duration: '24:30'),
      const HushEpisode(title: 'The Knock', duration: '26:10'),
      const HushEpisode(title: 'Thin Walls', duration: '28:00', isCurrent: true),
      const HushEpisode(title: 'The Laundry Room', duration: '25:40'),
      const HushEpisode(title: 'Power Outage', duration: '27:20'),
      const HushEpisode(title: 'The Balcony', duration: '23:50'),
      const HushEpisode(title: 'Noise Complaint', duration: '26:00'),
      const HushEpisode(title: 'Open Door', duration: '29:10'),
    ],
  ),
  HushStory(
    id: 'photographer',
    title: 'The Photographer',
    background: const LinearGradient(
      colors: [Color(0xFF1A0A20), Color(0xFF2D1438)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF1A0A20), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Nico Voss',
    tags: ['Art', 'Vulnerable', 'Intimate'],
    meta: '10 Episodes • 4h 12m • Nico Voss',
    liveCount: '4.8K listening',
    description:
        'He asks you to model for his gallery show. "Just be natural," he says, adjusting the lighting. Each session peels away another layer—of clothing, of walls, of pretense. The camera sees everything. So does he.',
    episodes: List.generate(
      10,
      (i) => HushEpisode(
        title: [
          'The Studio', 'First Shoot', 'Natural Light', 'The Darkroom',
          'Polaroids', 'Gallery Night', 'After Hours', 'The Print',
          'Exposed', 'Developed'
        ][i],
        duration: '24:${10 + i * 2}',
      ),
    ),
  ),
  HushStory(
    id: 'professor',
    title: 'Office Hours',
    background: const LinearGradient(
      colors: [Color(0xFF2A1430), Color(0xFF3D1E45)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF2A1430), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Caleb Storm',
    tags: ['Professor', 'Forbidden', 'Intellectual'],
    meta: '9 Episodes • 3h 50m • Caleb Storm',
    liveCount: '3.5K listening',
    description:
        'Professor Calloway\'s lectures on romantic poetry hit different when he\'s quoting Neruda while looking directly at you. You keep finding excuses to visit during office hours. He keeps letting you stay too long.',
    episodes: [
      const HushEpisode(title: 'First Lecture', duration: '24:30', isCurrent: true),
      const HushEpisode(title: 'The Citation', duration: '26:10'),
      const HushEpisode(title: 'Office Hours', duration: '25:20'),
      const HushEpisode(title: 'The Conference', duration: '27:00'),
      const HushEpisode(title: 'Late Paper', duration: '24:50'),
      const HushEpisode(title: 'The Reading', duration: '28:30'),
      const HushEpisode(title: 'Tenure Review', duration: '25:10'),
      const HushEpisode(title: 'Sabbatical', duration: '26:40'),
      const HushEpisode(title: 'Epilogue', duration: '27:30'),
    ],
  ),
  HushStory(
    id: 'dancer',
    title: 'After the Show',
    background: const LinearGradient(
      colors: [Color(0xFF200A14), Color(0xFF381020)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF200A14), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Jade Ellis',
    tags: ['Dancer', 'Passionate', 'Physical'],
    meta: '7 Episodes • 2h 40m • Jade Ellis',
    liveCount: '2.1K listening',
    description:
        'She performs like she\'s the only person in the room. Backstage, she\'s all adrenaline and sweat. When she pulls you past the stage door, the real performance begins.',
    episodes: [
      const HushEpisode(title: 'Front Row', duration: '22:30'),
      const HushEpisode(title: 'Backstage', duration: '24:10'),
      const HushEpisode(title: 'The Rehearsal', duration: '26:40'),
      const HushEpisode(title: 'Opening Night', duration: '23:20'),
      const HushEpisode(title: 'The Lift', duration: '25:50'),
      const HushEpisode(title: 'Encore', duration: '27:10'),
      const HushEpisode(title: 'Final Bow', duration: '24:00'),
    ],
  ),
  HushStory(
    id: 'barista',
    title: 'The Barista',
    background: const LinearGradient(
      colors: [Color(0xFF2A2008), Color(0xFF3D3010)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF2A2008), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Nico Voss',
    tags: ['Coffee Shop', 'Sweet', 'Slow Build'],
    meta: '6 Episodes • 2h 15m • Nico Voss',
    liveCount: '5.4K listening',
    description:
        'Every morning, same order, same smile. He always writes something extra on your cup. Today it\'s a phone number. Tomorrow it\'s a date. Next week, you\'re in his apartment above the shop.',
    episodes: [
      const HushEpisode(title: 'Regular Order', duration: '22:10'),
      const HushEpisode(title: 'The Note', duration: '24:30'),
      const HushEpisode(title: 'After Close', duration: '23:45'),
      const HushEpisode(title: 'His Place', duration: '25:20'),
      const HushEpisode(title: 'Morning Shift', duration: '22:00'),
      const HushEpisode(title: 'Our Table', duration: '24:30'),
    ],
  ),
  HushStory(
    id: 'lifeguard',
    title: 'Lifeguard Summer',
    background: const LinearGradient(
      colors: [Color(0xFF0A2030), Color(0xFF143848)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF0A2030), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Nico Voss',
    tags: ['Beach', 'Playful', 'Summer'],
    meta: '6 Episodes • 2h 30m • Nico Voss',
    liveCount: '1.8K listening',
    description:
        'Golden skin, aviator sunglasses, and a whistle around his neck. He watches the ocean all day. At night, he watches you.',
    episodes: [
      const HushEpisode(title: 'Day One', duration: '24:10'),
      const HushEpisode(title: 'Sunscreen', duration: '26:30'),
      const HushEpisode(title: 'The Bonfire', duration: '25:00'),
      const HushEpisode(title: 'Night Swim', duration: '24:20'),
      const HushEpisode(title: 'The Tower', duration: '26:00'),
      const HushEpisode(title: 'Last Day', duration: '25:30'),
    ],
  ),
  HushStory(
    id: 'chef',
    title: 'Private Chef',
    background: const LinearGradient(
      colors: [Color(0xFF2A1508), Color(0xFF402010)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF2A1508), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Jade Ellis',
    tags: ['Sensual', 'Cooking', 'Domestic'],
    meta: '5 Episodes • 2h • Jade Ellis',
    liveCount: '1.2K listening',
    description:
        'She cooks like she\'s making love to the ingredients. When she feeds you from the spoon and watches your reaction, the kitchen becomes the most dangerous room in the house.',
    episodes: [
      const HushEpisode(title: 'The Tasting', duration: '24:30'),
      const HushEpisode(title: 'Knife Skills', duration: '22:10'),
      const HushEpisode(title: 'Simmer', duration: '26:00'),
      const HushEpisode(title: 'Dessert', duration: '25:15'),
      const HushEpisode(title: 'Breakfast', duration: '24:00'),
    ],
  ),
  HushStory(
    id: 'penpal',
    title: 'Dear Pen Pal',
    background: const LinearGradient(
      colors: [Color(0xFF0A0A28), Color(0xFF141440)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF0A0A28), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Caleb Storm',
    tags: ['Letters', 'Longing', 'Emotional'],
    meta: '8 Episodes • 3h 20m • Caleb Storm',
    liveCount: '2.6K listening',
    description:
        'You\'ve never met. But his letters make you feel things no one in person ever has. Each envelope is more daring than the last. When he finally writes "I\'m coming to your city"—your heart stops.',
    episodes: [
      const HushEpisode(title: 'First Letter', duration: '24:10'),
      const HushEpisode(title: 'Dear Stranger', duration: '26:30'),
      const HushEpisode(title: 'The Photograph', duration: '25:00'),
      const HushEpisode(title: 'Confessions', duration: '27:20'),
      const HushEpisode(title: 'Come Closer', duration: '24:40'),
      const HushEpisode(title: 'The Visit', duration: '28:10'),
      const HushEpisode(title: 'Face to Face', duration: '25:30'),
      const HushEpisode(title: 'Yours', duration: '26:00'),
    ],
  ),
  HushStory(
    id: 'whisper-rain',
    title: 'Whisper & Rain',
    background: const LinearGradient(
      colors: [Color(0xFF070D18), Color(0xFF0A1428)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF070D18), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Caleb Storm',
    tags: ['ASMR', 'Sleep', 'Rain'],
    meta: '4 Episodes • 1h 40m • Caleb Storm',
    liveCount: '4.5K listening',
    description:
        'Rain on the window. His voice against your ear. Nothing else matters.',
    episodes: [
      const HushEpisode(title: 'The Storm', duration: '24:10'),
      const HushEpisode(title: 'Stay Close', duration: '26:30'),
      const HushEpisode(title: 'Morning Drizzle', duration: '25:20'),
      const HushEpisode(title: 'Clear', duration: '24:00'),
    ],
  ),
  HushStory(
    id: 'goodnight',
    title: 'Goodnight, Love',
    background: const LinearGradient(
      colors: [Color(0xFF100A1E), Color(0xFF1A1030)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF100A1E), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Nico Voss',
    tags: ['Comfort', 'Gentle', 'Bedtime'],
    meta: '5 Episodes • 2h 10m • Nico Voss',
    liveCount: '3.2K listening',
    description:
        'Soft words before sleep. He tells you about his day, asks about yours, and says all the things you need to hear.',
    episodes: [
      const HushEpisode(title: 'How Was Your Day', duration: '24:30'),
      const HushEpisode(title: 'I\'m Right Here', duration: '26:10'),
      const HushEpisode(title: 'Tell Me', duration: '25:20'),
      const HushEpisode(title: 'Stay', duration: '27:00'),
      const HushEpisode(title: 'Good Morning', duration: '24:50'),
    ],
  ),
  HushStory(
    id: 'cabin-night',
    title: 'Cabin Nights',
    background: const LinearGradient(
      colors: [Color(0xFF0D1008), Color(0xFF1A2010)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playerBackground: const LinearGradient(
      colors: [Color(0xFF0D1008), Color(0xFF070D10)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.6],
    ),
    artist: 'Jade Ellis',
    tags: ['Fireplace', 'Cozy', 'Isolated'],
    meta: '4 Episodes • 1h 45m • Jade Ellis',
    liveCount: '1.9K listening',
    description:
        'Snowed in. Just the two of you. A fire, a blanket, and nowhere to be.',
    episodes: [
      const HushEpisode(title: 'Arrival', duration: '24:10'),
      const HushEpisode(title: 'By the Fire', duration: '28:00'),
      const HushEpisode(title: 'Snowbound', duration: '26:30'),
      const HushEpisode(title: 'Thaw', duration: '25:00'),
    ],
  ),
];

HushStory? getHushStoryById(String id) {
  try {
    return hushStories.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}

final List<HushVoice> hushVoices = [
  HushVoice(
    initial: 'C',
    name: 'Caleb Storm',
    type: 'Deep',
    desc: 'Commanding',
    ringColor: HushColors.blush,
  ),
  HushVoice(
    initial: 'N',
    name: 'Nico Voss',
    type: 'Warm',
    desc: 'Playful',
    ringColor: HushColors.teal,
  ),
  HushVoice(
    initial: 'J',
    name: 'Jade Ellis',
    type: 'Sultry',
    desc: 'ASMR',
    ringColor: HushColors.violet,
  ),
  HushVoice(
    initial: 'L',
    name: 'Leo',
    type: 'Gentle',
    desc: 'Soft',
    ringColor: HushColors.amber,
  ),
  HushVoice(
    initial: 'A',
    name: 'Aria',
    type: 'Breathy',
    desc: 'Intimate',
    ringColor: HushColors.emerald,
  ),
];

const List<String> hushVibes = [
  'All',
  'Passionate',
  'Romantic',
  'Taboo',
  'ASMR',
  'Dreamy',
  'Rough',
];

const List<Map<String, String>> hushExploreVibes = [
  {'emoji': '🔥', 'label': 'Passionate', 'count': '128'},
  {'emoji': '🌙', 'label': 'Late Night', 'count': '94'},
  {'emoji': '💖', 'label': 'Romantic', 'count': '112'},
  {'emoji': '🔙', 'label': 'Dominant', 'count': '67'},
  {'emoji': '💜', 'label': 'Comfort', 'count': '85'},
  {'emoji': '😈', 'label': 'Taboo', 'count': '53'},
];

const List<String> trendingTags = [
  '#enemiestolovers',
  '#softdom',
  '#possessive',
  '#aftercare',
  '#jealousy',
  '#firsttime',
  '#fakerelationship',
  '#roommates',
  '#praising',
  '#forbiddenlove',
  '#bodyworshipping',
  '#voyeuristic',
];
