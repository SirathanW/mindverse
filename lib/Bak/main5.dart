import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MindVerseApp());
}

class MindVerseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF6B4EFF),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6B4EFF),
          secondary: Color(0xFFFF6B9D),
          surface: Color(0xFF1A1F3A),
          background: Color(0xFF0A0E21),
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    HomeScreen(),
    AuraScanScreen(),
    ChatAIScreen(),
    FortuneScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF1A1F3A),
                  Color(0xFF2D1B69),
                ],
              ),
            ),
          ),
          // Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1F3A), Color(0xFF0A0E21)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6B4EFF).withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _animationController.reset();
              _animationController.forward();
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF6B4EFF),
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28),
              label: 'โฮม',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded, size: 28),
              label: 'Aura Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded, size: 28),
              label: 'AI Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars_rounded, size: 28),
              label: 'ดูดวง',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 28),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// หน้าที่ 1: Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MindVerse',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Color(0xFF6B4EFF), Color(0xFFFF6B9D)],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    Text(
                      'AI อัจฉริยะระดับโลก',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6B4EFF), Color(0xFFFF6B9D)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.notifications_rounded, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Feature Cards
            _buildFeatureCard(
              icon: Icons.camera_alt_rounded,
              title: 'Aura Scanner',
              subtitle: 'สแกนออร่าด้วยกล้องมือถือ',
              gradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
              onTap: () => _navigateToTab(context, 1),
            ),
            _buildFeatureCard(
              icon: Icons.psychology_rounded,
              title: 'AI Assistant',
              subtitle: 'พูดคุยกับ AI อัจฉริยะ',
              gradient: [Color(0xFFFF6B9D), Color(0xFFFECA57)],
              onTap: () => _navigateToTab(context, 2),
              hasAIImage: true,
            ),
            _buildFeatureCard(
              icon: Icons.auto_awesome_rounded,
              title: 'ดูดวง 4 ศาสตร์',
              subtitle: 'ทำนายแม่นยำที่สุดในโลก',
              gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
              onTap: () => _navigateToTab(context, 3),
            ),
            _buildFeatureCard(
              icon: Icons.self_improvement_rounded,
              title: 'ฝึกสมาธิขั้นเทพ',
              subtitle: 'จากเริ่มต้นสู่ขั้นเทพ',
              gradient: [Color(0xFF43E97B), Color(0xFF38F9D7)],
              onTap: () => _showMeditationDialog(context),
            ),
            _buildFeatureCard(
              icon: Icons.account_balance_rounded,
              title: 'สมาธิภาพพระ 3D',
              subtitle: 'ภาพพระ 3 มิติสวยงาม',
              gradient: [Color(0xFFFA709A), Color(0xFFFEE140)],
              onTap: () => _show3DBuddhaDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool hasAIImage = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: hasAIImage
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.face, color: gradient[0], size: 30),
                    )
                  : Icon(icon, color: Colors.white, size: 30),
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
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    if (context.findAncestorStateOfType<_MainScreenState>() != null) {
      context.findAncestorStateOfType<_MainScreenState>()!.setState(() {
        context.findAncestorStateOfType<_MainScreenState>()!._currentIndex = index;
      });
    }
  }

  void _showMeditationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MeditationDialog(),
    );
  }

  void _show3DBuddhaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Buddha3DDialog(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// หน้าที่ 2: Aura Scan Screen
class AuraScanScreen extends StatefulWidget {
  @override
  _AuraScanScreenState createState() => _AuraScanScreenState();
}

class _AuraScanScreenState extends State<AuraScanScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  double _energyLevel = 0.0;
  List<Map<String, dynamic>> _scanHistory = [];
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
    
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
        _energyLevel = (math.Random().nextDouble() * 10);
        _scanHistory.insert(0, {
          'level': _energyLevel,
          'date': DateTime.now(),
        });
      });
    });
  }

  Color _getEnergyColor(double level) {
    if (level < 3) return Colors.red;
    if (level < 6) return Colors.orange;
    if (level < 8) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Aura Scanner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
          ),
          
          // Camera View
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camera Placeholder
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 100,
                        color: Colors.white30,
                      ),
                    ),
                  ),
                  
                  // Scanning Animation
                  if (_isScanning)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  
                  // Scan Button
                  if (!_isScanning)
                    Positioned(
                      bottom: 30,
                      child: ElevatedButton(
                        onPressed: _startScan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'เริ่มสแกน',
                          style: TextStyle(
                            color: Color(0xFF667EEA),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  if (_isScanning)
                    Positioned(
                      bottom: 30,
                      child: Text(
                        'กำลังสแกน...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Energy Level Display
          if (_energyLevel > 0)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'ระดับพลังงาน: ${_energyLevel.toStringAsFixed(1)}/10',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getEnergyColor(_energyLevel),
                    ),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _energyLevel / 10,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(_getEnergyColor(_energyLevel)),
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          
          // History
          if (_scanHistory.isNotEmpty)
            Container(
              height: 100,
              margin: EdgeInsets.all(20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _scanHistory.length,
                itemBuilder: (context, index) {
                  final scan = _scanHistory[index];
                  return Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1F3A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${scan['level'].toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getEnergyColor(scan['level']),
                          ),
                        ),
                        Text(
                          '${scan['date'].hour}:${scan['date'].minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

// หน้าที่ 3: Chat AI Screen
class ChatAIScreen extends StatefulWidget {
  @override
  _ChatAIScreenState createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': DateTime.now(),
      });
      _isTyping = true;
    });
    
    final userMessage = _messageController.text;
    _messageController.clear();
    
    // Simulate AI response
    Timer(Duration(seconds: 2), () {
      setState(() {
        _messages.add({
          'text': 'ขอบคุณสำหรับข้อความของคุณ: "$userMessage" ฉันเป็น AI อัจฉริยะที่พร้อมช่วยเหลือคุณในทุกเรื่อง!',
          'isUser': false,
          'time': DateTime.now(),
        });
        _isTyping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header with AI Avatar
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1F3A), Color(0xFF2D1B69)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'ai-avatar',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFFFECA57)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B9D).withOpacity(0.5),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(Icons.psychology_rounded, color: Colors.white, size: 40),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Online',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.mic_rounded, color: Colors.white, size: 30),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Voice chat activated'),
                        backgroundColor: Color(0xFF6B4EFF),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          
          // Typing Indicator
          if (_isTyping)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1F3A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _buildTypingDot(0),
                        SizedBox(width: 5),
                        _buildTypingDot(1),
                        SizedBox(width: 5),
                        _buildTypingDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Input Field
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1A1F3A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'พิมพ์ข้อความ...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Color(0xFF0A0E21),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6B4EFF), Color(0xFFFF6B9D)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['isUser'];
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFECA57)],
                ),
              ),
              child: Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(
                        colors: [Color(0xFF6B4EFF), Color(0xFF8B5CF6)],
                      )
                    : LinearGradient(
                        colors: [Color(0xFF1A1F3A), Color(0xFF2D3561)],
                      ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message['text'],
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(value),
          ),
        );
      },
    );
  }
}

// หน้าที่ 4: Fortune Screen
class FortuneScreen extends StatefulWidget {
  @override
  _FortuneScreenState createState() => _FortuneScreenState();
}

class _FortuneScreenState extends State<FortuneScreen> {
  bool _showPrediction = false;
  String _selectedZodiac = 'ราศีเมษ';
  
  final List<String> _zodiacs = [
    'ราศีเมษ', 'ราศีพฤษภ', 'ราศีเมถุน', 'ราศีกรกฎ',
    'ราศีสิงห์', 'ราศีกันย์', 'ราศีตุลย์', 'ราศีพิจิก',
    'ราศีธนู', 'ราศีมังกร', 'ราศีกุมภ์', 'ราศีมีน'
  ];

  void _generatePrediction() {
    setState(() {
      _showPrediction = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'ดูดวง 4 ศาสตร์',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'ทำนายแม่นยำที่สุดในโลก',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
            SizedBox(height: 30),
            
            // Zodiac Selector
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1F3A), Color(0xFF2D3561)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เลือกราศีของคุณ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A0E21),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedZodiac,
                      isExpanded: true,
                      dropdownColor: Color(0xFF1A1F3A),
                      style: TextStyle(color: Colors.white),
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedZodiac = newValue!;
                          _showPrediction = false;
                        });
                      },
                      items: _zodiacs.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // 4 Fortune Methods - แก้ไข icon ตรงนี้
            _buildFortuneMethod('โหราศาสตร์ไทย', Icons.stars, Color(0xFFFF6B9D)),
            _buildFortuneMethod('โหราศาสตร์จีน', Icons.brightness_1, Color(0xFFFECA57)), // เปลี่ยนจาก Icons.yin_yang
            _buildFortuneMethod('ไพ่ทาโรต์', Icons.style, Color(0xFF6B4EFF)),
            _buildFortuneMethod('ลายมือ', Icons.back_hand, Color(0xFF43E97B)),
            
            // Generate Button
            Center(
              child: ElevatedButton(
                onPressed: _generatePrediction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'ทำนายดวง',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Prediction Result
            if (_showPrediction)
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ผลการทำนาย $_selectedZodiac',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '💫 การงาน: ช่วงนี้มีโอกาสก้าวหน้าในหน้าที่การงาน จะได้รับการยอมรับจากผู้บังคับบัญชา',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '❤️ ความรัก: คนโสดจะได้พบเจอคนที่ถูกใจ คนมีคู่ความรักหวานชื่น',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '💰 การเงิน: การเงินมั่นคง มีโชคลาภไม่คาดฝัน',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '🏥 สุขภาพ: สุขภาพแข็งแรง แต่ควรระวังการพักผ่อน',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneMethod(String title, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}

// หน้าที่ 5: Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'ไทย';
  String _membershipType = 'Pro';
  
  final List<String> _languages = [
    'ไทย', 'English', '中文', '日本語', 'Español', 'Français',
    'Deutsch', 'Italiano', 'Português', 'Русский', '한국어',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B4EFF), Color(0xFFFF6B9D)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Color(0xFF6B4EFF)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, size: 20, color: Color(0xFF6B4EFF)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'ผู้ใช้งาน MindVerse',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _membershipType == 'Pro' ? 'PRO Member' : 'Basic Member',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Profile Settings
            _buildSettingItem('ชื่อ', 'แก้ไขชื่อของคุณ', Icons.person_outline),
            _buildSettingItem('อีเมล', 'user@mindverse.ai', Icons.email_outlined),
            _buildSettingItem('วันเกิด', 'เพิ่มวันเกิดของคุณ', Icons.cake_outlined),
            _buildSettingItem('เวลาเกิด', 'เพิ่มเวลาเกิด', Icons.access_time),
            
            // Language Selector
            Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.language, color: Color(0xFF6B4EFF)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ภาษา', style: TextStyle(fontSize: 16)),
                        Text(
                          'รองรับ 50+ ภาษาทั่วโลก',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A0E21),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      dropdownColor: Color(0xFF1A1F3A),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      items: _languages.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            _buildSettingItem('รหัสผ่าน', 'เปลี่ยนรหัสผ่าน', Icons.lock_outline),
            
            // Membership
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Upgrade to Pro',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'ปลดล็อกฟีเจอร์ทั้งหมด',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'อัพเกรดเดี๋ยวนี้',
                      style: TextStyle(color: Color(0xFFFFA500), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            // Logout Button
            TextButton(
              onPressed: () {},
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF6B4EFF)),
        title: Text(title, style: TextStyle(fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
        tileColor: Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onTap: () {},
      ),
    );
  }
}

// Meditation Dialog
class MeditationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.self_improvement, color: Colors.white, size: 60),
            SizedBox(height: 20),
            Text(
              'การฝึกสมาธิขั้นเทพ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            _buildLevel('ระดับเริ่มต้น', '5 นาที/วัน', 0.3),
            _buildLevel('ระดับกลาง', '15 นาที/วัน', 0.6),
            _buildLevel('ระดับสูง', '30 นาที/วัน', 0.8),
            _buildLevel('ระดับเทพ', '60+ นาที/วัน', 1.0),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'เริ่มฝึกสมาธิ',
                style: TextStyle(color: Color(0xFF43E97B), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevel(String level, String duration, double progress) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(level, style: TextStyle(color: Colors.white, fontSize: 14)),
              Text(duration, style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white30,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}

// 3D Buddha Dialog
class Buddha3DDialog extends StatefulWidget {
  @override
  _Buddha3DDialogState createState() => _Buddha3DDialogState();
}

class _Buddha3DDialogState extends State<Buddha3DDialog> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ภาพพระ 3D',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.white, Colors.yellow, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: Colors.deepOrange,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'สมาธิกับภาพพระ 3 มิติ',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'ปิด',
                style: TextStyle(color: Color(0xFFFA709A), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
}