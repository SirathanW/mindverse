import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MindVerseApp(cameras: cameras));
}

class MindVerseApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  
  const MindVerseApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindVerse',
      theme: ThemeData(
        primaryColor: const Color(0xFF0A0A0A),
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFFFD700),
          unselectedItemColor: Color(0xFF666666),
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
        ),
      ),
      home: MainScreen(cameras: cameras),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const MainScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      AuraScanScreen(cameras: widget.cameras),
      const AIChatScreen(),
      const HoroscopeScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFFFD700),
          unselectedItemColor: const Color(0xFF666666),
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              label: 'โฮม',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility_rounded, size: 24),
              label: 'Aura Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded, size: 24),
              label: 'แชท AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars_rounded, size: 24),
              label: 'ดูดวง',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 24),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }
}

// หน้า Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.psychology, color: Colors.black),
            ),
            SizedBox(width: 10),
            Text('MindVerse', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยินดีต้อนรับสู่ MindVerse',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'แอปพลิเคชัน AI อัจฉริยะระดับโลกที่ดีที่สุด',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Features Grid
              Text(
                'ฟีเจอร์หลัก',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Feature Cards
              _buildFeatureCard(
                context,
                'Aura Scanner',
                'ตรวจสอบพลังงานด้วยกล้อง',
                Icons.camera_alt_rounded,
                Color(0xFF6A4C93),
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuraScanScreen(cameras: []))),
              ),
              SizedBox(height: 15),

              _buildFeatureCard(
                context,
                'AI Assistant',
                'ปรึกษา AI ที่ฉลาดที่สุด',
                Icons.smart_toy_rounded,
                Color(0xFF00B4D8),
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => AIChatScreen())),
              ),
              SizedBox(height: 15),

              _buildFeatureCard(
                context,
                'ดูดวงแม่นยำ',
                'ทำนายด้วย 4 ศาสตร์ระดับโลก',
                Icons.stars_rounded,
                Color(0xFFFF6B6B),
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => HoroscopeScreen())),
              ),
              SizedBox(height: 15),

              _buildFeatureCard(
                context,
                'ฝึกสมาธิ',
                'สอนสมาธิตั้งแต่เริ่มต้นถึงขั้นเทพ',
                Icons.self_improvement_rounded,
                Color(0xFF4ECDC4),
                () => _showMeditationDialog(context),
              ),
              SizedBox(height: 15),

              _buildFeatureCard(
                context,
                'พระ 3D',
                'ฝึกสมาธิด้วยภาพพระสวยงาม',
                Icons.temple_buddhist_rounded,
                Color(0xFFFFD700),
                () => _showBuddha3DDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showMeditationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        title: Text('การฝึกสมาธิ', style: TextStyle(color: Colors.white)),
        content: Text(
          'ระบบสอนการฝึกสมาธิตั้งแต่ขั้นเริ่มต้นไปจนถึงขั้นเทพ พร้อมประเมินผลและเก็บสถิติ',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด', style: TextStyle(color: Color(0xFFFFD700))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // เปิดหน้าฝึกสมาธิ
            },
            child: Text('เริ่มฝึก', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }

  void _showBuddha3DDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        title: Text('พระ 3D', style: TextStyle(color: Colors.white)),
        content: Text(
          'ฝึกสมาธิด้วยภาพพระ 3 มิติที่สวยงามที่สุด เพื่อช่วยในการทำสมาธิ',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด', style: TextStyle(color: Color(0xFFFFD700))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // เปิดหน้าพระ 3D
            },
            child: Text('เริ่มดู', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }
}

// หน้า Aura Scan Screen
class AuraScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AuraScanScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<AuraScanScreen> createState() => _AuraScanScreenState();
}

class _AuraScanScreenState extends State<AuraScanScreen> {
  CameraController? _cameraController;
  bool _isScanning = false;
  double _energyLevel = 0.0;
  List<AuraReading> _auraHistory = [];

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    await _cameraController?.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _energyLevel = 0.0;
    });

    // จำลองการสแกน
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _energyLevel = (7.0 + (DateTime.now().millisecond % 3)) / 10.0;
          _auraHistory.insert(0, AuraReading(
            level: _energyLevel,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aura Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => _showHistory(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF2A2A2A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Camera Preview
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isScanning ? Color(0xFFFFD700) : Colors.white30,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: _cameraController?.value.isInitialized == true
                      ? CameraPreview(_cameraController!)
                      : Container(
                          color: Color(0xFF1A1A1A),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 80, color: Colors.white30),
                                SizedBox(height: 20),
                                Text('กำลังเตรียมกล้อง...', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // Energy Level Display
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'ระดับพลังงาน',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${(_energyLevel * 10).toInt()}/10',
                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    // Energy Bar
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _energyLevel,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getEnergyColor(_energyLevel),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scan Button
            Container(
              margin: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _isScanning ? null : _startScan,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isScanning 
                          ? [Colors.grey, Colors.grey.shade700]
                          : [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (_isScanning ? Colors.grey : Color(0xFFFFD700)).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isScanning
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 15),
                              Text('กำลังสแกน...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          )
                        : Text('เริ่มสแกน Aura', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEnergyColor(double level) {
    if (level < 0.3) return Colors.red;
    if (level < 0.6) return Colors.orange;
    if (level < 0.8) return Colors.yellow;
    return Colors.green;
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ประวัติการสแกน',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _auraHistory.isEmpty
                  ? Center(child: Text('ยังไม่มีประวัติการสแกน', style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: _auraHistory.length,
                      itemBuilder: (context, index) {
                        final reading = _auraHistory[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getEnergyColor(reading.level),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ระดับ ${(reading.level * 10).toInt()}/10',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${reading.timestamp.day}/${reading.timestamp.month}/${reading.timestamp.year} ${reading.timestamp.hour}:${reading.timestamp.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuraReading {
  final double level;
  final DateTime timestamp;

  AuraReading({required this.level, required this.timestamp});
}

// หน้า AI Chat Screen
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _isListening = false;
  SpeechToText _speechToText = SpeechToText();
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _initializeTts();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("th-TH");
    await _flutterTts.setPitch(1.0);
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "สวัสดีค่ะ! ฉันคือ AI Assistant ของ MindVerse พร้อมให้คำปรึกษาและตอบคำถามทุกเรื่องค่ะ มีอะไรให้ช่วยไหมคะ?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // จำลองการตอบกลับของ AI
    Future.delayed(Duration(milliseconds: 1000), () {
      String aiResponse = _generateAIResponse(text);
      setState(() {
        _messages.add(ChatMessage(
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
      _speak(aiResponse);
    });
  }

  String _generateAIResponse(String userMessage) {
    // จำลองการตอบกลับอัจฉริยะ
    if (userMessage.toLowerCase().contains('สวัสดี')) {
      return "สวัสดีค่ะ! ยินดีที่ได้พูดคุยกับคุณนะคะ วันนี้เป็นอย่างไรบ้างคะ?";
    } else if (userMessage.toLowerCase().contains('ดูดวง')) {
      return "เรื่องดูดวงเป็นสิ่งที่น่าสนใจมากเลยค่ะ! คุณสามารถไปที่หน้า 'ดูดวง' เพื่อดูการทำนายแบบละเอียดด้วย 4 ศาสตร์ที่แม่นยำที่สุดได้เลยค่ะ";
    } else if (userMessage.toLowerCase().contains('สมาธิ')) {
      return "การฝึกสมาธิเป็นสิ่งดีมากค่ะ! MindVerse มีระบบสอนการฝึกสมาธิตั้งแต่ขั้นเริ่มต้นไปจนถึงขั้นเทพ พร้อมประเมินผลและเก็บสthิติให้ด้วยค่ะ";
    } else {
      return "ขอบคุณที่แบ่งปันค่ะ ฉันเข้าใจในสิ่งที่คุณพูด และพร้อมที่จะช่วยเหลือคุณในทุกเรื่องค่ะ มีอะไรอื่นที่อยากปรึกษาอีกไหมคะ?";
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
          });
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
      );
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {