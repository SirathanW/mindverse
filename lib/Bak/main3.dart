// ✅ MindVerse main.dart — Premium Dark • 5 Tabs • Ready to Run (no extra packages)
// หน้า: โฮม / Aura Scan / แชต AI / ดูดวง / โปรไฟล์
// - โทนเข้มพรีเมียม + จำกัดความกว้าง ~430px ให้สมส่วนมือถือ
// - Aura (เดโม): ปรับสไลเดอร์, บันทึกประวัติ
// - แชต (เดโม): ส่งข้อความ/บับเบิล
// - ดูดวง (เดโม): คำนวณจากข้อมูลโปรไฟล์เบื้องต้น
// - โปรไฟล์: แก้ไขชื่อ/อีเมล/วัน/เวลาเกิด/ภาษา/แผน, ปุ่มบันทึก

import 'dart:math';
import 'package:flutter/material.dart';

const obsidian = Color(0xFF0B0B10);
const royal    = Color(0xFF6D28D9);
const sapphire = Color(0xFF4338CA);
const tealNeo  = Color(0xFF0EA5A4);
const softGold = Color(0xFFF5D483);

void main() => runApp(const MyApp());

// ----------------------------- Profile model -----------------------------
class AppProfile {
  String name = 'MindVerse User';
  String email = 'you@example.com';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String language = 'th';
  String plan = 'Basic';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.dark;
  final AppProfile profile = AppProfile();

  @override
  Widget build(BuildContext context) {
    final dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: royal, brightness: Brightness.dark),
      scaffoldBackgroundColor: obsidian,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF15151E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white60),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindVerse — AI',
      theme: dark,
      themeMode: _mode,
      home: RootShell(
        profile: profile,
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

// ----------------------------- Layout helper -----------------------------
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

// ----------------------------- Root + BottomNav -----------------------------
class RootShell extends StatefulWidget {
  const RootShell({
    super.key,
    required this.profile,
    required this.isDark,
    required this.onToggleTheme,
  });

  final AppProfile profile;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(profile: widget.profile, isDark: widget.isDark, onToggleTheme: widget.onToggleTheme),
      AuraScanPage(profile: widget.profile),
      ChatAIPage(profile: widget.profile),
      HoroscopePage(profile: widget.profile),
      ProfilePage(profile: widget.profile, onChanged: () => setState(() {})),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF12111A), Color(0xFF1B1730)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, -4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            selectedItemColor: softGold,
            unselectedItemColor: Colors.white70,
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
    );
  }
}

// ----------------------------- Shared small widgets -----------------------------
class _Header extends StatelessWidget {
  const _Header({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(subtitle!, style: const TextStyle(color: Colors.white70)),
      ]
    ]);
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
        color: const Color(0xFF13131B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}

// ----------------------------- Page 1: Home -----------------------------
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.profile,
    required this.isDark,
    required this.onToggleTheme,
  });

  final AppProfile profile;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ShellWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_rounded, color: softGold),
                const SizedBox(width: 10),
                const Text('MindVerse', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const Spacer(),
                IconButton(
                  tooltip: isDark ? 'โหมดสว่าง' : 'โหมดมืด',
                  onPressed: onToggleTheme,
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _Card(
              child: Text(
                'ยินดีต้อนรับสู่ MindVerse — แอพ AI อัจฉริยะระดับโลก โทนเข้มพรีเมียม ดีไซน์คมชัด ใช้งานง่าย',
                style: TextStyle(color: Colors.white70, height: 1.3),
              ),
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.camera_enhance_rounded,
              title: 'สแกนออราแบบเรียลไทม์',
              subtitle: 'ใช้กล้องเช็คพลังงาน 0–10 บันทึกประวัติการพัฒนา',
              colors: const [Color(0xFF1E1A32), royal],
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.forum_rounded,
              title: 'AI เสมือนคนจริง',
              subtitle: 'แชตข้อความ + คุยด้วยเสียง (เดโม)',
              colors: const [Color(0xFF1B2A2A), tealNeo],
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.auto_awesome_rounded,
              title: 'ดูดวง 4 ศาสตร์แม่นยำ',
              subtitle: 'ใช้ข้อมูลวัน/เวลาเกิด วิเคราะห์อย่างละเอียด',
              colors: const [Color(0xFF2A1E2C), sapphire],
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.self_improvement_rounded,
              title: 'คอร์สสมาธิ ตั้งแต่เริ่ม→ขั้นเทพ',
              subtitle: 'แบบฝึก + ประเมินผล/สถิติ',
              colors: const [Color(0xFF152531), Color(0xFF1E2F44)],
            ),
            const SizedBox(height: 10),
            _FeatureCard(
              icon: Icons.view_in_ar_rounded,
              title: 'ฝึกสมาธิด้วยภาพพระ 3 มิติ',
              subtitle: 'ภาพ 3D งดงาม เสริมสมาธิ',
              colors: const [Color(0xFF1E1A2E), Color(0xFF2B1A4A)],
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.flash_on_rounded),
              label: const Text('เริ่มใช้งาน MindVerse'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
      child: Row(
        children: [
          Icon(icon, color: softGold, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white70, height: 1.3, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ----------------------------- Page 2: Aura Scan -----------------------------
class AuraRecord {
  final DateTime at;
  final double energy;
  const AuraRecord(this.at, this.energy);
}

class AuraScanPage extends StatefulWidget {
  const AuraScanPage({super.key, required this.profile});
  final AppProfile profile;

  @override
  State<AuraScanPage> createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage> {
  double _energy = 5;
  final List<AuraRecord> _history = [];

  @override
  Widget build(BuildContext context) {
    final label = _energy < 3
        ? 'พลังงานต่ำ'
        : _energy < 7
            ? 'ปานกลาง'
            : 'พลังงานสูง';

    return SafeArea(
      child: ShellWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _Header(title: 'Aura Scan', subtitle: 'สแกน + แสดงพลังงาน 0–10 + บันทึกประวัติ'),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ระดับพลังงาน: ${_energy.toStringAsFixed(1)}/10 • $label', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _EnergyBar(value: _energy / 10),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _energy = (Random().nextDouble() * 10);
                            });
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('สุ่มค่า (เดโม)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _history.insert(0, AuraRecord(DateTime.now(), _energy));
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกผลสแกนแล้ว')));
                          },
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('บันทึกผล'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: _history.isEmpty
                  ? const Text('ยังไม่มีประวัติ', style: TextStyle(color: Colors.white70))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _history.map((r) {
                        final dt =
                            '${r.at.year}/${r.at.month.toString().padLeft(2, '0')}/${r.at.day.toString().padLeft(2, '0')}  ${r.at.hour.toString().padLeft(2, '0')}:${r.at.minute.toString().padLeft(2, '0')}';
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('พลังงาน: ${r.energy.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(dt, style: const TextStyle(color: Colors.white70)),
                          trailing: SizedBox(width: 100, child: _EnergyBar(value: r.energy / 10, height: 10)),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnergyBar extends StatelessWidget {
  const _EnergyBar({required this.value, this.height = 14});
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Stack(children: [
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: v == 0 ? 0.02 : v,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.redAccent, Colors.amber, Colors.lightGreenAccent]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
            ),
          ),
        ),
      ]),
    );
  }
}

// ----------------------------- Page 3: Chat AI -----------------------------
class ChatAIPage extends StatefulWidget {
  const ChatAIPage({super.key, required this.profile});
  final AppProfile profile;

  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  final List<_Msg> _msgs = <_Msg>[];
  final TextEditingController _c = TextEditingController();
  bool _loading = false;

  Future<void> _send() async {
    final text = _c.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg('user', text));
      _loading = true;
      _c.clear();
    });
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _msgs.add(_Msg('ai', 'นี่คือคำตอบ (เดโม) สำหรับ: "$text"'));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxBubble = (size.width * 0.9).clamp(280.0, 430.0);
    return SafeArea(
      child: ShellWidth(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const _AICenterFace(),
            const SizedBox(height: 8),
            const _GlassTag(text: 'MindVerse Assistant · Text (DEMO)'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _msgs.length + (_loading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_loading && i == _msgs.length) return const _TypingDotsCentered();
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
                    child: Text(m.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, height: 1.35)),
                  );
                  return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: bubble);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  TextField(
                    controller: _c,
                    decoration: const InputDecoration(hintText: 'พิมพ์ข้อความ…'),
                    style: const TextStyle(color: Colors.white),
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => _send(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _send,
                    icon: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded),
                    label: Text(_loading ? 'กำลังส่ง…' : 'ส่งข้อความถึง MindVerse'),
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

class _Msg {
  final String role;
  final String text;
  const _Msg(this.role, this.text);
}

class _AICenterFace extends StatelessWidget {
  const _AICenterFace();

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 156,
        height: 156,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(colors: [softGold, royal, tealNeo, softGold]),
        ),
      ),
      Container(
        width: 146,
        height: 146,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x22000000),
          border: Border.all(color: Colors.white24, width: 1.6),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 8))],
        ),
      ),
      const CircleAvatar(
        radius: 64,
        backgroundColor: Color(0xFF303048),
        child: Icon(Icons.face_retouching_natural_rounded, size: 48, color: Colors.white70),
      ),
    ]);
  }
}

class _GlassTag extends StatelessWidget {
  const _GlassTag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
    );
  }
}

class _TypingDotsCentered extends StatefulWidget {
  const _TypingDotsCentered();

  @override
  State<_TypingDotsCentered> createState() => _TypingDotsCenteredState();
}

class _TypingDotsCenteredState extends State<_TypingDotsCentered> with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedBuilder(
          animation: _ac,
          builder: (_, __) {
            final t = _ac.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final phase = (t + i * .2) % 1.0;
                final s = 6.0 + 4.0 * (phase < .5 ? phase * 2 : (1 - phase) * 2);
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

// ----------------------------- Page 4: Horoscope -----------------------------
class HoroscopePage extends StatelessWidget {
  const HoroscopePage({super.key, required this.profile});
  final AppProfile profile;

  String _calc(AppProfile p, BuildContext ctx) {
    final d = p.birthDate?.day ?? 1;
    final m = p.birthDate?.month ?? 1;
    final h = p.birthTime?.hour ?? 12;
    final total = d + m + h;
    final score = total % 10;
    final s1 = 'โหราศาสตร์สากล: โชคด้านงานเด่น';
    final s2 = 'เลขศาสตร์: ผลรวม = $total บ่งบอกจังหวะที่ดี';
    final s3 = 'ธาตุจักรวาล: ธาตุไฟ • แรงบันดาลใจ';
    final s4 = 'วาสนา: เหมาะกับการตัดสินใจเชิงสร้างสรรค์';
    return 'คะแนนนำโชควันนี้: $score/10\n$s1\n$s2\n$s3\n$s4';
    // ทั้งหมดนี้เป็นเดโม (mock) เพื่อให้รันได้ทันที
  }

  @override
  Widget build(BuildContext context) {
    final info = (profile.birthDate == null || profile.birthTime == null)
        ? 'โปรดกรอกวัน/เวลาเกิดในโปรไฟล์เพื่อความแม่นยำ'
        : 'วันเกิด: ${profile.birthDate!.year}/${profile.birthDate!.month}/${profile.birthDate!.day}  '
          'เวลาเกิด: ${profile.birthTime!.format(context)}';

    return SafeArea(
      child: ShellWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _Header(title: 'ดูดวง (4 ศาสตร์)', subtitle: 'ใช้ข้อมูลโปรไฟล์เพื่อความละเอียดแม่นยำ'),
            const SizedBox(height: 12),
            _Card(child: Text(info, style: const TextStyle(color: Colors.white70))),
            const SizedBox(height: 12),
            _Card(child: Text(_calc(profile, context), style: const TextStyle(fontWeight: FontWeight.w800))),
          ],
        ),
      ),
    );
  }
}

// ----------------------------- Page 5: Profile -----------------------------
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profile, required this.onChanged});
  final AppProfile profile;
  final VoidCallback onChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _plan = 'Basic';
  String _language = 'th';

  @override
  void initState() {
    super.initState();
    _name.text = widget.profile.name;
    _email.text = widget.profile.email;
    _plan = widget.profile.plan;
    _language = widget.profile.language;
  }

  void _save() {
    widget.profile
      ..name = _name.text.trim().isEmpty ? 'MindVerse User' : _name.text.trim()
      ..email = _email.text.trim()
      ..plan = _plan
      ..language = _language;
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกโปรไฟล์แล้ว')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ShellWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _Header(
              title: 'โปรไฟล์ & การตั้งค่า',
              subtitle: 'บัญชี • ภาษา • รหัสผ่าน • ชำระเงิน • อัปเกรด',
            ),
            const SizedBox(height: 12),

            const _Card(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF303048),
                    child: Icon(Icons.person, color: Colors.white70),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'รูปโปรไฟล์: (เดโม) — ถ้าต้องการใช้ไฟล์จริงสามารถปรับเป็น AssetImage ภายหลัง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ชื่อ', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  TextField(controller: _name, decoration: const InputDecoration(hintText: 'ชื่อ-นามสกุล')),
                  const SizedBox(height: 12),
                  const Text('อีเมล', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  TextField(controller: _email, decoration: const InputDecoration(hintText: 'you@example.com')),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('วันเกิด', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cake_rounded),
                    label: Text(
                      widget.profile.birthDate == null
                          ? 'เลือกวันเกิด'
                          : '${widget.profile.birthDate!.year}/${widget.profile.birthDate!.month}/${widget.profile.birthDate!.day}',
                    ),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(now.year, now.month, now.day),
                        initialDate: widget.profile.birthDate ?? DateTime(1990, 1, 1),
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
                      if (picked != null) setState(() => widget.profile.birthDate = picked);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('เวลาเกิด', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.schedule_rounded),
                    label: Text(
                      widget.profile.birthTime == null ? 'เลือกเวลาเกิด' : widget.profile.birthTime!.format(context),
                    ),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: widget.profile.birthTime ?? const TimeOfDay(hour: 12, minute: 0),
                      );
                      if (picked != null) setState(() => widget.profile.birthTime = picked);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: Colors.white70),
                  const SizedBox(width: 10),
                  const Text('ภาษา (รองรับ 50+)', style: TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: const Color(0xFF1B1B24),
                      value: _language,
                      items: _supported50Languages
                          .map((e) => DropdownMenuItem(
                                value: e.code,
                                child: Text('${e.flag} ${e.name}', style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _language = v ?? 'th'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('เปลี่ยนรหัสผ่าน (DEMO)', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  TextField(controller: _password, decoration: const InputDecoration(hintText: 'รหัสผ่านใหม่'), obscureText: true),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('การชำระเงิน & การสมัครสมาชิก (DEMO)', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'Basic',
                          groupValue: _plan,
                          onChanged: (v) => setState(() => _plan = v!),
                          title: const Text('ประหยัด (Basic)'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'Pro',
                          groupValue: _plan,
                          onChanged: (v) => setState(() => _plan = v!),
                          title: const Text('Pro ระดับพรีเมียม'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('รองรับการชำระเงินบัตรเครดิตทั่วโลก (เดโม)', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: const Text('บันทึกการเปลี่ยนแปลง'),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------- Languages (50+) -----------------------------
class LanguageOption {
  final String code;
  final String name;
  final String flag;
  const LanguageOption(this.code, this.name, this.flag);
}

const List<LanguageOption> _supported50Languages = [
  LanguageOption('th', 'ไทย', '🇹🇭'),
  LanguageOption('en', 'English', '🇺🇸'),
  LanguageOption('zh', '中文', '🇨🇳'),
  LanguageOption('ja', '日本語', '🇯🇵'),
  LanguageOption('ko', '한국어', '🇰🇷'),
  LanguageOption('vi', 'Tiếng Việt', '🇻🇳'),
  LanguageOption('id', 'Bahasa Indonesia', '🇮🇩'),
  LanguageOption('ms', 'Bahasa Melayu', '🇲🇾'),
  LanguageOption('hi', 'हिन्दी', '🇮🇳'),
  LanguageOption('bn', 'বাংলা', '🇧🇩'),
  LanguageOption('ur', 'اردو', '🇵🇰'),
  LanguageOption('ar', 'العربية', '🇸🇦'),
  LanguageOption('fa', 'فارسی', '🇮🇷'),
  LanguageOption('tr', 'Türkçe', '🇹🇷'),
  LanguageOption('ru', 'Русский', '🇷🇺'),
  LanguageOption('uk', 'Українська', '🇺🇦'),
  LanguageOption('de', 'Deutsch', '🇩🇪'),
  LanguageOption('fr', 'Français', '🇫🇷'),
  LanguageOption('es', 'Español', '🇪🇸'),
  LanguageOption('pt', 'Português', '🇵🇹'),
  LanguageOption('it', 'Italiano', '🇮🇹'),
  LanguageOption('nl', 'Nederlands', '🇳🇱'),
  LanguageOption('sv', 'Svenska', '🇸🇪'),
  LanguageOption('no', 'Norsk', '🇳🇴'),
  LanguageOption('fi', 'Suomi', '🇫🇮'),
  LanguageOption('da', 'Dansk', '🇩🇰'),
  LanguageOption('pl', 'Polski', '🇵🇱'),
  LanguageOption('cs', 'Čeština', '🇨🇿'),
  LanguageOption('sk', 'Slovenčina', '🇸🇰'),
  LanguageOption('hu', 'Magyar', '🇭🇺'),
  LanguageOption('ro', 'Română', '🇷🇴'),
  LanguageOption('el', 'Ελληνικά', '🇬🇷'),
  LanguageOption('he', 'עברית', '🇮🇱'),
  LanguageOption('bg', 'Български', '🇧🇬'),
  LanguageOption('sr', 'Српски', '🇷🇸'),
  LanguageOption('hr', 'Hrvatski', '🇭🇷'),
  LanguageOption('sl', 'Slovenščina', '🇸🇮'),
  LanguageOption('et', 'Eesti', '🇪🇪'),
  LanguageOption('lv', 'Latviešu', '🇱🇻'),
  LanguageOption('lt', 'Lietuvių', '🇱🇹'),
  LanguageOption('is', 'Íslenska', '🇮🇸'),
  LanguageOption('ga', 'Gaeilge', '🇮🇪'),
  LanguageOption('mt', 'Malti', '🇲🇹'),
  LanguageOption('sw', 'Kiswahili', '🇰🇪'),
  LanguageOption('am', 'አማርኛ', '🇪🇹'),
  LanguageOption('ta', 'தமிழ்', '🇮🇳'),
  LanguageOption('te', 'తెలుగు', '🇮🇳'),
  LanguageOption('ml', 'മലയാളം', '🇮🇳'),
  LanguageOption('mr', 'मराठी', '🇮🇳'),
  LanguageOption('gu', 'ગુજરાતી', '🇮🇳'),
  LanguageOption('km', 'ខ្មែរ', '🇰🇭'),
  LanguageOption('lo', 'ລາວ', '🇱🇦'),
];







