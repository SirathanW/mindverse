import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
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
        primaryColor: Color(0xFF1a1a2e),
        scaffoldBackgroundColor: Color(0xFF0f0f1e),
        fontFamily: 'SF Pro Display',
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    AuraScanPage(),
    AIChatPage(),
    FortunePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2a2a3e), Color(0xFF1a1a2e)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.camera_enhance), label: 'Aura Scan'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'AI Chat'),
            BottomNavigationBarItem(icon: Text("☯", style: TextStyle(fontSize: 22, color: Colors.white)), label: 'Fortune'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// หน้าที่ 1: Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16162a), Color(0xFF0f0f1e)],
          ),
        ),
        child: SafeArea(
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
                                colors: [Colors.purpleAccent, Colors.cyanAccent],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        Text(
                          'AI Intelligence Beyond Limits',
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                        ),
                      ),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                
                // Feature 1: Aura Scan
                _buildFeatureCard(
                  context,
                  title: 'Aura Scanner',
                  subtitle: 'Real-time Energy Analysis',
                  icon: Icons.camera_enhance,
                  gradient: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AuraScanPage())),
                ),
                
                // Feature 2: AI Chat
                _buildFeatureCard(
                  context,
                  title: 'AI Assistant',
                  subtitle: 'Ultra-Intelligent Conversation',
                  icon: Icons.psychology,
                  gradient: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AIChatPage())),
                ),
                
                // Feature 3: Fortune Telling
                _buildFeatureCard(
                  context,
                  title: 'Fortune Master',
                  subtitle: '4 Sacred Sciences Prediction',
                  icon: Icons.auto_awesome,
                  gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FortunePage())),
                ),
                
                // Feature 4: Meditation Training
                _buildFeatureCard(
                  context,
                  title: 'Meditation Journey',
                  subtitle: 'From Beginner to Divine',
                  icon: Icons.self_improvement,
                  gradient: [Color(0xFF10B981), Color(0xFF059669)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MeditationPage())),
                ),
                
                // Feature 5: 3D Buddha Meditation
                _buildFeatureCard(
                  context,
                  title: '3D Sacred Meditation',
                  subtitle: 'Divine Visualization Practice',
                  icon: Icons.view_in_ar,
                  gradient: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Buddha3DPage())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient.map((c) => c.withOpacity(0.9)).toList(),
            ),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.4),
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

// หน้าที่ 2: Aura Scan Page
class AuraScanPage extends StatefulWidget {
  @override
  _AuraScanPageState createState() => _AuraScanPageState();
}

class _AuraScanPageState extends State<AuraScanPage> with TickerProviderStateMixin {
  double _energyLevel = 0;
  bool _isScanning = false;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  List<Map<String, dynamic>> _scanHistory = [];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _startScan() {
    setState(() {
      _isScanning = true;
    });
    
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
        _energyLevel = math.Random().nextDouble() * 10;
        _scanHistory.add({
          'date': DateTime.now(),
          'level': _energyLevel,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Aura Scanner'),
        backgroundColor: Color(0xFF1a1a2e),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Camera View Area
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _isScanning ? Colors.purpleAccent : Colors.grey[700]!,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(_isScanning ? 0.5 : 0.2),
                        blurRadius: 30,
                        spreadRadius: _isScanning ? 10 : 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera Placeholder
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      
                      // Scanning Animation
                      if (_isScanning)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _animationController.value * 2 * math.pi,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.purpleAccent.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      
                      // Pulse Effect
                      if (_isScanning)
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 150 + (_pulseController.value * 50),
                              height: 150 + (_pulseController.value * 50),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purpleAccent.withOpacity(0.1),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              
              // Energy Level Display
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      'Energy Level',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[800],
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.8 * (_energyLevel / 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                _getEnergyColor(_energyLevel),
                                _getEnergyColor(_energyLevel).withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      _energyLevel > 0 ? '${_energyLevel.toStringAsFixed(1)} / 10' : '-- / 10',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getEnergyColor(_energyLevel),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scan Button
              Container(
                margin: EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _startScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_enhance, size: 30),
                      SizedBox(width: 10),
                      Text(
                        _isScanning ? 'Scanning...' : 'Start Scan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              // History
              if (_scanHistory.isNotEmpty)
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Scans',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _scanHistory.length,
                          itemBuilder: (context, index) {
                            final scan = _scanHistory[_scanHistory.length - 1 - index];
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${scan['level'].toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: _getEnergyColor(scan['level']),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${scan['date'].hour}:${scan['date'].minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }
}

// หน้าที่ 3: AI Chat Page
class AIChatPage extends StatefulWidget {
  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  
  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    
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
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _messages.add({
          'text': 'I understand your question about "$userMessage". Let me help you with that...',
          'isUser': false,
          'time': DateTime.now(),
        });
        _isTyping = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        backgroundColor: Color(0xFF1a1a2e),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: Column(
          children: [
            // AI Avatar
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.purpleAccent, Colors.blueAccent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_isTyping)
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Typing...',
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        gradient: message['isUser']
                            ? LinearGradient(colors: [Colors.purpleAccent, Colors.deepPurpleAccent])
                            : LinearGradient(colors: [Colors.grey[800]!, Colors.grey[700]!]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['text'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${message['time'].hour}:${message['time'].minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Input Area
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2a2a3e),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Voice Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.orangeAccent],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 10),
                  
                  // Text Input
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  
                  // Send Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.purpleAccent, Colors.blueAccent],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
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

// หน้าที่ 4: Fortune Page
class FortunePage extends StatelessWidget {
  final List<Map<String, dynamic>> _fortuneSciences = [
    {
      'title': 'Western Astrology',
      'icon': Icons.star_purple500_sharp,
      'color': Colors.purpleAccent,
      'description': 'Planetary positions and zodiac analysis',
    },
//    {
//      'title': 'Chinese Astrology',
//      'icon': Icons.yin_yang,
//      'color': Colors.redAccent,
//      'description': 'Five elements and animal signs',
//    },
    {
      'title': 'Numerology',
      'icon': Icons.looks_one,
      'color': Colors.blueAccent,
      'description': 'Life path and destiny numbers',
    },
    {
      'title': 'Tarot Reading',
      'icon': Icons.style,
      'color': Colors.orangeAccent,
      'description': 'Sacred cards divination',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fortune Master'),
        backgroundColor: Color(0xFF1a1a2e),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Your Fortune Analysis',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Based on 4 Sacred Sciences',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                
                // Fortune Sciences
                Text(
                  'Fortune Sciences',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                
                ...List.generate(_fortuneSciences.length, (index) {
                  final science = _fortuneSciences[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FortuneDetailPage(science: science),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[900],
                          border: Border.all(
                            color: science['color'].withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: science['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                science['icon'],
                                size: 30,
                                color: science['color'],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    science['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    science['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                // Today's Fortune
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2a2a3e), Color(0xFF3a3a4e)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Fortune",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFortuneIndicator('Love', 85, Colors.pinkAccent),
                          _buildFortuneIndicator('Career', 72, Colors.blueAccent),
                          _buildFortuneIndicator('Health', 90, Colors.greenAccent),
                          _buildFortuneIndicator('Wealth', 68, Colors.orangeAccent),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFortuneIndicator(String label, int percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 5,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// หน้าที่ 5: Profile Page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedLanguage = 'English';
  bool _isPro = false;
  
  final List<String> _languages = [
    'English', 'ไทย', '中文', '日本語', 'Español', 'Français', 
    'Deutsch', 'Italiano', 'Português', 'Русский', 'العربية',
    'हिन्दी', '한국어', 'Türkçe', 'Polski', 'Nederlands',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF1a1a2e),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture & Name
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2a2a3e), Color(0xFF3a3a4e)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.purpleAccent, Colors.blueAccent],
                              ),
                            ),
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isPro ? Colors.orangeAccent : Colors.grey[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isPro ? 'PRO Member' : 'Basic Member',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Profile Information
                _buildProfileItem(Icons.email, 'Email', 'user@example.com'),
                _buildProfileItem(Icons.cake, 'Birth Date', '01/01/1990 12:00'),
                
                // Language Selection
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language, color: Colors.purpleAccent),
                      SizedBox(width: 15),
                      Text(
                        'Language',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor: Colors.grey[800],
                        style: TextStyle(color: Colors.white),
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
                    ],
                  ),
                ),
                
                _buildProfileItem(Icons.lock, 'Change Password', 'Update'),
                
                // Subscription
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.white),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upgrade to PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Unlock all premium features',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPro,
                            onChanged: (value) {
                              setState(() {
                                _isPro = value;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                      if (_isPro)
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.credit_card, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Annual Subscription: \$99.99/year',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // Payment Methods
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Methods',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPaymentMethod(Icons.credit_card, 'Visa'),
                          _buildPaymentMethod(Icons.credit_card, 'Mastercard'),
                          _buildPaymentMethod(Icons.payment, 'PayPal'),
                          _buildPaymentMethod(Icons.apple, 'Apple Pay'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Logout Button
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent),
          SizedBox(width: 15),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethod(IconData icon, String name) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Additional Pages

// Meditation Page
class MeditationPage extends StatelessWidget {
  final List<Map<String, dynamic>> _levels = [
    {'title': 'Beginner', 'duration': '5-10 min', 'color': Colors.greenAccent},
    {'title': 'Intermediate', 'duration': '15-30 min', 'color': Colors.blueAccent},
    {'title': 'Advanced', 'duration': '30-60 min', 'color': Colors.purpleAccent},
    {'title': 'Master', 'duration': '60+ min', 'color': Colors.orangeAccent},
    {'title': 'Divine', 'duration': 'Unlimited', 'color': Colors.redAccent},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Journey'),
        backgroundColor: Color(0xFF1a1a2e),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: _levels.length,
          itemBuilder: (context, index) {
            final level = _levels[index];
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    level['color'].withOpacity(0.3),
                    level['color'].withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: level['color'], width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.self_improvement, color: level['color'], size: 40),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          level['duration'],
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: level['color'],
                    ),
                    child: Text('Start'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// 3D Buddha Page
class Buddha3DPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Sacred Meditation'),
        backgroundColor: Color(0xFF1a1a2e),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.5),
                      blurRadius: 50,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.self_improvement,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Sacred Visualization',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Focus on inner peace',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Begin Meditation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fortune Detail Page
class FortuneDetailPage extends StatelessWidget {
  final Map<String, dynamic> science;
  
  FortuneDetailPage({required this.science});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(science['title']),
        backgroundColor: Color(0xFF1a1a2e),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      science['color'].withOpacity(0.3),
                      science['color'].withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      science['icon'],
                      size: 80,
                      color: science['color'],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your ${science['title']} Reading',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Based on your birth data and cosmic alignments, '
                      'your fortune reveals unique insights about your path. '
                      'The ancient wisdom of ${science['title']} provides '
                      'guidance for your journey ahead.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildFortuneSection('Love & Relationships', 
                'Your romantic energy is strong. New connections may emerge.'),
              _buildFortuneSection('Career & Success', 
                'Professional opportunities are aligning in your favor.'),
              _buildFortuneSection('Health & Wellness', 
                'Focus on balance and self-care for optimal vitality.'),
              _buildFortuneSection('Wealth & Prosperity', 
                'Financial abundance flows when you trust your intuition.'),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFortuneSection(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}