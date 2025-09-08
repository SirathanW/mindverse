// main.dart — MindVerse (Gold/Black Luxury UI) + Web-friendly Proxy calls
// ✅ Target: Flutter Web (uses package:http so it works in browser)
// ❗ต้องมี Backend Proxy ของคุณรันไว้ที่ http://127.0.0.1:8080 (endpoints: /chat, /horoscope)
//    และต้องเปิด CORS ในฝั่ง Proxy แล้ว

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// -------------------- Backend Proxy --------------------
const String PROXY_BASE_URL = kIsWeb
    ? 'http://127.0.0.1:8080'
    : 'http://10.0.2.2:8080'; // สำหรับ Android emulator; iOS simulator ใช้ 127.0.0.1 ได้เช่นกัน

Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final uri = Uri.parse('$PROXY_BASE_URL$path');
  try {
    final resp = await http
        .post(uri,
            headers: {
              'Content-Type': 'application/json',
              // ถ้า proxy ต้องการ header เพิ่ม (เช่น x-app-id) ใส่ตรงนี้ได้
            },
            body: jsonEncode(body))
        .timeout(timeout);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return {};
      final decoded = jsonDecode(resp.body);
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    } else {
      return {'error': 'HTTP ${resp.statusCode}', 'message': resp.body};
    }
  } catch (e) {
    return {'error': 'network_error', 'message': e.toString()};
  }
}

// -------------------- App Entry --------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MindVerseApp());
}

class MindVerseApp extends StatelessWidget {
  const MindVerseApp({super.key});
  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD27A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindVerse',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0F),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
          primary: gold,
        ),
      ),
      home: const DeviceFrame390x844(child: RootShell()),
    );
  }
}

// -------------------- Web Device Frame 390×844 --------------------
class DeviceFrame390x844 extends StatelessWidget {
  const DeviceFrame390x844({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child; // มือถือ/จำลองจริงใช้เต็มจอ
    return LayoutBuilder(builder: (context, constraints) {
      const w = 390.0;
      const h = 844.0;
      // center canvas 390x844 ในหน้าจอเว็บ
      return Container(
        color: const Color(0xFF000000),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            width: w,
            height: h,
            child: child,
          ),
        ),
      );
    });
  }
}

// -------------------- Profile --------------------
class AppProfile {
  String name = 'User';
  String email = 'user@example.com';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String language = 'ไทย';
  bool isPro = false;
}

// -------------------- Root + Bottom Tabs --------------------
class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int index = 0;
  final profile = AppProfile();
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onGo: (i) => setState(() => index = i)),
      const AuraScanPage(),
      ChatAIPage(profile: profile),
      HoroscopePage(profile: profile),
      ProfilePage(profile: profile, onChanged: () => setState(() {})),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: GoldNavBar(
        current: index,
        onChanged: (i) => setState(() => index = i),
      ),
    );
  }
}

// -------------------- Shared Gold UI --------------------
const bgTop = Color(0xFF141417);
const bgBottom = Color(0xFF0B0B0F);
const goldLight = Color(0xFFFFF0B8);
const gold = Color(0xFFFFD27A);
const goldDeep = Color(0xFFE0A340);

Shader goldShader(Rect r) => const LinearGradient(
      colors: [gold, goldLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(r);

class GoldText extends StatelessWidget {
  const GoldText(this.text,
      {super.key, this.size = 28, this.weight = FontWeight.w800});
  final String text;
  final double size;
  final FontWeight weight;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: goldShader,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  const GoldButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient:
              disabled ? null : const LinearGradient(colors: [gold, goldDeep]),
          color: disabled ? const Color(0xFF2A2A2F) : null,
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                      color: gold.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
          border: Border.all(color: gold.withOpacity(0.35)),
        ),
        child: GoldText(text, size: 16, weight: FontWeight.w700),
      ),
    );
  }
}

// 3D ball icon (for "3D Meditate")
class SphereIcon extends StatelessWidget {
  const SphereIcon({super.key, this.size = 44});
  final double size;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _SpherePainter());
  }
}

class _SpherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final c = Offset(r, r);
    final body = Paint()
      ..shader = const RadialGradient(
        colors: [goldLight, gold, goldDeep],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, body);

    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(r * 0.6, r * 0.6), r * 0.28, highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------- Framing scaffold --------------------
class GoldScaffold extends StatelessWidget {
  const GoldScaffold({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Center(child: GoldText(title, size: 34)),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// -------------------- Bottom Nav --------------------
class GoldNavBar extends StatelessWidget {
  const GoldNavBar({super.key, required this.current, required this.onChanged});
  final int current;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF16161A), Color(0xFF0E0E12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(icon: Icons.home_rounded, label: 'Home', index: 0),
          _item(icon: Icons.camera_alt_rounded, label: 'Aura Scan', index: 1),
          _item(icon: Icons.chat_rounded, label: 'Chat AI', index: 2),
          _item(icon: Icons.star_rounded, label: 'Horoscope', index: 3),
          _item(icon: Icons.person_rounded, label: 'Profile', index: 4),
        ],
      ),
    );
  }

  Widget _item(
      {required IconData icon, required String label, required int index}) {
    final selected = index == current;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(index);
      },
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected
                    ? const LinearGradient(colors: [gold, goldDeep])
                    : null,
                border: selected ? null : Border.all(color: Colors.white12),
                boxShadow: selected
                    ? [
                        BoxShadow(
                            color: gold.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6))
                      ]
                    : null,
              ),
              child: Icon(icon,
                  color: selected ? Colors.black : Colors.white70, size: 22),
            ),
            const SizedBox(height: 6),
            ShaderMask(
              shaderCallback: (r) => goldShader(r),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// -------------------- Page 1: Home --------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onGo});
  final void Function(int gotoTab) onGo;

  @override
  Widget build(BuildContext context) {
    // ให้ 5 ฟีเจอร์ “เท่ากัน” และพอดีบนเฟรม 390x844
    final itemHeight = 84.0; // สวยกำลังดีใน 390x844
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Center(child: GoldText('MindVerse', size: 40)),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _featureCard(
                    height: itemHeight,
                    icon: Icons.camera_alt_rounded,
                    title: 'Aura Scan',
                    onTap: () => onGo(1),
                  ),
                  _featureCard(
                    height: itemHeight,
                    icon: Icons.face_rounded,
                    title: 'Chat AI',
                    onTap: () => onGo(2),
                  ),
                  _featureCard(
                    height: itemHeight,
                    icon: Icons.star_rounded,
                    title: 'Horoscope',
                    onTap: () => onGo(3),
                  ),
                  _featureCard(
                    height: itemHeight,
                    icon: Icons.self_improvement_rounded,
                    title: 'Meditation',
                    onTap: () {},
                  ),
                  _featureCard(
                    height: itemHeight,
                    customIcon: const SphereIcon(size: 36),
                    title: '3D Meditate',
                    onTap: () {},
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard({
    required double height,
    IconData? icon,
    Widget? customIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    final iconWidget = customIcon ??
        Icon(
          icon,
          size: 28,
          color: Colors.black,
        );
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1B1F), Color(0xFF121215)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: gold.withOpacity(0.35), width: 1.2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black54, blurRadius: 22, offset: Offset(0, 8)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Container(
                width: height - 28,
                height: height - 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                      colors: [gold, goldDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                        color: gold.withOpacity(0.40),
                        blurRadius: 18,
                        offset: const Offset(0, 8)),
                  ],
                ),
                child: Center(child: iconWidget),
              ),
              const SizedBox(width: 18),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          GoldText(title, size: 24, weight: FontWeight.w800))),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Page 2: Aura Scan --------------------
class AuraScanPage extends StatefulWidget {
  const AuraScanPage({super.key});
  @override
  State<AuraScanPage> createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage>
    with TickerProviderStateMixin {
  bool scanning = false;
  double energy = 0.0;
  late AnimationController rotate;
  final List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    rotate =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    rotate.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => scanning = true);
    await Future.delayed(const Duration(seconds: 2));
    final val = (math.Random().nextDouble() * 10);
    setState(() {
      scanning = false;
      energy = val;
      history.insert(0, {'t': DateTime.now(), 'e': val});
    });
    HapticFeedback.lightImpact();
  }

  Color _color(double v) {
    if (v < 3) return Colors.redAccent;
    if (v < 6) return Colors.orangeAccent;
    if (v < 8) return Colors.yellowAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return GoldScaffold(
      title: 'Aura Scan',
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20),
            height: 260,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: gold.withOpacity(0.35)),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 20)
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!scanning)
                  const Icon(Icons.person_rounded,
                      size: 110, color: Colors.white10),
                if (scanning)
                  AnimatedBuilder(
                    animation: rotate,
                    builder: (_, __) => Transform.rotate(
                      angle: rotate.value * 2 * math.pi,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: gold, width: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                const GoldText('Energy Level',
                    size: 20, weight: FontWeight.w700),
                const SizedBox(height: 10),
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: LayoutBuilder(builder: (context, c) {
                    final w = c.maxWidth * (energy / 10);
                    return Stack(children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          gradient: LinearGradient(colors: [
                            _color(energy),
                            _color(energy).withOpacity(0.6)
                          ]),
                        ),
                      ),
                      Center(
                        child: Text(
                          energy > 0
                              ? '${energy.toStringAsFixed(1)} / 10'
                              : '-- / 10',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ]);
                  }),
                ),
                const SizedBox(height: 18),
                GoldButton(
                    text: scanning ? 'Scanning...' : 'Start Scan',
                    onPressed: scanning ? null : _start),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                height: 72,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    final it = history[i];
                    final t = it['t'] as DateTime;
                    final v = (it['e'] as double);
                    return Container(
                      width: 110,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151518),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: gold.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${v.toStringAsFixed(1)}',
                              style: TextStyle(
                                  color: _color(v),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: history.length.clamp(0, 20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -------------------- Page 3: Chat AI (via /chat) --------------------
class ChatAIPage extends StatefulWidget {
  const ChatAIPage({super.key, required this.profile});
  final AppProfile profile;
  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  final List<Map<String, dynamic>> msgs = [];
  final TextEditingController c = TextEditingController();
  bool sending = false;

  Future<void> _send() async {
    final text = c.text.trim();
    if (text.isEmpty) return;
    setState(() {
      msgs.add({'me': true, 't': DateTime.now(), 'msg': text});
      sending = true;
    });
    c.clear();

    final resp = await postJson('/chat', {
      'input': text,
      'meta': {
        'name': widget.profile.name,
        'lang': widget.profile.language,
        'app': 'MindVerse'
      }
    });

    final reply = (resp['reply'] ??
        resp['text'] ??
        resp['data'] ??
        resp['message'] ??
        'ขออภัย ระบบชั่วคราวไม่พร้อมให้บริการ.');
    setState(() {
      msgs.add({'me': false, 't': DateTime.now(), 'msg': reply.toString()});
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoldScaffold(
      title: 'Chat AI',
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Avatar center
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [gold, goldDeep]),
              boxShadow: [
                BoxShadow(
                    color: gold.withOpacity(0.4),
                    blurRadius: 22,
                    offset: const Offset(0, 10))
              ],
            ),
            child: const Icon(Icons.face_retouching_natural_rounded,
                size: 64, color: Colors.black),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                final m = msgs[msgs.length - 1 - i];
                final me = m['me'] as bool;
                return Align(
                  alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: me
                          ? const LinearGradient(colors: [gold, goldDeep])
                          : const LinearGradient(
                              colors: [Color(0xFF1A1A1A), Color(0xFF121215)]),
                      boxShadow: [
                        if (me)
                          BoxShadow(
                              color: gold.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6))
                      ],
                    ),
                    child: Text(
                      m['msg'].toString(),
                      style: TextStyle(
                          color: me ? Colors.black : Colors.white,
                          fontSize: 15.5,
                          height: 1.35),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
            child: Row(
              children: [
                // Mic (ตำแหน่งเดียวกับแถบพิมพ์)
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [gold, goldDeep]),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic_rounded, color: Colors.black),
                    onPressed: () {}, // จะเพิ่ม STT ภายหลัง
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: c,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'พิมพ์ข้อความของคุณ...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [gold, goldDeep]),
                    boxShadow: [
                      BoxShadow(
                          color: gold.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black),
                    onPressed: sending ? null : _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Page 4: Horoscope (via /horoscope) --------------------
class HoroscopePage extends StatefulWidget {
  const HoroscopePage({super.key, required this.profile});
  final AppProfile profile;
  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  String? result;
  bool loading = false;

  Future<void> _generate() async {
    setState(() => loading = true);
    final bd = widget.profile.birthDate;
    final bt = widget.profile.birthTime;
    final payload = {
      'name': widget.profile.name,
      'email': widget.profile.email,
      'birthDate': bd?.toIso8601String(),
      'birthTime': bt == null
          ? null
          : '${bt.hour}:${bt.minute.toString().padLeft(2, '0')}',
      'language': widget.profile.language, // ควรตอบไทยถ้า language=ไทย
    };
    final resp = await postJson('/horoscope', payload);
    setState(() {
      loading = false;
      result = (resp['text'] ??
              resp['reply'] ??
              resp['message'] ??
              'ยังไม่มีคำทำนายในขณะนี้')
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoldScaffold(
      title: 'Horoscope',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [gold, goldDeep]),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  size: 64, color: Colors.black),
            ),
            const SizedBox(height: 14),
            const Text(
              'ใช้ข้อมูลวัน/เวลาเกิดจากโปรไฟล์ สรุปเป็นคำทำนายเดียว แยกหมวดหมู่ (ความรัก/การงาน/สุขภาพ/การเงิน)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            GoldButton(
                text: loading ? 'กำลังสร้าง...' : 'สร้างคำทำนาย',
                onPressed: loading ? null : _generate),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141418),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: gold.withOpacity(0.25)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    result ??
                        'คำแนะนำ: ตั้งค่า Birth Date/Time ใน Profile แล้วกด "สร้างคำทำนาย" ระบบจะเรียก Backend Proxy → Hugging Face แล้วส่งคำตอบกลับมา',
                    style: const TextStyle(color: Colors.white, height: 1.45),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Page 5: Profile --------------------
class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key, required this.profile, required this.onChanged});
  final AppProfile profile;
  final VoidCallback onChanged;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController name;
  late TextEditingController email;
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.profile.name);
    email = TextEditingController(text: widget.profile.email);
    time = widget.profile.birthTime;
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoldScaffold(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [gold, goldDeep]),
              ),
              child: const Icon(Icons.person_rounded,
                  size: 60, color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
          _field(label: 'Name', controller: name),
          _field(
              label: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 8),
          _pickerRow(
            label: 'Birth Date',
            value: widget.profile.birthDate == null
                ? 'Not set'
                : '${widget.profile.birthDate!.year}-${widget.profile.birthDate!.month.toString().padLeft(2, '0')}-${widget.profile.birthDate!.day.toString().padLeft(2, '0')}',
            onTap: () async {
              final now = DateTime.now();
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: now,
                initialDate: widget.profile.birthDate ?? DateTime(1990, 1, 1),
                builder: (ctx, child) =>
                    Theme(data: Theme.of(ctx), child: child!),
              );
              if (d != null) setState(() => widget.profile.birthDate = d);
            },
          ),
          _pickerRow(
            label: 'Birth Time',
            value: time == null
                ? 'Not set'
                : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}',
            onTap: () async {
              final t = await showTimePicker(
                  context: context,
                  initialTime: time ?? const TimeOfDay(hour: 12, minute: 0));
              if (t != null)
                setState(() => time = widget.profile.birthTime = t);
            },
          ),
          _pickerRow(
            label: 'Language',
            value: widget.profile.language,
            onTap: () async {
              final v = await showModalBottomSheet<String>(
                context: context,
                backgroundColor: const Color(0xFF16161A),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                builder: (_) => SizedBox(
                  height: 360,
                  child: ListView(
                    children: [
                      for (final s in _languages)
                        ListTile(
                          title: Text(s,
                              style: const TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context, s),
                        ),
                    ],
                  ),
                ),
              );
              if (v != null) setState(() => widget.profile.language = v);
            },
          ),
          const SizedBox(height: 12),
          GoldButton(
            text: 'Save Profile',
            onPressed: () {
              widget.profile.name =
                  name.text.trim().isEmpty ? 'User' : name.text.trim();
              widget.profile.email = email.text.trim();
              widget.onChanged();
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Profile saved'),
                    behavior: SnackBarBehavior.floating),
              );
            },
          ),
          const SizedBox(height: 20),
          // PRO switch
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF2A1C0F), Color(0xFF1B120A)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: gold.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: gold, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Upgrade to PRO — ปลดล็อกฟีเจอร์พรีเมียมและต่ออายุรายปี',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Switch(
                  value: widget.profile.isPro,
                  activeColor: gold,
                  onChanged: (v) => setState(() => widget.profile.isPro = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _languages = [
    'ไทย',
    'English',
    '中文',
    '日本語',
    'Español',
    'Français',
    'Deutsch',
    'Italiano',
    'Português',
    'Русский',
    'العربية',
    'हिन्दी',
    '한국어',
    'Türkçe',
    'Polski',
    'Nederlands',
  ];

  Widget _field(
      {required String label,
      required TextEditingController controller,
      TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none),
      ),
    );
  }

  Widget _pickerRow(
      {required String label,
      required String value,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.edit_calendar_rounded, color: gold)),
        ],
      ),
    );
  }
}
