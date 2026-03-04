import '../../core/constants/app_constants.dart';
import 'novel_model.dart';
import 'user_model.dart';

/// **Dramaverse app — demo data**
///
/// Demo novels, chapters, and reading history for development and preview.
/// Call [ensureDemoDataLoaded] from main() to load before app runs.
class MockData {
  MockData._();

  static List<Novel>? _cachedNovels;

  /// Eagerly load demo novels so they are never empty. Call from main().
  static void ensureDemoDataLoaded() {
    if (_cachedNovels == null) {
      _cachedNovels = _buildNovelsList();
    }
  }

  /// Demo novels list. Never null; falls back to minimal list if build fails.
  static List<Novel> get novels {
    ensureDemoDataLoaded();
    return _cachedNovels ?? _fallbackNovels();
  }

  static List<Novel> _fallbackNovels() {
    return [
      Novel(
        id: 'demo_1',
        title: 'Demo Story',
        author: AppConstants.appName,
        coverUrl: 'https://picsum.photos/seed/demo/400/600',
        synopsis: AppConstants.appTagline + ' Start reading.',
        genres: [NovelGenre.contemporaryRomance],
        rating: 4.5,
        reviewCount: 100,
        totalChapters: 20,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('demo_1', 20),
        isFeatured: true,
        isHot: true,
        viewCount: 1000,
      ),
    ];
  }

  static List<Novel> _buildNovelsList() {
    try {
      return [
        _novel1(),
        _novel2(),
        _novel3(),
        _novel4(),
        _novel5(),
        _novel6(),
        _novel7(),
        _novel8(),
        _novel9(),
        _novel10(),
        _novel11(),
        _novel12(),
      ];
    } catch (_) {
      return _fallbackNovels();
    }
  }

  static List<Chapter> _buildChapters(String novelId, int count) {
    return List.generate(count, (i) {
      final num = i + 1;
      final isFree = num <= 5;
      return Chapter(
        id: '${novelId}_ch_$num',
        novelId: novelId,
        number: num,
        title: _chapterTitles[i % _chapterTitles.length],
        content: _sampleChapterContent(num),
        isFree: isFree,
        coinCost: isFree ? 0 : 2,
        wordCount: 1200 + (num * 50) % 800,
        audioDuration: Duration(minutes: 8 + (num % 6), seconds: (num * 13) % 60),
      );
    });
  }

  static const List<String> _chapterTitles = [
    'The Stranger at the Door',
    'A Deal with the Devil',
    'Secrets in the Dark',
    'When Hearts Collide',
    'The Masquerade Ball',
    'Forbidden Temptation',
    'A Kiss in the Rain',
    'His Possessive Touch',
    'Shattered Walls',
    'The Morning After',
    'Dangerous Desires',
    'When She Finally Saw Him',
    'The Price of Love',
    'Midnight Confessions',
    'An Unexpected Proposal',
    'The Truth Revealed',
    'Love or Pride',
    'Chasing the Storm',
    'One Last Chance',
    'Forever Yours',
  ];

  static String _sampleChapterContent(int chapter) {
    final index = (chapter - 1) % _chapterContents.length;
    return _chapterContents[index];
  }

  /// Full chapter-length demo text for all novels in the app. One passage per chapter (1–20).
  static const List<String> _chapterContents = [
    _content1, _content2, _content3, _content4, _content5,
    _content6, _content7, _content8, _content9, _content10,
    _content11, _content12, _content13, _content14, _content15,
    _content16, _content17, _content18, _content19, _content20,
  ];

  static const String _content1 = '''The silence between them was a living, breathing thing — thick with everything left unsaid.

She stood at the floor-to-ceiling windows of the penthouse, watching the city below pulse and shimmer like a restless heart. She had told herself she wouldn't come here again. She had made that promise a hundred times in the past month, whispered it into her pillow each night like a prayer.

And yet here she was.

"You came back." His voice came from behind her — low, unhurried, carrying that quiet authority she had never been able to ignore. She didn't turn around.

"Don't flatter yourself," she said, even as her pulse betrayed her with its rapid rhythm. "I left my scarf."

A pause. She could hear the soft pad of his footsteps on the marble floor, measured and deliberate, moving closer until she could feel the warmth radiating off him at her back.

"Your scarf," he repeated, and she could hear the ghost of a smile in it.

"Yes." She finally turned, steeling herself against the sight of him — tall, dark-eyed, impossibly composed. Her biggest mistake. Possibly the love of her life. "If you could just—"

He held it out. The blue cashmere scarf, draped over one long finger with the lazy grace of a man who always had the upper hand.

She reached for it. His hand closed around her wrist.

Not rough. Never rough. That wasn't his way. He held her with careful intention, like something precious he hadn't yet decided whether to keep.

"Stay," he said simply.

And therein lay the problem: he never begged. He never manipulated. He simply asked, with that dark quiet certainty, and somehow that was infinitely more dangerous than anything else could have been.

"I shouldn't," she whispered.

"I know," he agreed. "Stay anyway."

The city lights blurred and swam below. Her resolve — carefully rebuilt over thirty-two days — crumbled like sugar in rain.

She stayed.''';

  static const String _content2 = '''The rain came down in sheets, blurring the streetlights into golden smudges. She had run out without a coat, and now she was soaked, standing under the awning of a closed bookstore, shivering.

A car pulled to the curb. The window rolled down. "Get in."

She knew that voice. She had spent three years trying to forget it. "I'm fine."

"You're dripping on the pavement. Get in."

She told herself she would only get in to get warm. She told herself she would not look at his hands on the steering wheel, or the way his jaw tightened when he glanced at her. She told herself a lot of things.

The car was warm. He had the heat on high. He didn't ask where she was going. He just drove, and she didn't tell him to stop.

"I heard you moved back," he said finally.

"Last month."

"And you didn't call."

"No."

He was quiet for a long moment. The windshield wipers beat a steady rhythm. "I would have picked you up from the airport."

"I know."

"So why didn't you call?"

She looked out the window at the rain. "Because I knew you would."

"And that's a bad thing?"

"It's a complicated thing."

He laughed — a low, rough sound. "When has it ever been simple with us?"

Never. It had never been simple. From the first day they met, there had been too much between them: attraction, resentment, history, hope. She had left to make it simple. She had failed.

"I missed you," he said. So quiet she almost didn't hear it.

She closed her eyes. "I missed you too."

The car slowed. She opened her eyes and realized they were in front of her building. He had known where she lived without her saying a word.

"Thank you for the ride," she said, hand on the door.

"Stay." Not a command. A request. "Just a little longer."

She stayed.''';

  static const String _content3 = '''The masquerade ball was in full swing — a sea of silk and feathers and anonymous faces. She had promised herself she would leave by midnight. It was now half past eleven, and she was no closer to the door than she had been an hour ago.

A hand touched her elbow. She turned.

He was wearing a black mask that left only his mouth and jaw visible. She would know that jaw anywhere. She had traced it with her fingers in the dark more times than she could count.

"Dance with me," he said.

"We shouldn't."

"We're wearing masks. No one knows who we are."

" I know who you are."

His hand slid to her waist. "Then you know I'm not going to let you leave without one dance."

The orchestra was playing something slow and aching. He led her to the floor, and she told herself it was just one dance. One dance, and then she would go.

"You're trembling," he said against her ear.

"I'm cold."

"Liar."

She was. The room was overheated, and his hand on her back was burning through the thin fabric of her dress. She had missed this — the way he held her, like she was something to be cherished and claimed in the same breath.

"I thought you weren't coming tonight," she said.

"I wasn't. Then I heard you would be here."

"You shouldn't have come."

"I know." He pulled her closer. "I came anyway."

The song ended. Another began. She didn't pull away. Somewhere in the back of her mind, she knew she was making a mistake. She didn't care.

"Stay with me tonight," he said.

She should say no. She had a hundred reasons to say no. Instead she heard herself say, "Yes."

His mask hid his smile, but she felt it in the way his hand tightened on her waist. He led her off the floor, toward the garden doors, toward the rest of their lives.''';

  static const String _content4 = '''The letter had been waiting on her desk when she arrived — thick cream paper, his handwriting unmistakable. She had stared at it for an hour before opening it.

I know you asked me not to contact you. I know you have every reason to hate me. But I need you to know that I have never stopped loving you. Not for a single day.

She had read it three times. Then she had folded it and put it in her drawer. She had not replied. She had told herself she would not reply.

That was two weeks ago. The letter was still in her drawer. She thought about it every morning when she woke and every night before she fell asleep.

Today she had received another letter.

I'm not going to stop writing. You don't have to respond. You don't have to forgive me. But I need you to know that I'm here. I've always been here. I'll be here when you're ready.

She had cried. She had not meant to, but she had sat at her desk and cried until her assistant had knocked and asked if she was all right.

Now she was standing in front of his building. She didn't remember deciding to come. She had left the office at five, walked to the train, and gotten off at his stop. Her feet had carried her here.

The doorman recognized her. "He's in the penthouse. I'll ring up."

"Don't," she said. "I'll just — I'll go."

But she didn't go. She stood in the lobby until the elevator opened and he stepped out. He was in a suit, tie loosened, and he stopped when he saw her.

"You're here," he said.

"I got your letters."

"I didn't expect you to come."

"I didn't expect to come." She took a breath. "I'm still angry. I don't know if I can forgive you."

"I know."

"But I'm here."

He crossed the lobby in three strides and took her face in his hands. "Stay. Please. Just — stay."

She nodded. It was all she could do. He kissed her forehead, then her cheek, then her mouth, and she let him. For the first time in two years, she let herself hope.''';

  static const String _content5 = '''The storm had knocked out the power. They were trapped in the cabin with nothing but candles and each other — which, as it turned out, was more than enough.

"I can't believe you drove up the mountain in this," she said, watching the snow pile against the windows.

"You said you needed to get away. I wasn't going to let you get away alone."

"That's not what I meant and you know it."

He was stretched out on the couch, one arm behind his head. In the candlelight he looked younger, softer. "I know what you meant. I came anyway."

She should be angry. She had wanted solitude. She had wanted to think. Instead she had him — his presence, his warmth, the way he looked at her like she was the only thing that mattered in the world.

"Come here," he said.

"I'm fine where I am."

"Your lips are blue. Come here."

She went. She told herself it was for the warmth. He pulled her against his side and wrapped a blanket around them both. The fire crackled. The wind howled. She could feel his heartbeat under her ear.

"I'm sorry," he said. "For everything. For the way I left. For the way I came back. For showing up here when you clearly wanted to be alone."

"It's all right."

"It's not. But I'm going to spend the rest of my life making it up to you. If you'll let me."

She closed her eyes. "I might let you."

He laughed — a soft, relieved sound. "I'll take might."

They lay there in the dark, the storm raging outside, and for the first time in months she felt something like peace. Like home.

"Stay," he said. "When the power comes back. When the roads clear. Just — stay."

She had already decided. "I'm not going anywhere."

He held her closer. She let him. And in the candlelight, with the snow falling and the world shut out, she let herself believe that maybe — maybe — they could have a second chance.''';

  static const String _content6 = '''The gala was crowded — too many people, too much champagne, and nowhere to hide. She had agreed to come as his plus-one. One night, he had said. Just one night to convince his investors that he was stable, settled, ready for the next phase.

She had worn the dress he sent. Red. She had never worn red for him before.

"You look dangerous," he had said when he picked her up.

"I feel dangerous."

He had smiled — that rare, real smile that still made her chest tight. "Good."

Now he was across the room, locked in conversation with a man in a grey suit. She stood by the balcony doors, drink in hand, and watched him. He was good at this. The charm, the nods, the way he made everyone feel like the most important person in the room. She had fallen for that once. She had fallen for all of it.

His eyes found her. He excused himself and crossed the floor. "Bored?"

"Terrified."

"Of what?"

"Of how much I want to stay." The words were out before she could stop them. She had not meant to say that. She had not meant to feel that.

He went very still. "Then stay."

"It's not that simple."

"It could be." He took her glass and set it aside. "One night was a lie. I want every night. I've wanted it since the day you left."

She should walk away. She should remember why she left. Instead she said, "Show me the balcony."''';

  static const String _content7 = '''The office was empty at midnight. She had stayed to finish the proposal. He had stayed because he always did — the last to leave, the first to arrive. They had run into each other at the elevator.

"Working late," he said.

"So are you."

"I don't have a choice. You do."

She did. She could have left at six. She could have taken the proposal home. She had told herself she liked the quiet, the empty floors, the way the city looked from the thirty-second floor when everyone else was gone. She had not admitted that she liked the possibility of this — of him, standing in the elevator bay, tie loosened, looking at her like he had something to say.

"What?" she said.

"Nothing. Just — be careful going home."

"I'm a big girl."

"I know." He smiled, but it didn't reach his eyes. "That's what worries me."

She should get in the elevator. She should go home. "Do you want to get coffee? There's a place on the corner that's open late."

He looked at her for a long moment. "Yes."

They didn't get coffee. They sat in his office with the lights off and the city glowing below, and they talked about everything except the thing that had been between them for two years. When the sun came up, she was still there.''';

  static const String _content8 = '''The wedding was beautiful. Of course it was. She had planned every detail — the flowers, the music, the way the light would fall through the stained glass at exactly four o'clock. She had planned it all for someone else. For her best friend and the man her best friend was marrying.

The man she had once thought she would marry.

He was at the reception. She had known he would be. He was the groom's brother. He was standing by the bar when she finally worked up the courage to look at him. He was already looking at her.

She crossed the room. Her heels clicked on the floor. Her dress was blue. He had always said she looked good in blue.

"You came," he said.

"I wouldn't have missed it."

"I thought you might."

"I thought about it." She took a glass of champagne from the tray. "I'm glad I didn't."

He was quiet. The band was playing something slow. "Dance with me."

"We shouldn't."

"We've done a lot of things we shouldn't." He held out his hand. "One more won't hurt."

She took it. He led her to the floor. His hand was warm on her waist. She had forgotten how warm. "I'm sorry," she said. "For everything."

"Me too."

"I don't want to be sorry anymore."

"Then don't be." He pulled her closer. "Stay. After the wedding. Stay with me."

She had already decided. "Yes."''';

  static const String _content9 = '''The hospital corridor was too bright. She had been sitting in the plastic chair for three hours. The doctor had said he would be fine — a broken arm, a concussion, nothing that wouldn't heal. She had nodded and sat down and not moved since.

The door opened. He was awake. He looked pale, tired, and when he saw her his face did something complicated. "You're still here."

"Where else would I be?"

"You could have gone home. It's late."

"I know."

He held out his good hand. She took it. His fingers were cold. "I thought you'd left. For good, I mean. After the fight."

"I did leave. Then I got the call."

"And you came back."

"Yes."

He closed his eyes. "I'm sorry. For what I said. I didn't mean it."

"I know."

"I'm glad you're here."

She squeezed his hand. "I'm not going anywhere."

He opened his eyes. "Promise?"

"Promise."

He smiled — a small, fragile thing. "Okay. Then I can sleep."

She stayed. She stayed when he fell asleep, when the nurses came and went, when the sun came up. She was still there when he woke.''';

  static const String _content10 = '''The bookshop was his idea. She had mentioned once that she had always wanted to run one — something small, with a cat and a reading nook and the smell of old paper. He had remembered. He had found the space. He had signed the lease before telling her.

"I can't believe you did this," she said, standing in the empty storefront. Dust motes floated in the afternoon light.

"Do you like it?"

"It's perfect. But I can't — we can't —"

"We can." He was leaning against the doorframe, arms crossed. "I've already talked to the bank. The first year's rent is covered. The rest is up to you. And the cat. I'm getting you a cat."

She laughed. She couldn't help it. "You're insane."

"I've been told." He walked over and took her hands. "I know we said we'd take it slow. I know we said we'd be careful. But I'm done being careful. I want to build something with you. This is me building."

She looked at the empty shelves, the high ceilings, the window that would be perfect for displays. "What if I fail?"

"Then we fail together. But you won't fail." He kissed her forehead. "You're the bravest person I know."

She believed him. Maybe that was the craziest part. "Okay. Okay. Let's get a cat."

He grinned. "I already have one picked out."''';

  static const String _content11 = '''The text had been simple: I'm at the airport. Come or don't. No pressure.

She had stared at it for ten minutes. She had thought about deleting it. She had thought about blocking his number. She had thought about all the reasons this was a bad idea. Then she had grabbed her keys and driven to the airport.

He was at Arrivals, one bag at his feet, looking like he hadn't slept in days. When he saw her, something in his face relaxed. "You came."

"You said no pressure."

"There's always pressure." He picked up his bag. "Thank you."

"Where are you staying?"

"I hadn't thought that far ahead."

She had. "My place. You can have the couch."

"The couch?"

"Don't push it."

He smiled. "The couch is perfect."

They didn't talk in the car. They didn't talk when she showed him the apartment or when she gave him a towel and pointed to the shower. They didn't talk until he was standing in her kitchen, hair still damp, and said, "I'm not here for the couch."

"I know."

"I'm here because I can't be anywhere else without you."

She had known that too. "How long are you staying?"

"As long as you'll have me."

She crossed the room and kissed him. "Then you'd better get comfortable."''';

  static const String _content12 = '''The art gallery was quiet on a Tuesday afternoon. She had come to see the new exhibit. She had not expected to see him — standing in front of a painting she had once said was her favourite, like he had remembered.

"You're here," she said.

He didn't turn around. "I come every time they have a new show. In case you're here too."

"That's —"

"Pathetic? I know."

"Sweet. I was going to say sweet." She stepped closer. The painting was of a woman by a window, light streaming in. "I still love this one."

"I know. You told me. Three years ago."

She had. She had told him a lot of things. "I meant what I said. Back then. All of it."

"So did I." He finally looked at her. "I never stopped meaning it."

The gallery was empty. The guard was in the next room. She took his hand. "There's a café down the street. We could talk. Properly."

"I'd like that."

They talked. They talked for three hours. When the café closed, they walked through the city. When the sun came up, they were still walking. "Stay," he said, at her door. "Or I'll stay. Whichever is easier."

She opened the door. "You're already here. You might as well come in."''';

  static const String _content13 = '''The rooftop was his secret. He had brought her here on their third date. She had forgotten how to breathe when she saw the view — the city spread out below, the lights, the endless sky. He had said, "I wanted to show you my favourite place."

Now it was their place. Or it had been. She wasn't sure what it was anymore. She had come up here alone tonight, not sure why, and found him already there.

"You're here," he said. He was sitting on the ledge, legs dangling. She had always been afraid he would fall. He never did.

"So are you."

"I come here when I need to think. Or when I need not to think."

"Which is it tonight?"

"Both." He patted the space beside him. She sat. "I've been doing a lot of thinking. About us. About what I want."

"And what do you want?"

"You. I want you. I've always wanted you. I was just too stupid to say it properly." He looked at her. "I'm saying it now. Stay with me. Not just tonight. Not just when it's easy. Stay."

The city glittered below. She had missed this. She had missed him. "I'm scared."

"Me too. We can be scared together."

She took his hand. "Okay. I'll stay."

He pulled her close. "Thank you."

She rested her head on his shoulder. "Don't make me regret it."

"I won't. I promise."''';

  static const String _content14 = '''The coffee was cold. She had been holding it for twenty minutes, watching the door. He was late. He was always late. She had told herself she would leave at seven. It was 7:03.

The door opened. He was there — rumpled, apologetic, holding a single rose. "I'm sorry. The meeting ran over. I ran the whole way."

"You ran?"

"I didn't want you to leave."

She had been about to leave. She had been about to give up. "Sit down. You're making a scene."

He sat. He put the rose on the table between them. "I have something to say. I've been practising. Don't interrupt."

"Okay."

"I love you. I've loved you for a long time. I was too afraid to say it because I thought you'd run. But I'd rather say it and watch you run than never say it at all. So. I love you. Your turn."

She had not been expecting that. "I —"

"Your turn," he said again. "No pressure. But. Your turn."

She took a breath. "I love you too. I've been waiting for you to say it first."

"Why?"

"Because I was afraid you'd run."

He laughed. He reached across the table and took her hand. "I'm not going anywhere. Are you?"

"No."

"Good." He picked up his menu. "Now I'm starving. Order something with me?"''';

  static const String _content15 = '''The beach was empty at dawn. She had come to watch the sunrise. She had not expected to find him there — sitting in the sand, shoes off, watching the horizon. He looked up when he heard her footsteps.

"Couldn't sleep?" he said.

"Could you?"

"No." He moved over. "Sit. It's about to start."

She sat. The sky was turning pink and gold. "I've been thinking about what you said. About starting over."

"And?"

"I want to. I'm scared. But I want to."

He took her hand. "I'm scared too. We'll figure it out together."

"The last time we tried —"

"The last time we didn't try. We just let it happen and then let it fall apart. This time we try. We talk. We show up."

She looked at him. The sun was rising behind him, painting him in light. "What if it's not enough?"

"Then we try harder. I'm not giving up on us again."

The sun broke over the horizon. She squeezed his hand. "Okay. Let's try."

He smiled. "Thank you."

They sat there until the beach filled with joggers and families. Then they walked back to the car, hand in hand, and she thought maybe — maybe — they could get it right this time.''';

  static const String _content16 = '''The party was too loud. She had slipped outside to the garden. The air was cool. The stars were out. She had needed a moment alone. She had not expected to find him on the bench, staring at the sky.

"Room for one more?" she said.

He looked over. "Always." He moved to the side. She sat. "Couldn't take the noise?"

"Couldn't take the small talk. How are you? What do you do? When are you two getting married?"

He winced. "Sorry. My mother's been asking everyone."

"It's fine. I've been asking myself the same question."

He went still. "You have?"

"I have." She looked at the stars. "I don't have an answer yet. But I'm thinking about it."

"Take your time. I'm not going anywhere."

"You've been saying that for a year."

"And I've meant it for a year." He took her hand. "Whenever you're ready. If you're ever ready. I'm here."

She leaned against his shoulder. "I know. That's why I'm thinking about it."

They sat in silence. The party continued inside. Out here it was just the two of them and the stars. "Stay out here with me," he said. "Just a little longer."

"Okay."

He kissed her temple. "Thank you."''';

  static const String _content17 = '''The train was delayed. She was stuck in the station with nothing to do but wait. She had bought a coffee she didn't want and found a seat. Then she saw him — standing by the board, bag at his feet, looking as lost as she felt.

"Hey," she said. He looked over. "Going somewhere?"

"Trying to. You?"

"Same." She gestured to the empty seat. "Sit. We can be lost together."

He sat. "I was going to see my sister. She's having a baby. I was supposed to be there yesterday."

"Congratulations."

"Thanks. You?"

"Meeting a friend. Or I was. She cancelled. I'm going anyway. Change of scenery."

The announcement came: another delay. He sighed. "So we're stuck."

"Looks like it." She held out her coffee. "Want a sip? I'm not going to drink it."

He took it. "Thanks." They sat in silence. Then he said, "I know we don't know each other. But. Would you want to get lunch? While we wait? I don't want to sit here alone."

She had been about to say no. She had been about to make an excuse. Instead she said, "Yes. I'd like that."

They had lunch. The train was delayed for three more hours. By the time it left, they had exchanged numbers. By the time she got home, he had already texted. She smiled. Maybe the delay was the best thing that had happened all week.''';

  static const String _content18 = '''The library was her sanctuary. She had been coming here since she was a child. She knew every shelf, every corner, every chair. She had not expected to find him in her favourite spot — the window seat on the second floor, the one with the best light.

"That's my seat," she said.

He looked up from his book. "I didn't know seats could be claimed."

"They can. By me. For years."

He moved over. "Share?"

She should say no. She should find another spot. Instead she sat. "What are you reading?"

He showed her the cover. She had read it. They talked about it. Then they talked about other books. Then they talked about everything. When the library closed, they were still talking.

"I have to go," she said. "But. Could we do this again? Meet here? Read together?"

"I'd like that. Same time next week?"

"Yes."

He smiled. "I'll save your seat."

She came back the next week. He was there. He had saved her seat. They read in silence. Sometimes they talked. It became a habit. It became the best part of her week. One day he said, "I know we only see each other here. But I'd like to see you somewhere else. Dinner? Coffee? Anything."

She had been hoping he would ask. "Dinner. Tomorrow?"

"Tomorrow." He wrote his number on a slip of paper and tucked it in her book. "Don't lose that."

She didn't. She still has it.''';

  static const String _content19 = '''The voicemail had been two minutes long. She had listened to it five times. I know you said not to call. I know you need space. I'm giving you space. But I need you to know that I'm here. I'm always here. When you're ready. If you're ever ready. I'll be waiting.

She had cried. She had deleted the voicemail. She had then called her carrier to see if they could recover a deleted voicemail. They could not. She had written down what she remembered. She had kept it in her drawer.

That was six months ago. Now she was standing on his doorstep. She had not called. She had not texted. She had just come.

He opened the door. He was in a t-shirt and sweatpants. He had not been expecting anyone. When he saw her, his face went through a dozen emotions. "You're here."

"I'm here."

"You got my — I left a voicemail. Months ago."

"I got it. I'm sorry it took me so long."

He stepped aside. "Come in."

She went in. The apartment was the same. The couch, the books, the view. She had missed it. She had missed him. "I'm ready," she said. "I'm ready to try. If you still want to."

He crossed the room in two strides and pulled her into a hug. "I've been waiting. I'll always be waiting."

She held him back. "I'm not going to make you wait anymore."

"Good." He pulled back and looked at her. "Stay? Tonight? Forever? Whatever you're comfortable with."

"Tonight," she said. "And we'll see about forever."

He smiled. "I can work with that."''';

  static const String _content20 = '''The last page of the letter was blank. She had read it three times. He had written about the past year — the distance, the silence, the way he had missed her every day. He had written about the future he wanted. He had left the last page blank. At the bottom, in small letters: Your turn. Fill this in. Tell me what you want. I'll make it happen.

She had stared at the blank page for an hour. Then she had started writing. She wrote about the past year — her fear, her pride, the way she had missed him too. She wrote about the future she wanted. She wrote until the page was full. Then she sealed the envelope and drove to his house.

He was in the garden. He was planting something. When he saw her, he stood. "You came."

"I got your letter."

"And?"

She held out the envelope. "I filled in the last page."

He took it. He read it there, in the garden, with the sun on his face. When he was done, he looked at her. "Is this true? All of it?"

"Yes."

He crossed the space between them and kissed her. "Then stay. Today. Tomorrow. As long as you want."

"I want forever," she said. "If that's okay."

"Forever is perfect." He took her hand. "Come inside. We have a lot to plan."

She went. They planned. And for the first time in a long time, forever felt possible.''';

  static Novel _novel1() => Novel(
        id: 'novel_1',
        title: 'The Billionaire\'s Secret Bride',
        author: 'Victoria Lane',
        coverUrl: 'https://picsum.photos/seed/novel1/400/600',
        synopsis:
            'Elena never expected to wake up married to the most powerful man in New York. Damian Ashford plays by his own rules — and now she\'s caught in his game of desire, secrets, and impossible choices. Can love survive when everything between them began as a lie?',
        genres: [NovelGenre.billionaire, NovelGenre.enemiesToLovers],
        rating: 4.8,
        reviewCount: 12453,
        totalChapters: 120,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_1', 20),
        isFeatured: true,
        isHot: true,
        viewCount: 2340000,
      );
  static Novel _novel2() => Novel(
        id: 'novel_2',
        title: 'Claimed by the Dark Prince',
        author: 'Scarlett Moore',
        coverUrl: 'https://picsum.photos/seed/novel2/400/600',
        synopsis:
            'He was supposed to be the villain of her story. But when Prince Lucian of the Shadow Court claims Aria as his own, she discovers that darkness has never looked so beautiful — or so dangerous.',
        genres: [NovelGenre.darkRomance, NovelGenre.paranormalRomance],
        rating: 4.9,
        reviewCount: 9821,
        totalChapters: 85,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_2', 20),
        isFeatured: true,
        isHot: true,
        viewCount: 1870000,
      );
  static Novel _novel3() => Novel(
        id: 'novel_3',
        title: 'The CEO\'s Convenient Wife',
        author: 'Jade Sterling',
        coverUrl: 'https://picsum.photos/seed/novel3/400/600',
        synopsis:
            'A contract marriage, a cold CEO, and one undeniable chemistry that refuses to stay professional. Sophie agreed to be Marcus\'s wife on paper — she never agreed to fall for him.',
        genres: [NovelGenre.billionaire, NovelGenre.contemporaryRomance],
        rating: 4.6,
        reviewCount: 8234,
        totalChapters: 95,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_3', 20),
        isNew: true,
        viewCount: 1230000,
      );
  static Novel _novel4() => Novel(
        id: 'novel_4',
        title: 'Sins of the Royal Court',
        author: 'Rosalind Vaux',
        coverUrl: 'https://picsum.photos/seed/novel4/400/600',
        synopsis:
            'Lady Catherine was never meant to catch the king\'s eye. But when royal desire collides with political intrigue, their forbidden love could topple an entire kingdom.',
        genres: [NovelGenre.royalRomance, NovelGenre.forbiddenLove],
        rating: 4.7,
        reviewCount: 6512,
        totalChapters: 110,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_4', 20),
        isFeatured: true,
        viewCount: 980000,
      );
  static Novel _novel5() => Novel(
        id: 'novel_5',
        title: 'After the Storm',
        author: 'Lily Chen',
        coverUrl: 'https://picsum.photos/seed/novel5/400/600',
        synopsis:
            'Five years after their devastating breakup, Nora never expected to see Jake again — let alone as her new boss. Second chances don\'t come twice. Or do they?',
        genres: [NovelGenre.secondChance, NovelGenre.contemporaryRomance],
        rating: 4.5,
        reviewCount: 5891,
        totalChapters: 70,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_5', 20),
        isNew: true,
        viewCount: 760000,
      );
  static Novel _novel6() => Novel(
        id: 'novel_6',
        title: 'Midnight with the Mafia King',
        author: 'Aria Dante',
        coverUrl: 'https://picsum.photos/seed/novel6/400/600',
        synopsis:
            'She witnessed something she shouldn\'t have. Now the most dangerous man in the city says she belongs to him — for protection. But protection never felt this intoxicating.',
        genres: [NovelGenre.darkRomance, NovelGenre.forbiddenLove],
        rating: 4.8,
        reviewCount: 11200,
        totalChapters: 130,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_6', 20),
        isHot: true,
        viewCount: 3100000,
      );
  static Novel _novel7() => Novel(
        id: 'novel_7',
        title: 'The Highlander\'s Vow',
        author: 'Fiona MacRae',
        coverUrl: 'https://picsum.photos/seed/novel7/400/600',
        synopsis:
            'Transported to 18th-century Scotland, modern woman Jess finds herself bound to a fierce Highland warrior by an ancient vow neither of them asked for — and a love neither can deny.',
        genres: [NovelGenre.historicalRomance, NovelGenre.paranormalRomance],
        rating: 4.6,
        reviewCount: 4320,
        totalChapters: 88,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_7', 20),
        viewCount: 620000,
      );
  static Novel _novel8() => Novel(
        id: 'novel_8',
        title: 'Love in the Enemy\'s Arms',
        author: 'Cassandra Wells',
        coverUrl: 'https://picsum.photos/seed/novel8/400/600',
        synopsis:
            'Their families have been rivals for generations. But when a blizzard strands Emma and Ethan in the same mountain cabin for a week, old feuds become the least of their problems.',
        genres: [NovelGenre.enemiesToLovers, NovelGenre.contemporaryRomance],
        rating: 4.4,
        reviewCount: 3987,
        totalChapters: 62,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_8', 20),
        isNew: true,
        viewCount: 540000,
      );

  static Novel _novel9() => Novel(
        id: 'novel_9',
        title: 'The Drama We Deserve',
        author: 'Maya Reid',
        coverUrl: 'https://picsum.photos/seed/novel9/400/600',
        synopsis:
            'Reality TV brought them together. The tabloids tore them apart. Now five years later, the cameras are rolling again — and so are old feelings that never really died.',
        genres: [NovelGenre.contemporaryRomance, NovelGenre.secondChance],
        rating: 4.6,
        reviewCount: 7210,
        totalChapters: 78,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_9', 20),
        isFeatured: true,
        isNew: true,
        viewCount: 1650000,
      );

  static Novel _novel10() => Novel(
        id: 'novel_10',
        title: 'Empire of Scandal',
        author: 'Dominic Vale',
        coverUrl: 'https://picsum.photos/seed/novel10/400/600',
        synopsis:
            'The Ashworth dynasty runs on secrets. When investigative journalist Sienna gets too close to the truth, the heir to the empire makes her an offer she can\'t refuse: his bed or his lawyers.',
        genres: [NovelGenre.billionaire, NovelGenre.darkRomance],
        rating: 4.7,
        reviewCount: 8940,
        totalChapters: 95,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_10', 20),
        isHot: true,
        viewCount: 2100000,
      );

  static Novel _novel11() => Novel(
        id: 'novel_11',
        title: 'Between the Lines',
        author: 'Elena Cross',
        coverUrl: 'https://picsum.photos/seed/novel11/400/600',
        synopsis:
            'She writes the steamy novels. He\'s the reclusive actor cast in the adaptation. When they\'re forced to collaborate on the script, the chemistry on the page spills into real life.',
        genres: [NovelGenre.contemporaryRomance, NovelGenre.enemiesToLovers],
        rating: 4.5,
        reviewCount: 5120,
        totalChapters: 68,
        status: NovelStatus.completed,
        chapters: _buildChapters('novel_11', 20),
        isNew: true,
        viewCount: 890000,
      );

  static Novel _novel12() => Novel(
        id: 'novel_12',
        title: 'Crown of Thorns',
        author: 'Sera Blackwood',
        coverUrl: 'https://picsum.photos/seed/novel12/400/600',
        synopsis:
            'In a kingdom where the crown passes through blood and betrayal, the princess and the captain of the guard walk a forbidden line. One wrong step could cost them everything.',
        genres: [NovelGenre.royalRomance, NovelGenre.forbiddenLove],
        rating: 4.8,
        reviewCount: 10300,
        totalChapters: 102,
        status: NovelStatus.ongoing,
        chapters: _buildChapters('novel_12', 20),
        isFeatured: true,
        isHot: true,
        viewCount: 2780000,
      );

  static List<ReadingProgress> get sampleReadingHistory => [
        ReadingProgress(
          novelId: 'novel_1',
          novelTitle: 'The Billionaire\'s Secret Bride',
          coverUrl: 'https://picsum.photos/seed/novel1/400/600',
          currentChapter: 12,
          totalChapters: 120,
          lastReadAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ReadingProgress(
          novelId: 'novel_6',
          novelTitle: 'Midnight with the Mafia King',
          coverUrl: 'https://picsum.photos/seed/novel6/400/600',
          currentChapter: 7,
          totalChapters: 130,
          lastReadAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ReadingProgress(
          novelId: 'novel_3',
          novelTitle: 'The CEO\'s Convenient Wife',
          coverUrl: 'https://picsum.photos/seed/novel3/400/600',
          currentChapter: 3,
          totalChapters: 95,
          lastReadAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ReadingProgress(
          novelId: 'novel_9',
          novelTitle: 'The Drama We Deserve',
          coverUrl: 'https://picsum.photos/seed/novel9/400/600',
          currentChapter: 14,
          totalChapters: 78,
          lastReadAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        ReadingProgress(
          novelId: 'novel_12',
          novelTitle: 'Crown of Thorns',
          coverUrl: 'https://picsum.photos/seed/novel12/400/600',
          currentChapter: 5,
          totalChapters: 102,
          lastReadAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
}
