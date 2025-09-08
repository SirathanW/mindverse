// main.dart — MindVerse (Gold/Black Luxury UI) + HF via Backend Proxy
// Flutter SDK only (no extra packages). Ready to run.
// Replace PROXY_BASE_URL with your backend proxy URL (do not put HF token here).

import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse, Platform;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// -------------------- Backend Proxy --------------------
const String PROXY_BASE_URL = kReleaseMode
    // ใส่ URL โปรดักชันของคุณที่นี่ เช่น https://api.mindverse.app
    ? 'https://your-proxy.example.com'
    // ดีฟอลต์สำหรับ emulator: Android = 10.0.2.2, iOS = localhost
    : (kIsWeb
        ? 'http://localhost:8787'
        : (Platform.isAndroid ? 'http://10.0.2.2:8787' : 'http://localhost:8787'));

Future<Map<String, dynamic>> _postJson(String path, Map<String, dynamic> body,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final url = Uri.parse('$PROXY_BASE_URL$path');
  final client = HttpClient()..connectionTimeout = timeout;
  try {
    final HttpClientRequest req = await client.postUrl(url);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.add(utf8.encode(jsonEncode(body)));
    final HttpClientResponse resp = await req.close();
    final String text = await utf8.decodeStream(resp);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final dynamic data = jsonDecode(text);
      return data is Map<String, dynamic> ? data : {'data': data};
    }
    return {
      'error': 'HTTP ${resp.statusCode}',
      'message': text,
    };
  } catch (e) {
    return {'error': 'network_error', 'message': e.toString()};
  } finally {
    client.close(force: true);
  }
}

// -------------------- App Entry --------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MindVerseApp());
}

class MindVerseApp extends StatelessWidget {
  const MindVerseApp({super.key});
  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFFFD27A);
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
      home: const _Root(),
    );
  }
}

// -------------------- Root with Bottom Tabs --------------------
class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class AppProfile {
  String name = 'User';
  String email = 'user@example.com';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String language = 'English';
  bool isPro = false;
}

class _RootState extends State<_Root> {
  int idx = 0;
  final AppProfile profile = AppProfile();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onGo: (i) => setState(() => idx = i)),
      AuraScanPage(),
      ChatAIPage(profile: profile),
      HoroscopePage(profile: profile),
      ProfilePage(profile: profile, onChanged: () => setState(() {})),
    ];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: _GoldNavBar(
        current: idx,
        onChanged: (i) => setState(() => idx = i),
      ),
    );
  }
}

// -------------------- Shared Gold UI Helpers --------------------
const _bgDarkTop = Color(0xFF141417);
const _bgDarkBottom = Color(0xFF0B0B0F);
const _goldLight = Color(0xFFFFF0B8);
const _gold = Color(0xFFFFD27A);
const _goldDeep = Color(0xFFE0A340);

Shader _goldShader(Rect r) => const LinearGradient(
      colors: [_gold, _goldLight],
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
      shaderCallback: _goldShader,
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

class _CardGoldButton extends StatelessWidget {
  const _CardGoldButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // ให้พอดีจอ 390x844: แต่ responsive
    final h = MediaQuery.of(context).size.height;
    final height = math.max(78, (h - 220) / 5.6); // 5 ปุ่ม + header + margin

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1B1F), Color(0xFF121215)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: _gold.withOpacity(0.35), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 22,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              // 3D Icon container
              Container(
                width: height - 28,
                height: height - 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [_gold, _goldDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _gold.withOpacity(0.40),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GoldText(title, size: 30, weight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3D “crystal ball” painter for 3D Meditate
class _SphereIcon extends StatelessWidget {
  const _SphereIcon({this.size = 44});
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
    final sphere = Paint()
      ..shader = const RadialGradient(
        colors: [_goldLight, _gold, _goldDeep],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, sphere);

    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(r * 0.6, r * 0.6), r * 0.28, highlight);

    // base
    final baseRect = Rect.fromLTWH(r * 0.35, r * 1.55, r * 1.3, r * 0.7);
    final base = Paint()
      ..shader = const LinearGradient(
        colors: [_gold, _goldDeep],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(baseRect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(baseRect, Radius.circular(r * 0.2)), base);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------- Pages --------------------

// 1) Home — exactly like reference image
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onGo});
  final void Function(int gotoTab) onGo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [_bgDarkTop, _bgDarkBottom], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
                physics: const BouncingScrollPhysics(),
                children: [
                  _CardGoldButton(
                    icon: const Icon(Icons.camera_alt_rounded, size: 36, color: Colors.black),
                    title: 'Aura Scan',
                    onTap: () => onGo(1),
                  ),
                  _CardGoldButton(
                    icon: const Icon(Icons.face_rounded, size: 36, color: Colors.black),
                    title: 'Chat AI',
                    onTap: () => onGo(2),
                  ),
                  _CardGoldButton(
                    icon: const Icon(Icons.star_rounded, size: 40, color: Colors.black),
                    title: 'Horoscope',
                    onTap: () => onGo(3),
                  ),
                  _CardGoldButton(
                    icon: const Icon(Icons.self_improvement_rounded, size: 40, color: Colors.black),
                    title: 'Meditation',
                    onTap: () {}, // เปิดหน้าเสริมได้ภายหลัง
                  ),
                  _CardGoldButton(
                    icon: const _SphereIcon(size: 44),
                    title: '3D Meditate',
                    onTap: () {}, // หน้า 3D เพิ่มเติม
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2) Aura Scan — realtime placeholder + energy bar + history
class AuraScanPage extends StatefulWidget {
  const AuraScanPage({super.key});
  @override
  State<AuraScanPage> createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage> with TickerProviderStateMixin {
  bool scanning = false;
  double energy = 0.0;
  late AnimationController rotate;
  final List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    rotate = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    rotate.dispose();
    super.dispose();
  }

  void _start() async {
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
    return _GoldScaffold(
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
              border: Border.all(color: _gold.withOpacity(0.35)),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!scanning)
                  Icon(Icons.person_rounded, size: 110, color: Colors.white10),
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
                          border: Border.all(color: _gold, width: 2),
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
                const GoldText('Energy Level', size: 20, weight: FontWeight.w700),
                const SizedBox(height: 10),
                Container(
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth * (energy / 10);
                      return Stack(children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(colors: [_color(energy), _color(energy).withOpacity(0.6)]),
                          ),
                        ),
                        Center(
                          child: Text(
                            energy > 0 ? '${energy.toStringAsFixed(1)} / 10' : '-- / 10',
                            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                        )
                      ]);
                    },
                  ),
                ),
                const SizedBox(height: 18),
                _GoldButton(text: scanning ? 'Scanning...' : 'Start Scan', onPressed: scanning ? null : _start),
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
                        border: Border.all(color: _gold.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${v.toStringAsFixed(1)}', style: TextStyle(color: _color(v), fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.white54, fontSize: 12)),
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

// 3) Chat AI — HF via Proxy
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

    final resp = await _postJson('/chat', {
      'input': text,
      'meta': {'name': widget.profile.name, 'lang': widget.profile.language, 'app': 'MindVerse'}
    });

    final reply = (resp['reply'] ??
        resp['data'] ??
        resp['message'] ??
        'Sorry, the AI service is temporarily unavailable.');
    setState(() {
      msgs.add({'me': false, 't': DateTime.now(), 'msg': '$reply'});
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _GoldScaffold(
      title: 'Chat AI',
      centerAvatar: true,
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
              gradient: const LinearGradient(colors: [_gold, _goldDeep]),
              boxShadow: [
                BoxShadow(color: _gold.withOpacity(0.4), blurRadius: 22, offset: const Offset(0, 10)),
              ],
            ),
            child: const Icon(Icons.face_retouching_natural_rounded, size: 64, color: Colors.black),
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
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: me
                          ? const LinearGradient(colors: [_gold, _goldDeep])
                          : const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF121215)]),
                      boxShadow: [
                        if (me) BoxShadow(color: _gold.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Text(
                      m['msg'].toString(),
                      style: TextStyle(color: me ? Colors.black : Colors.white, fontSize: 15.5, height: 1.35),
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
                // Mic mock (ตำแหน่งเดียวกับ input bar)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [_gold, _goldDeep]),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic_rounded, color: Colors.black),
                    onPressed: () {}, // เพิ่ม STT ภายหลัง
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
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Type your message...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [_gold, _goldDeep]),
                    boxShadow: [BoxShadow(color: _gold.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
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

// 4) Horoscope — single consolidated prediction via Proxy using profile DOB
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
    setState(() {
      loading = true;
    });
    final bd = widget.profile.birthDate;
    final bt = widget.profile.birthTime;
    final payload = {
      'name': widget.profile.name,
      'email': widget.profile.email,
      'birthDate': bd?.toIso8601String(),
      'birthTime': bt == null ? null : '${bt.hour}:${bt.minute.toString().padLeft(2, '0')}',
      'language': widget.profile.language,
    };
    final resp = await _postJson('/horoscope', payload);
    setState(() {
      loading = false;
      result = (resp['text'] ?? resp['reply'] ?? resp['message'] ?? 'No prediction available at the moment.').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _GoldScaffold(
      title: 'Horoscope',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [_gold, _goldDeep]),
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 64, color: Colors.black),
            ),
            const SizedBox(height: 14),
            const Text(
              'Get a detailed reading using your profile birth data.\n(4 sciences → one consolidated prediction)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            _GoldButton(text: loading ? 'Generating...' : 'Generate Horoscope', onPressed: loading ? null : _generate),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141418),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _gold.withOpacity(0.25)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    result ??
                        'Tip: set your birth date/time in Profile, then tap "Generate Horoscope". The backend proxy will call Hugging Face and return a single, structured reading (love/career/health/wealth).',
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

// 5) Profile — edit & store in memory
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profile, required this.onChanged});
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
    return _GoldScaffold(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [_gold, _goldDeep]),
              ),
              child: const Icon(Icons.person_rounded, size: 60, color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
          _field(label: 'Name', controller: name),
          _field(label: 'Email', controller: email, keyboardType: TextInputType.emailAddress),
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
                builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
              );
              if (d != null) setState(() => widget.profile.birthDate = d);
            },
          ),
          _pickerRow(
            label: 'Birth Time',
            value: time == null ? 'Not set' : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}',
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: time ?? const TimeOfDay(hour: 12, minute: 0));
              if (t != null) setState(() => time = widget.profile.birthTime = t);
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (_) => SizedBox(
                  height: 360,
                  child: ListView(
                    children: [
                      for (final s in _languages)
                        ListTile(
                          title: Text(s, style: const TextStyle(color: Colors.white)),
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
          _GoldButton(
            text: 'Save Profile',
            onPressed: () {
              widget.profile.name = name.text.trim().isEmpty ? 'User' : name.text.trim();
              widget.profile.email = email.text.trim();
              widget.onChanged();
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          const SizedBox(height: 20),
          // บัตรโปร
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2A1C0F), Color(0xFF1B120A)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _gold.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: _gold, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                    child: Text('Upgrade to PRO — unlock premium features and yearly subscription.',
                        style: TextStyle(color: Colors.white70))),
                Switch(
                  value: widget.profile.isPro,
                  activeColor: _gold,
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
    'English', 'ไทย', '中文', '日本語', 'Español', 'Français', 'Deutsch', 'Italiano', 'Português', 'Русский',
    'العربية', 'हिन्दी', '한국어', 'Türkçe', 'Polski', 'Nederlands'
  ];

  Widget _field({required String label, required TextEditingController controller, TextInputType? keyboardType}) {
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
        decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white54), border: InputBorder.none),
      ),
    );
  }

  Widget _pickerRow({required String label, required String value, required VoidCallback onTap}) {
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
          IconButton(onPressed: onTap, icon: const Icon(Icons.edit_calendar_rounded, color: _gold)),
        ],
      ),
    );
  }
}

// -------------------- Framing Scaffold --------------------
class _GoldScaffold extends StatelessWidget {
  const _GoldScaffold({required this.title, required this.child, this.centerAvatar = false});
  final String title;
  final Widget child;
  final bool centerAvatar;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [_bgDarkTop, _bgDarkBottom], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
class _GoldNavBar extends StatelessWidget {
  const _GoldNavBar({required this.current, required this.onChanged});
  final int current;
  final void Function(int) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF16161A), Color(0xFF0E0E12)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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

  Widget _item({required IconData icon, required String label, required int index}) {
    final bool selected = index == current;
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
                gradient: selected ? const LinearGradient(colors: [_gold, _goldDeep]) : null,
                border: selected ? null : Border.all(color: Colors.white12),
                boxShadow: selected ? [BoxShadow(color: _gold.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))] : null,
              ),
              child: Icon(icon, color: selected ? Colors.black : Colors.white70, size: 22),
            ),
            const SizedBox(height: 6),
            ShaderMask(
              shaderCallback: (r) => _goldShader(r),
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

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return GestureDetector(
      onTap: disabled ? null : () => onPressed!(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: disabled ? null : const LinearGradient(colors: [_gold, _goldDeep]),
          color: disabled ? const Color(0xFF2A2A2F) : null,
          boxShadow: disabled ? null : [BoxShadow(color: _gold.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))],
          border: Border.all(color: _gold.withOpacity(0.35)),
        ),
        child: GoldText(text, size: 16, weight: FontWeight.w700),
      ),
    );
  }
}
