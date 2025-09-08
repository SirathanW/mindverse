// 🌌 MindVerse — main.dart (Dark Luxury, Mobile-Constrained, Pro Buttons, Voice Chat Demo)
// อัปเดต: จำกัดความกว้างเท่าจอมือถือ (~430px) • ปุ่มทุกหน้าเต็มความกว้าง • หน้าแชต AI เพิ่ม "ถามด้วยเสียง"
// หมายเหตุ: ฟีเจอร์เสียงเป็น DEMO (จำลองการฟังและแปลงเสียงเป็นข้อความ) — พร้อมจุดต่อ Speech‑to‑Text จริงภายหลัง

import 'dart:async';
import 'package:flutter/material.dart';

// 🎨 พาเลตหรูหรา (global)
const obsidian = Color(0xFF0B0B10);
const royal = Color(0xFF6D28D9);
const sapphire = Color(0xFF4338CA);
const tealNeo = Color(0xFF0EA5A4);
const softGold = Color(0xFFF5D483);
const velvet = Color(0xFF1B1428);

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.dark; // เริ่ม Dark เพื่อความหรู
  String _lang = 'en';

  void _toggleTheme() => setState(() => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  void _setLang(String code) => setState(() => _lang = code);

  ButtonStyle _fullWidthBtn(Color bg, Color fg) => ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: .3),
      );

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: royal, brightness: Brightness.light),
      scaffoldBackgroundColor: const Color(0xFFF6F6FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2B2B34)),
        iconTheme: IconThemeData(color: Color(0xFF2B2B34)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _fullWidthBtn(royal, Colors.white),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: Color(0xFF2B2B34)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          foregroundColor: const Color(0xFF2B2B34),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _fullWidthBtn(royal, Colors.white),
      ),
    );

    final dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: royal, brightness: Brightness.dark),
      scaffoldBackgroundColor: obsidian,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(letterSpacing: 0.2),
        bodyMedium: TextStyle(letterSpacing: 0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _fullWidthBtn(royal, Colors.white),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _fullWidthBtn(royal, Colors.white),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindVerse — AI',
      theme: light,
      darkTheme: dark,
      themeMode: _mode,
      home: RootShell(
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
        currentLang: _lang,
        onChangeLang: _setLang,
      ),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.isDark, required this.onToggleTheme, required this.currentLang, required this.onChangeLang});
  final bool isDark;
  final VoidCallback onToggleTheme;
  final String currentLang;
  final void Function(String) onChangeLang;
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(isDark: widget.isDark, onToggleTheme: widget.onToggleTheme),
      const AuraScanPage(),
      const ChatAIPage(),
      const HoroscopePage(),
      ProfilePage(
        currentLang: widget.currentLang,
        onChangeLang: widget.onChangeLang,
        isDark: widget.isDark,
        onToggleTheme: widget.onToggleTheme,
      ),
    ];

    return Scaffold(
      // พื้นหลังไล่เฉดทั้งแอพ
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0C14), Color(0xFF0F0F16)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: pages[_index],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F0F16), Color(0xFF1B1730)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, -4))],
            border: Border.all(color: Colors.white12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _index,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: softGold,
              unselectedItemColor: Colors.white70,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              onTap: (i) => setState(() => _index = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'โฮม'),
                BottomNavigationBarItem(icon: Icon(Icons.camera_enhance_rounded), label: 'ออรา'),
                BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: 'แชต AI'),
                BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'ดูดวง'),
                BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'โปรไฟล์'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 📱 Mobile-Constrain Helper — จำกัดความกว้างสูงสุด ~430px และจัดกึ่งกลาง
class ShellWidth extends StatelessWidget {
  const ShellWidth({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final maxW = c.maxWidth.clamp(0.0, 430.0);
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: child,
        ),
      );
    });
  }
}

// 🏠 HOME — พรีเมียมโทนเข้ม + Banner + Quick actions
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isDark, required this.onToggleTheme});
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ShellWidth(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              title: const Text('MindVerse', style: TextStyle(fontWeight: FontWeight.w900)),
              actions: [
                IconButton(
                  tooltip: isDark ? 'Light' : 'Dark',
                  onPressed: onToggleTheme,
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF171421), Color(0xFF241B3B), Color(0xFF101018)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 28, offset: Offset(0, 12))],
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Row(children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.auto_awesome_rounded, color: softGold, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI ระดับโลกสำหรับคุณ — สแกนออรา · แชตอัจฉริยะ · ดูดวงพรีเมียม',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: const [
                    _QuickCard(icon: Icons.camera_enhance_rounded, title: 'สแกนออรา', colors: [Color(0xFF1E1A32), royal]),
                    SizedBox(height: 12),
                    _QuickCard(icon: Icons.forum_rounded, title: 'แชต AI', colors: [Color(0xFF1B2A2A), tealNeo]),
                    SizedBox(height: 12),
                    _QuickCard(icon: Icons.auto_awesome_rounded, title: 'ดูดวงพรีเมียม', colors: [Color(0xFF2A1E2C), sapphire]),
                  ],
                ),
              ),
            ),
            // ปุ่ม CTA เต็มความกว้าง (ตัวอย่าง)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('เริ่มต้นใช้งาน MindVerse'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.icon, required this.title, required this.colors});
  final IconData icon;
  final String title;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))],
        border: Border.all(color: Colors.white10),
      ),
      child: Row(children: [
        Icon(icon, color: softGold, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        const Icon(Icons.chevron_right_rounded, color: Colors.white70),
      ]),
    );
  }
}

// 🔮 AURA SCAN — เดโมเอฟเฟกต์เรืองแสง (พร้อมต่อกล้องจริง)
class AuraScanPage extends StatefulWidget {
  const AuraScanPage({super.key});
  @override
  State<AuraScanPage> createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage> {
  bool _simulating = false;
  Timer? _timer;
  double _glow = 0.4;

  void _startSimulate() {
    setState(() => _simulating = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      setState(() => _glow = 0.25 + (DateTime.now().millisecond % 700) / 1000);
    });
  }

  void _stopSimulate() {
    _timer?.cancel();
    setState(() => _simulating = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ShellWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _Header(title: 'สแกนออรา (Aura Scan)', subtitle: 'เดโม UI — เชื่อมกล้อง/ML เพิ่มภายหลัง'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xFF0E0E15), borderRadius: BorderRadius.circular(16)),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 260,
                      height: 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: royal.withOpacity(_glow), blurRadius: 86, spreadRadius: 10),
                          BoxShadow(color: tealNeo.withOpacity(_glow * 0.8), blurRadius: 64, spreadRadius: 8),
                        ],
                        border: Border.all(color: Colors.white24, width: 1.6),
                      ),
                    ),
                    if (!_simulating)
                      const Text('กด "เริ่มสแกน" เพื่อจำลองออรา', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _simulating ? null : _startSimulate,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('เริ่มสแกน'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _simulating ? _stopSimulate : null,
                    icon: const Icon(Icons.stop_circle_rounded),
                    label: const Text('หยุด'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🤖 CHAT AI — AI Persona "ตรงกลาง" + Voice Ask (DEMO) + Glass Bubble + Typing Dots
class ChatAIPage extends StatefulWidget {
  const ChatAIPage({super.key});
  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  final List<_Msg> _msgs = <_Msg>[];
  final TextEditingController _c = TextEditingController();
  bool _loading = false;

  void _send() async {
    final text = _c.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(role: 'user', text: text));
      _loading = true;
      _c.clear();
    });
    await Future.delayed(const Duration(milliseconds: 850));
    setState(() {
      _msgs.add(_Msg(role: 'ai', text: 'นี่คือคำตอบตัวอย่างจาก AI สำหรับ: "$text"\n(เชื่อมต่อโมเดลจริงภายหลัง)'));
      _loading = false;
    });
  }

  Future<void> _startVoiceDemo() async {
    // DEMO: เปิด BottomSheet แสดงสถานะกำลังฟัง + แถบคลื่น
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF0F0F16),
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.6),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => const _VoiceSheet(),
    );

    if (result != null && result.trim().isNotEmpty) {
      _c.text = result;
      await Future.delayed(const Duration(milliseconds: 200));
      _send();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxBubble = (size.width * 0.9).clamp(280.0, 430.0); // บับเบิล ~90% ของความกว้างจอ

    return SafeArea(
      child: ShellWidth(
        child: Column(children: [
          // ⭐ AI Persona อยู่ตรงกลาง พร้อมแผ่น Glass ใต้หน้า
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(children: const [
              _AICenterFace(),
              SizedBox(height: 10),
              _GlassTag(text: 'MindVerse Assistant · Voice & Text')
            ]),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _msgs.length + (_loading ? 1 : 0),
              itemBuilder: (_, i) {
                if (_loading && i == _msgs.length) {
                  return const _TypingDotsCentered();
                }
                final m = _msgs[i];
                final isUser = m.role == 'user';
                final bubble = Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  constraints: BoxConstraints(maxWidth: maxBubble),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(colors: [Color(0xFF10302F), Color(0xFF1E2F44)])
                        : const LinearGradient(colors: [Color(0xFF241B3B), Color(0xFF171421)]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))],
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    m.text,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, height: 1.35),
                  ),
                );
                if (isUser) {
                  return Align(alignment: Alignment.centerRight, child: bubble);
                } else {
                  return Align(alignment: Alignment.center, child: bubble);
                }
              },
            ),
          ),

          // กล่องพิมพ์ + ปุ่มส่ง + ปุ่มถามด้วยเสียง (เต็มความกว้าง)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _c,
                  decoration: InputDecoration(
                    hintText: 'พิมพ์หรือกดปุ่มไมค์เพื่อถามด้วยเสียง…',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF15151E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _send(),
                  minLines: 1,
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _send,
                  icon: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded),
                  label: Text(_loading ? 'กำลังส่ง…' : 'ส่งข้อความถึง MindVerse'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _startVoiceDemo,
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('ถามด้วยเสียง (เดโม)'),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

// 🗣️ BottomSheet เดโมสำหรับถามด้วยเสียง + แถบคลื่นหรู + นับเวลา
class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet();
  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<_VoiceSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  int _sec = 0;
  Timer? _timer;
  bool _recording = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _sec++));
  }

  @override
  void dispose() {
    _ac.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _stopAndReturn() {
    // DEMO: ส่งข้อความจำลองกลับไป
    Navigator.of(context).pop('สวัสดี MindVerse ช่วยแนะนำการทำสมาธิสำหรับลดความเครียดให้หน่อย');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            gradient: LinearGradient(colors: [Color(0xFF141320), Color(0xFF1B1730)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 16),
              const Text('กำลังฟัง…', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('00:${_sec.toString().padLeft(2, '0')}', style: const TextStyle(color: softGold, fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 16),
              SizedBox(height: 72, child: _WaveBars(ac: _ac)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _stopAndReturn,
                icon: const Icon(Icons.stop_rounded),
                label: const Text('หยุดและส่งข้อความ'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                label: const Text('ยกเลิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// แอนิเมชันแท่งคลื่นเสียงสไตล์พรีเมียม
class _WaveBars extends StatelessWidget {
  const _WaveBars({required this.ac});
  final AnimationController ac;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ac,
      builder: (_, __) {
        final t = ac.value; // 0..1
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(24, (i) {
            final phase = (t + i * 0.04) % 1.0;
            final h = 14 + (phase < .5 ? phase * 2 : (1 - phase) * 2) * 44; // 14..58
            return Container(
              width: 6,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(colors: [royal, tealNeo], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2))],
              ),
            );
          }),
        );
      },
    );
  }
}

// 🪞 Glass tag (ป้ายแก้วหรูใต้หน้า)
class _GlassTag extends StatelessWidget {
  const _GlassTag({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
    );
  }
}

// จุดกระพริบระหว่างกำลังพิมพ์ (ตรงกลาง)
class _TypingDotsCentered extends StatefulWidget {
  const _TypingDotsCentered();
  @override
  State<_TypingDotsCentered> createState() => _TypingDotsCenteredState();
}

class _TypingDotsCenteredState extends State<_TypingDotsCentered> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  @override
  void dispose() { _ac.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: AnimatedBuilder(
          animation: _ac,
          builder: (_, __) {
            final t = _ac.value; // 0..1
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final phase = (t + i * 0.2) % 1.0;
                final s = 6.0 + 4.0 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2);
                return Container(
                  width: s,
                  height: s,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(color: softGold, shape: BoxShape.circle),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

// วิดเจ็ต "หน้าคนเหมือนจริง" กลางจอ (ภาพตัวอย่าง) + กรอบไล่เฉดหรู
class _AICenterFace extends StatefulWidget {
  const _AICenterFace();
  @override
  State<_AICenterFace> createState() => _AICenterFaceState();
}

class _AICenterFaceState extends State<_AICenterFace> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  @override
  void dispose() { _ac.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        final t = _ac.value; // 0..1
        final glow = 0.25 + 0.35 * t;
        return Container(
          padding: const EdgeInsets.all(3.2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [royal, tealNeo]),
            boxShadow: [
              BoxShadow(color: royal.withOpacity(glow), blurRadius: 30 + 20 * t, spreadRadius: 2 + 2 * t),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF0E0E15),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/240?img=65',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.face_rounded, color: softGold, size: 48),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Msg {
  final String role; // 'user' | 'ai'
  final String text;
  const _Msg({required this.role, required this.text});
}

// ✨ HOROSCOPE — โทนเข้ม พรีเมียม เต็มจอ + ปุ่มเต็มความกว้าง
class HoroscopePage extends StatefulWidget {
  const HoroscopePage({super.key});
  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  final List<String> _zodiacs = const [
    'เมษ', 'พฤษภ', 'เมถุน', 'กรกฎ', 'สิงห์', 'กันย์', 'ตุลย์', 'พิจิก', 'ธนู', 'มังกร', 'กุมภ์', 'มีน'
  ];
  String _selected = 'เมษ';
  DateTime _dob = DateTime(1995, 1, 1);
  String _result = 'เลือกข้อมูลเพื่อดูคำทำนาย';

  void _gen() {
    setState(() {
      _result = 'ดวงของผู้ที่เกิดราศี $_selected — วันนี้เหมาะกับการเริ่มต้นสิ่งใหม่\nโฟกัสงานสำคัญช่วงเช้า และให้ความสำคัญกับสุขภาพใจ';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ShellWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _Header(title: 'ดูดวง (Premium)', subtitle: 'เลือกวันเกิดและราศี • โทนเข้มสุดหรู'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _Card(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('เลือกราศี', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 8, runSpacing: 8, children: _zodiacs.map((z) {
                        final picked = _selected == z;
                        return ChoiceChip(
                          label: Text(z),
                          selected: picked,
                          onSelected: (_) => setState(() => _selected = z),
                          selectedColor: softGold,
                          labelStyle: TextStyle(color: picked ? Colors.black : Colors.white70, fontWeight: FontWeight.w800),
                          backgroundColor: const Color(0xFF1B1B24),
                        );
                      }).toList()),
                      const SizedBox(height: 16),
                      const Text('วันเกิด', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 6),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cake_rounded),
                        label: Text('${_dob.year}/${_dob.month.toString().padLeft(2, '0')}/${_dob.day.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1950),
                            lastDate: DateTime(now.year, now.month, now.day),
                            initialDate: _dob,
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: Theme.of(ctx).colorScheme.copyWith(
                                      primary: softGold,
                                      onPrimary: Colors.black,
                                      surface: const Color(0xFF15151E),
                                      onSurface: Colors.white,
                                    ),
                                dialogBackgroundColor: const Color(0xFF15151E),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) setState(() => _dob = picked);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _gen,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text('ดูคำทำนาย'),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  _Card(child: Text(_result, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 👤 PROFILE — โปรไฟล์/การตั้งค่า + ตัวเลือกภาษา
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.currentLang, required this.onChangeLang, required this.isDark, required this.onToggleTheme});
  final String currentLang;
  final void Function(String) onChangeLang;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ShellWidth(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _Header(title: 'โปรไฟล์ & การตั้งค่า', subtitle: 'บัญชี • ภาษา • ธีม • เกี่ยวกับ'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _Card(
                  child: Row(children: [
                    const CircleAvatar(radius: 24, backgroundColor: Color(0xFF1F1B34), child: Icon(Icons.person, color: softGold)),
                    const SizedBox(width: 12),
                    Expanded(child: Text('ผู้ใช้งาน MindVerse Premium', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white))),
                    IconButton(onPressed: onToggleTheme, icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white)),
                  ]),
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Row(children: [
                    const Icon(Icons.translate_rounded, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text('Language', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1B1B24),
                        value: currentLang,
                        items: _supported50Languages
                            .map((e) => DropdownMenuItem(value: e.code, child: Text('${e.flag} ${e.name}', style: const TextStyle(color: Colors.white))))
                            .toList(),
                        onChanged: (v) => v == null ? null : onChangeLang(v),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                const _Card(
                  child: Text(
                    '• รองรับปุ่มเต็มความกว้างทุกหน้า\n• โทนเข้มพรีเมียม + ขอบมน 16px\n• ฟีเจอร์ถามด้วยเสียง (เดโม) — พร้อมต่อปลั๊กอิน STT จริงภายหลัง\n• จำกัดความกว้างเท่าจอมือถือ (~430px) ทุกหน้า',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// 🔧 Components พื้นฐาน
class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF151521), Color(0xFF1F1B34), Color(0xFF0F0F16)]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 22, offset: Offset(0, 10))],
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        const Icon(Icons.auto_awesome_rounded, color: softGold),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15151E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6))],
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}

// 🌍 รายชื่อภาษา ~50 ภาษา (สำหรับ UI เลือกภาษา)
class Lang {
  final String code; final String name; final String flag;
  const Lang(this.code, this.name, this.flag);
}

final List<Lang> _supported50Languages = [
  Lang('en', 'English', '🇺🇸'), Lang('th', 'ไทย', '🇹🇭'), Lang('es', 'Español', '🇪🇸'), Lang('fr', 'Français', '🇫🇷'),
  Lang('de', 'Deutsch', '🇩🇪'), Lang('it', 'Italiano', '🇮🇹'), Lang('pt', 'Português', '🇵🇹'), Lang('ru', 'Русский', '🇷🇺'),
  Lang('zh', '中文', '🇨🇳'), Lang('ja', '日本語', '🇯🇵'), Lang('ko', '한국어', '🇰🇷'), Lang('ar', 'العربية', '🇸🇦'),
  Lang('hi', 'हिन्दी', '🇮🇳'), Lang('id', 'Bahasa', '🇮🇩'), Lang('ms', 'Melayu', '🇲🇾'), Lang('vi', 'Tiếng Việt', '🇻🇳'),
  Lang('tr', 'Türkçe', '🇹🇷'), Lang('fa', 'فارسی', '🇮🇷'), Lang('he', 'עברית', '🇮🇱'), Lang('pl', 'Polski', '🇵🇱'),
  Lang('nl', 'Nederlands', '🇳🇱'), Lang('sv', 'Svenska', '🇸🇪'), Lang('no', 'Norsk', '🇳🇴'), Lang('da', 'Dansk', '🇩🇰'),
  Lang('fi', 'Suomi', '🇫🇮'), Lang('cs', 'Čeština', '🇨🇿'), Lang('sk', 'Slovenčina', '🇸🇰'), Lang('sl', 'Slovenščina', '🇸🇮'),
  Lang('hr', 'Hrvatski', '🇭🇷'), Lang('ro', 'Română', '🇷🇴'), Lang('bg', 'Български', '🇧🇬'), Lang('uk', 'Українська', '🇺🇦'),
  Lang('el', 'Ελληνικά', '🇬🇷'), Lang('hu', 'Magyar', '🇭🇺'), Lang('sr', 'Српски', '🇷🇸'), Lang('et', 'Eesti', '🇪🇪'),
  Lang('lt', 'Lietuvių', '🇱🇹'), Lang('lv', 'Latviešu', '🇱🇻'), Lang('ur', 'اردو', '🇵🇰'), Lang('bn', 'বাংলা', '🇧🇩'),
  Lang('ta', 'தமிழ்', '🇮🇳'), Lang('te', 'తెలుగు', '🇮🇳'), Lang('ml', 'മലയാളം', '🇮🇳'), Lang('mr', 'मराठी', '🇮🇳'),
  Lang('gu', 'ગુજરાતી', '🇮🇳'), Lang('kn', 'ಕನ್ನಡ', '🇮🇳'), Lang('pa', 'ਪੰਜਾਬੀ', '🇮🇳'), Lang('sw', 'Kiswahili', '🇰🇪'),
  Lang('fil', 'Filipino', '🇵🇭'), Lang('a









