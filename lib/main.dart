import 'package:flutter/material.dart';

void main() => runApp(const HeavenMindApp());

const lavender = Color(0xFFEDE8FA);
const deepPurple = Color(0xFF66558F);
const sage = Color(0xFFE5F0E8);
const ink = Color(0xFF302B3D);

class HeavenMindApp extends StatelessWidget {
  const HeavenMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEAVEN MIND 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF9FC),
        colorScheme: ColorScheme.fromSeed(seedColor: deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMood = -1;
  int tab = 0;
  final journalController = TextEditingController();
  final List<String> journalEntries = [];
  final moods = const [('😊', 'Happy'), ('🙂', 'Okay'), ('😐', 'Neutral'), ('😟', 'Low'), ('😣', 'Stressed')];
  final affirmations = const [
    'I can take things one step at a time.',
    'My feelings matter, and I can ask for support.',
    'Small progress is still progress.',
    'I deserve patience, rest, and kindness.',
  ];
  int affirmationIndex = 0;

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [homePage(), journalPage(), tipsPage()];
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEAVEN MIND 3', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        actions: [IconButton(tooltip: 'About', onPressed: aboutDialog, icon: const Icon(Icons.info_outline))],
      ),
      body: SafeArea(child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 220), child: pages[tab]),
        ),
      )),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa), label: 'Wellness'),
        ],
      ),
    );
  }

  Widget homePage() => ListView(
    key: const ValueKey('home'), padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEDE8FA), Color(0xFFE7F1EA)]), borderRadius: BorderRadius.circular(28)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('A little space for you', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: ink)),
          SizedBox(height: 8),
          Text('Pause. Breathe. Begin again.', style: TextStyle(fontSize: 16, color: ink)),
          SizedBox(height: 16),
          Icon(Icons.spa_rounded, size: 42, color: deepPurple),
        ]),
      ),
      const SizedBox(height: 24),
      const SectionTitle('How are you feeling today?'),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: List.generate(moods.length, (i) => ChoiceChip(
        label: Text('${moods[i].$1} ${moods[i].$2}'),
        selected: selectedMood == i,
        onSelected: (_) => setState(() => selectedMood = i),
      ))),
      if (selectedMood >= 0) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Thanks for checking in. You chose ${moods[selectedMood].$2}. Be gentle with yourself.', style: const TextStyle(color: deepPurple))),
      const SizedBox(height: 24),
      const SectionTitle('Take a mindful minute'),
      const SizedBox(height: 12),
      FeatureCard(icon: Icons.air_rounded, color: sage, title: 'Breathing break', subtitle: 'A simple guided breathing pause', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BreathingScreen()))),
      const SizedBox(height: 12),
      FeatureCard(icon: Icons.auto_awesome_rounded, color: lavender, title: 'Daily affirmation', subtitle: affirmations[affirmationIndex], onTap: () => setState(() => affirmationIndex = (affirmationIndex + 1) % affirmations.length)),
      const SizedBox(height: 12),
      FeatureCard(icon: Icons.edit_note_rounded, color: const Color(0xFFFFF0DF), title: 'Write it out', subtitle: 'Use your private journal to reflect', onTap: () => setState(() => tab = 1)),
      const SizedBox(height: 20),
      const Text('This app supports everyday wellbeing. It is not a substitute for professional care.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ],
  );

  Widget journalPage() => ListView(key: const ValueKey('journal'), padding: const EdgeInsets.all(20), children: [
    const SectionTitle('Your journal'),
    const SizedBox(height: 8),
    const Text('Entries stay in this app session and are cleared when the app is closed.'),
    const SizedBox(height: 16),
    TextField(controller: journalController, minLines: 5, maxLines: 8, decoration: InputDecoration(hintText: 'Today I am feeling…', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none))),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: () {
      final entry = journalController.text.trim();
      if (entry.isEmpty) return;
      setState(() { journalEntries.insert(0, entry); journalController.clear(); });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Journal entry added for this session.')));
    }, icon: const Icon(Icons.save_outlined), label: const Text('Save entry')),
    const SizedBox(height: 20),
    const SectionTitle('Recent entries'),
    if (journalEntries.isEmpty) const Padding(padding: EdgeInsets.only(top: 12), child: Text('Your entries will appear here.')),
    ...journalEntries.map((entry) => Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Text(entry)))),
  ]);

  Widget tipsPage() => ListView(key: const ValueKey('tips'), padding: const EdgeInsets.all(20), children: const [
    SectionTitle('Gentle wellness ideas'),
    SizedBox(height: 14),
    TipTile(icon: Icons.water_drop_outlined, title: 'Hydrate', body: 'Take a moment to drink some water.'),
    TipTile(icon: Icons.directions_walk, title: 'Move a little', body: 'If comfortable, stretch or take a short walk.'),
    TipTile(icon: Icons.bedtime_outlined, title: 'Rest', body: 'Give yourself a screen break and a regular sleep routine.'),
    TipTile(icon: Icons.people_outline, title: 'Connect', body: 'Share how you feel with someone you trust.'),
    TipTile(icon: Icons.check_circle_outline, title: 'One small step', body: 'Choose one manageable task instead of trying to do everything.'),
    SizedBox(height: 18),
    Text('If you are struggling, speak with a trusted adult or qualified mental health professional. If you are in immediate danger, contact local emergency services.', style: TextStyle(color: Colors.black54, height: 1.5)),
  ]);

  void aboutDialog() => showAboutDialog(context: context, applicationName: 'HEAVEN MIND 3', applicationVersion: '1.0.0', children: const [Text('A simple self-care companion for reflection and everyday wellbeing. Not a medical or crisis service.')]);
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink));
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  const FeatureCard({super.key, required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: ListTile(contentPadding: const EdgeInsets.all(12), leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: deepPurple)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: onTap),
  );
}

class TipTile extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const TipTile({super.key, required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Card(color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: Icon(icon, color: deepPurple), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(body)));
}

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});
  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool started = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Breathing break')),
    body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('A calm pause', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 28),
      AnimatedContainer(duration: const Duration(seconds: 2), width: started ? 190 : 140, height: started ? 190 : 140, decoration: const BoxDecoration(color: lavender, shape: BoxShape.circle), child: const Icon(Icons.air, size: 64, color: deepPurple)),
      const SizedBox(height: 24),
      Text(started ? 'Breathe in gently… then breathe out slowly.' : 'Find a comfortable position.'),
      const SizedBox(height: 18),
      FilledButton(onPressed: () => setState(() => started = !started), child: Text(started ? 'Pause exercise' : 'Begin breathing')),
      const SizedBox(height: 10),
      const Text('Continue only while comfortable. Stop if you feel dizzy or uncomfortable.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12)),
    ]))),
  );
}
