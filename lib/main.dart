import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// ====== Proxy URL: คำนวณอัตโนมัติ และรองรับ override ด้วย ?proxy= ======
final String PROXY_BASE_URL = _computeProxyBaseUrl();

String _computeProxyBaseUrl() {
  // Production: ชี้โดเมน proxy จริงของคุณ
  if (kReleaseMode) {
    return 'https://your-proxy.example.com'; // <-- เปลี่ยนเป็นของคุณ
  }
  // Dev on Web: อนุญาต override ผ่าน query string
  if (kIsWeb) {
    final params = Uri.base.queryParameters;
    final fromQuery = params['proxy'];
    if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    // ถ้าไม่ส่ง ?proxy= มา ให้ใช้ host เดียวกับที่เสิร์ฟเว็บ + พอร์ต 8080
    return '${Uri.base.scheme}://${Uri.base.host}:8080';
  }
  // Dev on device/emulator: default ไป 10.0.2.2:8080 (Android) / ปกติก็ใช้ได้บน iOS Simulator
  return 'http://10.0.2.2:8080';
}

/// ====== HTTP Helper (รองรับเว็บ/มือถือ) ======
Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final url = Uri.parse('$PROXY_BASE_URL$path');
  try {
    final resp = await http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(timeout);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return data is Map<String, dynamic> ? data : {'data': data};
    }
    return {'error': 'HTTP ${resp.statusCode}', 'message': resp.body};
  } catch (e) {
    return {'error': 'network_error', 'message': e.toString()};
  }
}

/// ====== Theme (ทอง/ดำ) ======
const _bgTop = Color(0xFF141417);
const _bgBot = Color(0xFF0B0B0F);
const _gold = Color(0xFFFFD27A);
const _goldDeep = Color(0xFFE0A340);
const _goldLight = Color(0xFFFFF0B8);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MindVerseApp());
}

class MindVerseApp extends StatelessWidget {
  const MindVerseApp({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(
      seedColor: _gold,
      brightness: Brightness.dark,
      primary: _gold,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindVerse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cs,
        scaffoldBackgroundColor: _bgBot,
        fontFamily: 'Arial',
      ),
      home: const Root(),
    );
  }
}

/// ====== ตัวช่วยจัดสเกล: 390×844 แต่ responsive ======
class DesignCanvas extends StatelessWidget {
  final Widget child;
  const DesignCanvas({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ถ้าหน้าจอกว้าง เช่น tablet/web → จัดให้อยู่กลาง กว้าง 390 สูงตามสัดส่วน
    if (size.width > 430) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 390, height: 844),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: child,
          ),
        ),
      );
    }
    // มือถือทั่วไป → ใช้เต็มจอ
    return child;
  }
}

/// ====== โครงหลัก + Bottom Tabs ======
class Root extends StatefulWidget {
  const Root({super.key});
  @override
  State<Root> createState() => _RootState();
}

class Profile {
  String name = 'User';
  String email = 'user@example.com';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String language = 'ไทย';
  bool isPro = false;
}

class _RootState extends State<Root> {
  int index = 0;
  final profile = Profile();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onGo: (i) => setState(() => index = i)),
      const AuraScanPage(),
      ChatAIPage(profile: profile),
      HoroscopePage(profile: profile),
      ProfilePage(profile: profile, onSaved: () => setState(() {})),
    ];

    return DesignCanvas(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgBot],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: pages[index]),
          bottomNavigationBar: _GoldNav(
            current: index,
            onTap: (i) => setState(() => index = i),
          ),
        ),
      ),
    );
  }
}

/// ====== Widgets ทอง ๆ ======
Shader _goldShader(Rect r) => const LinearGradient(
      colors: [_gold, _goldLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(r);

class GoldText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  const GoldText(this.text,
      {super.key, this.size = 28, this.weight = FontWeight.w800});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: _goldShader,
      child: Text(text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white,
              fontSize: size,
              fontWeight: weight,
              letterSpacing: 0.4)),
    );
  }
}

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const GoldButton({super.key, required this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: disabled
              ? null
              : const LinearGradient(colors: [_gold, _goldDeep]),
          color: disabled ? const Color(0xFF242428) : null,
          border: Border.all(color: _gold.withOpacity(0.35)),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                      color: _gold.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
        ),
        child: GoldText(text, size: 16, weight: FontWeight.w700),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  const FeatureCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final double cardH = (h > 844) ? 84 : 76; // ระยะพอดีกับ 5 แถวบน 390×844
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: cardH,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
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
                color: Colors.black54, blurRadius: 22, offset: Offset(0, 8))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Container(
                width: cardH - 20,
                height: cardH - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [_gold, _goldDeep]),
                  boxShadow: [
                    BoxShadow(
                        color: _gold.withOpacity(0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Center(child: icon),
              ),
              const SizedBox(width: 18),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: GoldText(title, size: 26))),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== Bottom Nav ======
class _GoldNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;
  const _GoldNav({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
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
          _item(Icons.home_rounded, 'Home', 0),
          _item(Icons.camera_alt_rounded, 'Aura Scan', 1),
          _item(Icons.chat_rounded, 'Chat AI', 2),
          _item(Icons.star_rounded, 'Horoscope', 3),
          _item(Icons.person_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, int i) {
    final sel = i == current;
    return InkWell(
      onTap: () => onTap(i),
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
                gradient: sel
                    ? const LinearGradient(colors: [_gold, _goldDeep])
                    : null,
                border: sel ? null : Border.all(color: Colors.white12),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: _gold.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6))
                      ]
                    : null,
              ),
              child: Icon(icon,
                  color: sel ? Colors.black : Colors.white70, size: 22),
            ),
            const SizedBox(height: 6),
            ShaderMask(
              shaderCallback: _goldShader,
              child: Text(label,
                  style: TextStyle(
                      color: sel ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== หน้าที่ 1: Home ======
class HomePage extends StatelessWidget {
  final void Function(int goTab) onGo;
  const HomePage({super.key, required this.onGo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Center(child: GoldText('MindVerse', size: 40)),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              FeatureCard(
                  icon: const Icon(Icons.camera_alt_rounded,
                      size: 34, color: Colors.black),
                  title: 'Aura Scan',
                  onTap: () => onGo(1)),
              FeatureCard(
                  icon: const Icon(Icons.face_rounded,
                      size: 36, color: Colors.black),
                  title: 'Chat AI',
                  onTap: () => onGo(2)),
              FeatureCard(
                  icon: const Icon(Icons.star_rounded,
                      size: 38, color: Colors.black),
                  title: 'Horoscope',
                  onTap: () => onGo(3)),
              FeatureCard(
                  icon: const Icon(Icons.self_improvement_rounded,
                      size: 38, color: Colors.black),
                  title: 'Meditation',
                  onTap: () {}),
              FeatureCard(
                  icon: const Icon(Icons.bubble_chart_rounded,
                      size: 38, color: Colors.black),
                  title: '3D Meditate',
                  onTap: () {}),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

/// ====== หน้าที่ 2: Aura Scan (เดโม่พลังงาน + ประวัติ) ======
class AuraScanPage extends StatefulWidget {
  const AuraScanPage({super.key});
  @override
  State<AuraScanPage> createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage>
    with TickerProviderStateMixin {
  bool scanning = false;
  double energy = 0;
  late AnimationController spin;
  final List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    spin =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    spin.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => scanning = true);
    await Future.delayed(const Duration(seconds: 2));
    final val = (DateTime.now().millisecond % 1000) / 100.0 % 10; // เดโม่สุ่ม
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
    return Column(children: [
      const SizedBox(height: 10),
      Center(child: GoldText('Aura Scan', size: 34)),
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
        child: Stack(alignment: Alignment.center, children: [
          if (!scanning)
            const Icon(Icons.person_rounded, size: 110, color: Colors.white10),
          if (scanning)
            AnimatedBuilder(
              animation: spin,
              builder: (_, __) => Transform.rotate(
                angle: spin.value * 6.28318,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _gold, width: 2)),
                ),
              ),
            ),
        ]),
      ),
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(children: [
          const GoldText('Energy Level', size: 20, weight: FontWeight.w700),
          const SizedBox(height: 10),
          Container(
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.white10),
            ),
            child: LayoutBuilder(builder: (_, c) {
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
                            fontWeight: FontWeight.bold))),
              ]);
            }),
          ),
          const SizedBox(height: 18),
          GoldButton(
              text: scanning ? 'Scanning...' : 'Start Scan',
              onTap: scanning ? null : _start),
        ]),
      ),
      const SizedBox(height: 10),
      if (history.isNotEmpty)
        SizedBox(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(v.toStringAsFixed(1),
                          style: TextStyle(
                              color: _color(v), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ]),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: history.length > 20 ? 20 : history.length,
          ),
        ),
    ]);
  }
}

/// ====== หน้าที่ 3: Chat AI (เรียก /chat ผ่าน proxy) ======
class ChatAIPage extends StatefulWidget {
  final Profile profile;
  const ChatAIPage({super.key, required this.profile});
  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  final List<Map<String, dynamic>> msgs = [];
  final c = TextEditingController();
  bool sending = false;

  Future<void> _send() async {
    final text = c.text.trim();
    if (text.isEmpty || sending) return;
    setState(() {
      msgs.add({'me': true, 'msg': text, 't': DateTime.now()});
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
            'ขออภัย ระบบชั่วคราวไม่พร้อมให้บริการ')
        .toString();

    setState(() {
      msgs.add({'me': false, 'msg': reply, 't': DateTime.now()});
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Center(child: GoldText('Chat AI', size: 34)),
      const SizedBox(height: 8),
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [_gold, _goldDeep])),
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
                      ? const LinearGradient(colors: [_gold, _goldDeep])
                      : const LinearGradient(
                          colors: [Color(0xFF1A1A1A), Color(0xFF121215)]),
                  boxShadow: me
                      ? [
                          BoxShadow(
                              color: _gold.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6))
                        ]
                      : null,
                ),
                child: Text(m['msg'].toString(),
                    style: TextStyle(
                        color: me ? Colors.black : Colors.white,
                        fontSize: 15.5,
                        height: 1.35)),
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [_gold, _goldDeep])),
            child: IconButton(
                icon: const Icon(Icons.mic_rounded, color: Colors.black),
                onPressed: () {}),
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
                    border: InputBorder.none, hintText: 'พิมพ์ข้อความ...'),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [_gold, _goldDeep]),
              boxShadow: [
                BoxShadow(
                    color: _gold.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.black),
                onPressed: sending ? null : _send),
          ),
        ]),
      ),
    ]);
  }
}

/// ====== หน้าที่ 4: Horoscope (เรียก /horoscope ผ่าน proxy) ======
class HoroscopePage extends StatefulWidget {
  final Profile profile;
  const HoroscopePage({super.key, required this.profile});
  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  String? result;
  bool loading = false;

  Future<void> _gen() async {
    setState(() => loading = true);
    final bd = widget.profile.birthDate;
    final bt = widget.profile.birthTime;
    final resp = await postJson('/horoscope', {
      'name': widget.profile.name,
      'email': widget.profile.email,
      'birthDate': bd?.toIso8601String(),
      'birthTime': bt == null
          ? null
          : '${bt.hour}:${bt.minute.toString().padLeft(2, '0')}',
      'language': widget.profile.language,
    });
    setState(() {
      loading = false;
      result = (resp['text'] ??
              resp['reply'] ??
              resp['message'] ??
              'ไม่มีคำทำนายในตอนนี้')
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const SizedBox(height: 6),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [_gold, _goldDeep])),
          child: const Icon(Icons.auto_awesome_rounded,
              size: 64, color: Colors.black),
        ),
        const SizedBox(height: 14),
        const Text(
          'ใช้วันเดือนปีเกิด/เวลาเกิด เพื่อสรุปคำทำนายเดียวแบบละเอียด (รัก/งาน/สุขภาพ/การเงิน)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 14),
        GoldButton(
            text: loading ? 'Generating...' : 'Generate Horoscope',
            onTap: loading ? null : _gen),
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
                    'คำแนะนำ: ไปที่หน้า Profile กรอกวันเกิด/เวลาเกิด แล้วกด Generate Horoscope เพื่อรับคำทำนายจาก AI (ผ่าน Proxy).',
                style: const TextStyle(color: Colors.white, height: 1.45),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/// ====== หน้าที่ 5: Profile ======
class ProfilePage extends StatefulWidget {
  final Profile profile;
  final VoidCallback onSaved;
  const ProfilePage({super.key, required this.profile, required this.onSaved});
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
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [_gold, _goldDeep])),
            child:
                const Icon(Icons.person_rounded, size: 60, color: Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        _field('Name', name),
        _field('Email', email, email: true),
        const SizedBox(height: 8),
        _pickerRow(
          'Birth Date',
          widget.profile.birthDate == null
              ? 'Not set'
              : '${widget.profile.birthDate!.year}-${widget.profile.birthDate!.month.toString().padLeft(2, '0')}-${widget.profile.birthDate!.day.toString().padLeft(2, '0')}',
          () async {
            final now = DateTime.now();
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: now,
              initialDate: widget.profile.birthDate ?? DateTime(1990, 1, 1),
            );
            if (d != null) setState(() => widget.profile.birthDate = d);
          },
        ),
        _pickerRow(
          'Birth Time',
          time == null
              ? 'Not set'
              : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}',
          () async {
            final t = await showTimePicker(
                context: context,
                initialTime: time ?? const TimeOfDay(hour: 12, minute: 0));
            if (t != null) setState(() => time = widget.profile.birthTime = t);
          },
        ),
        _pickerRow('Language', widget.profile.language, () async {
          final v = await showModalBottomSheet<String>(
            context: context,
            backgroundColor: const Color(0xFF16161A),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            builder: (_) => SizedBox(
              height: 360,
              child: ListView(
                children: [
                  for (final s in const [
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
                    'Nederlands'
                  ])
                    ListTile(
                      title:
                          Text(s, style: const TextStyle(color: Colors.white)),
                      onTap: () => Navigator.pop(context, s),
                    ),
                ],
              ),
            ),
          );
          if (v != null) setState(() => widget.profile.language = v);
        }),
        const SizedBox(height: 12),
        GoldButton(
          text: 'Save Profile',
          onTap: () {
            widget.profile.name =
                name.text.trim().isEmpty ? 'User' : name.text.trim();
            widget.profile.email = email.text.trim();
            widget.onSaved();
            HapticFeedback.mediumImpact();
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Profile saved')));
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2A1C0F), Color(0xFF1B120A)]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _gold.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: _gold, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Upgrade to PRO — premium & yearly subscription',
                    style: TextStyle(color: Colors.white70)),
              ),
              Switch(
                value: widget.profile.isPro,
                activeColor: _gold,
                onChanged: (v) => setState(() => widget.profile.isPro = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController c, {bool email = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: c,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none),
      ),
    );
  }

  Widget _pickerRow(String label, String value, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.edit_calendar_rounded, color: _gold)),
      ]),
    );
  }
}
