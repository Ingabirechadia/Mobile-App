import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const VisionTranslatorApp());
}

class VisionTranslatorApp extends StatelessWidget {
  const VisionTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF4A90E2),
        ),
      ),
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}

/* ================= SPLASH SCREEN ================= */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo animation - starts immediately
    _logoAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.1)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0),
        weight: 50.0,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Title animation - starts after logo
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeInOut),
      ),
    );

    // Subtitle animation - starts last
    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to main page after splash duration
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    // Wait for animations and any initialization
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animation
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'VT',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Title with fade animation
            AnimatedBuilder(
              animation: _titleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _titleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _titleAnimation.value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'VISION TRANSLATOR',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2B55),
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle with fade animation
            AnimatedBuilder(
              animation: _subtitleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _subtitleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - _subtitleAnimation.value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'Speak in any language, translate instantly',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  letterSpacing: 0.5,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Simple loading indicator
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _controller.value > 0.8 ? 1.0 : 0.0,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Stack(
                      children: [
                        // Background line
                        Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Animated progress line
                        Container(
                          width: 60 *
                              (_controller.value - 0.8) *
                              5, // Appears in last 0.2 of animation
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6C63FF),
                                Color(0xFF4A90E2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
/* ================= MAIN PAGE ================= */

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  final List<Map<String, String>> _history = [];

  final stt.SpeechToText _speech = stt.SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();

  bool _listening = false;
  String _transcribed = '';
  String _translated = '';

  final Map<String, String> _speechLangCodes = {
    'English': 'en-US',
    'French': 'fr-FR',
    'Kinyarwanda': 'rw',
  };

  final Map<String, String> _translateLangCodes = {
    'English': 'en',
    'French': 'fr',
    'Kinyarwanda': 'rw',
  };

  String _sourceLang = 'English';
  String _targetLang = 'French';

  @override
  void initState() {
    super.initState();
    _requestMic();
    _initSpeech();
  }

  Future<void> _requestMic() async {
    await Permission.microphone.request();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  void _saveHistory({String? customName}) {
    if (_transcribed.isNotEmpty) {
      _history.insert(0, {
        'text': _transcribed,
        'sourceLang': _sourceLang,
        'targetLang': _targetLang,
        'translation': _translated,
        'timestamp': DateTime.now().toIso8601String(),
        'name': customName ?? 'Recording ${_history.length + 1}',
      });
    }
  }

  void _deleteHistory(int index) {
    setState(() {
      _history.removeAt(index);
    });
  }

  void _clearAllHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _clearTranscription() {
    setState(() {
      _transcribed = '';
      _translated = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const WelcomePage(),
      RecordingPage(
        speech: _speech,
        translator: _translator,
        listening: _listening,
        transcribed: _transcribed,
        translated: _translated,
        sourceLang: _sourceLang,
        targetLang: _targetLang,
        speechLangCodes: _speechLangCodes,
        translateLangCodes: _translateLangCodes,
        onListening: (v) => setState(() => _listening = v),
        onTranscribed: (v) => setState(() => _transcribed = v),
        onTranslated: (v) => setState(() => _translated = v),
        onSourceLangChange: (v) => setState(() => _sourceLang = v),
        onTargetLangChange: (v) => setState(() => _targetLang = v),
        onSave: (customName) => _saveHistory(customName: customName),
        onClearTranscription: _clearTranscription,
      ),
      HistoryPage(
        history: _history,
        onDelete: _deleteHistory,
        onClearAll: _clearAllHistory,
      ),
      const SettingsPage(),
      const AboutPage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            selectedItemColor: const Color(0xFF6C63FF),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            onTap: (i) => setState(() => _index = i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic_none),
                activeIcon: Icon(Icons.mic),
                label: 'Record',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                activeIcon: Icon(Icons.info),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= WELCOME PAGE ================= */

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // App Logo and Title
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'VT',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'VISION TRANSLATOR',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2B55),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Speak in any language, translate instantly',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Features List
              _buildFeatureCard(
                icon: Icons.speed,
                title: 'Multi-language Speech',
                subtitle: 'Record in English, French & Kinyarwanda',
                color: const Color(0xFF6C63FF),
              ),
              const SizedBox(height: 20),
              _buildFeatureCard(
                icon: Icons.language,
                title: 'Real-time Translation',
                subtitle: 'Translate between 3 languages instantly',
                color: const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 20),
              _buildFeatureCard(
                icon: Icons.save,
                title: 'Save & Organize',
                subtitle: 'Keep your transcriptions safe',
                color: const Color(0xFF36D1DC),
              ),

              const SizedBox(height: 50),

              // Get Started Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    final mainState =
                        context.findAncestorStateOfType<_MainPageState>();
                    mainState?.setState(() {
                      mainState._index = 1;
                    });
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Version Info
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2B55),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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

/* ================= RECORDING PAGE ================= */

class RecordingPage extends StatefulWidget {
  final stt.SpeechToText speech;
  final GoogleTranslator translator;
  final bool listening;
  final String transcribed;
  final String translated;
  final String sourceLang;
  final String targetLang;
  final Map<String, String> speechLangCodes;
  final Map<String, String> translateLangCodes;
  final Function(bool) onListening;
  final Function(String) onTranscribed;
  final Function(String) onTranslated;
  final Function(String) onSourceLangChange;
  final Function(String) onTargetLangChange;
  final Function(String?) onSave;
  final VoidCallback onClearTranscription;

  const RecordingPage({
    super.key,
    required this.speech,
    required this.translator,
    required this.listening,
    required this.transcribed,
    required this.translated,
    required this.sourceLang,
    required this.targetLang,
    required this.speechLangCodes,
    required this.translateLangCodes,
    required this.onListening,
    required this.onTranscribed,
    required this.onTranslated,
    required this.onSourceLangChange,
    required this.onTargetLangChange,
    required this.onSave,
    required this.onClearTranscription,
  });

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _startRecording() async {
    try {
      bool isAvailable = await widget.speech.initialize(
        onError: (errorNotification) {
          print('Speech recognition error: $errorNotification');
          widget.onListening(false);
        },
        onStatus: (statusNotification) {
          print('Speech recognition status: $statusNotification');
          if (statusNotification == 'notListening') {
            widget.onListening(false);
          }
        },
      );

      if (!isAvailable) {
        print('Speech recognition not available');
        widget.onListening(false);
        return;
      }

      widget.onListening(true);

      String? localeId = widget.speechLangCodes[widget.sourceLang];
      if (localeId == null) {
        print('Language code not found for ${widget.sourceLang}');
        widget.onListening(false);
        return;
      }

      widget.speech.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        localeId: localeId,
        onResult: (result) {
          if (result.finalResult) {
            final recognizedText = result.recognizedWords;
            widget.onTranscribed(recognizedText);

            if (widget.sourceLang != widget.targetLang &&
                recognizedText.isNotEmpty) {
              _translateText(recognizedText);
            } else {
              widget.onTranslated(recognizedText);
            }
          } else {
            widget.onTranscribed(result.recognizedWords);
          }
        },
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
      widget.onListening(false);
    }
  }

  void _stopRecording() {
    widget.speech.stop();
    widget.onListening(false);
  }

  Future<void> _translateText(String text) async {
    if (text.isEmpty || widget.sourceLang == widget.targetLang) {
      widget.onTranslated(text);
      return;
    }

    try {
      final sourceCode = widget.translateLangCodes[widget.sourceLang];
      final targetCode = widget.translateLangCodes[widget.targetLang];

      if (sourceCode == null || targetCode == null) {
        print('Language code not found');
        widget.onTranslated('Translation error: Language not supported');
        return;
      }

      final translation = await widget.translator.translate(
        text,
        from: sourceCode,
        to: targetCode,
      );

      widget.onTranslated(translation.text);
    } catch (e) {
      print('Translation error: $e');
      widget.onTranslated('Translation failed. Please try again.');
    }
  }

  Future<void> _manualTranslate() async {
    if (widget.transcribed.isNotEmpty &&
        widget.sourceLang != widget.targetLang) {
      await _translateText(widget.transcribed);
    }
  }

  Future<void> _saveWithName() async {
    if (widget.transcribed.isEmpty) return;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Transcription'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter a name for this transcription',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Navigator.of(context).pop(_nameController.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      widget.onSave(name);
      _nameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved as "$name"'),
            backgroundColor: const Color(0xFF6C63FF),
          ),
        );
      }
    } else if (name == null) {
      widget.onSave(null);
      _nameController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice to Text'),
        centerTitle: true,
        actions: [
          if (widget.transcribed.isNotEmpty)
            IconButton(
              onPressed: widget.onClearTranscription,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all text',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language Selection Cards
            Row(
              children: [
                Expanded(
                  child: _buildLanguageSelector(
                    title: 'Speak in',
                    currentLang: widget.sourceLang,
                    onLangChanged: (newLang) {
                      widget.onSourceLangChange(newLang);
                      if (widget.transcribed.isNotEmpty &&
                          newLang != widget.targetLang) {
                        _translateText(widget.transcribed);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward,
                    color: Color(0xFF6C63FF), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildLanguageSelector(
                    title: 'Translate to',
                    currentLang: widget.targetLang,
                    onLangChanged: (newLang) {
                      widget.onTargetLangChange(newLang);
                      if (widget.transcribed.isNotEmpty &&
                          widget.sourceLang != newLang) {
                        _translateText(widget.transcribed);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Transcription Card
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.mic,
                                  size: 20, color: Color(0xFF6C63FF)),
                              const SizedBox(width: 8),
                              Text(
                                'Speaking in ${widget.sourceLang}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                          if (widget.transcribed.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                widget.onTranscribed('');
                                if (widget.sourceLang != widget.targetLang) {
                                  widget.onTranslated('');
                                }
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              tooltip: 'Clear transcription',
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.transcribed.isEmpty
                                ? 'Tap the microphone below to start speaking in ${widget.sourceLang}...'
                                : widget.transcribed,
                            style: TextStyle(
                              fontSize: 18,
                              color: widget.transcribed.isEmpty
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Translation Card (only show if different language)
            if (widget.sourceLang != widget.targetLang)
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.translate,
                                    size: 20, color: Color(0xFF4A90E2)),
                                const SizedBox(width: 8),
                                Text(
                                  'Translated to ${widget.targetLang}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A90E2),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.translated.isNotEmpty)
                              IconButton(
                                onPressed: () => widget.onTranslated(''),
                                icon: const Icon(Icons.clear, size: 18),
                                tooltip: 'Clear translation',
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.translated.isEmpty
                                  ? 'Translation will appear here...'
                                  : widget.translated,
                              style: TextStyle(
                                fontSize: 18,
                                color: widget.translated.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (widget.sourceLang == widget.targetLang)
              const SizedBox(height: 20),

            // Action Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Clear All Button
                  if (widget.transcribed.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: widget.onClearTranscription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear All'),
                    ),

                  // Save Button
                  if (widget.transcribed.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _saveWithName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Save'),
                    ),

                  // Manual Translate Button
                  if (widget.transcribed.isNotEmpty &&
                      widget.sourceLang != widget.targetLang &&
                      !widget.listening)
                    ElevatedButton.icon(
                      onPressed: _manualTranslate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.translate, size: 18),
                      label: const Text('Translate'),
                    ),
                ],
              ),
            ),

            // Microphone Button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: widget.listening
                      ? [Colors.redAccent, Colors.red]
                      : [const Color(0xFF6C63FF), const Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.listening
                        ? Colors.redAccent.withOpacity(0.4)
                        : const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: widget.listening ? _stopRecording : _startRecording,
                icon: Icon(
                  widget.listening ? Icons.stop : Icons.mic,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.listening
                  ? 'Listening in ${widget.sourceLang}...'
                  : 'Tap to speak in ${widget.sourceLang}',
              style: TextStyle(
                color: widget.listening ? Colors.redAccent : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector({
    required String title,
    required String currentLang,
    required Function(String) onLangChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2B55),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: currentLang,
              isExpanded: true,
              underline: Container(),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(
                color: Color(0xFF2D2B55),
                fontSize: 16,
              ),
              items:
                  ['English', 'French', 'Kinyarwanda'].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLangChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= HISTORY PAGE ================= */

class HistoryPage extends StatelessWidget {
  final List<Map<String, String>> history;
  final Function(int) onDelete;
  final VoidCallback onClearAll;

  const HistoryPage({
    super.key,
    required this.history,
    required this.onDelete,
    required this.onClearAll,
  });

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
            'Are you sure you want to delete all saved transcriptions? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onClearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All history cleared'),
                  backgroundColor: Color(0xFF6C63FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDetail(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['name']!),
            const SizedBox(height: 4),
            Text(
              '${item['sourceLang']!} → ${item['targetLang']!}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Original Text:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 5),
              Text(item['text']!),
              const SizedBox(height: 15),
              if (item['translation']!.isNotEmpty &&
                  item['translation'] != item['text'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Translation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(item['translation']!),
                  ],
                ),
              const SizedBox(height: 10),
              Text(
                'Time: ${DateTime.parse(item['timestamp']!).toString()}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              onPressed: () => _showClearAllDialog(context),
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all history',
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5FF),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.history,
                      size: 60,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No History Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2B55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Your saved transcriptions will appear here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Clear All Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _showClearAllDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete_sweep, size: 16),
                      label: const Text('Clear All'),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final timestamp = DateTime.parse(item['timestamp']!);

                      return Dismissible(
                        key: Key('history-$index-${item['timestamp']}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) => onDelete(index),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notes,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF2D2B55),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['text']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        '${item['sourceLang']!} → ${item['targetLang']!}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: const Color(0xFFF5F5FF),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () => onDelete(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              tooltip: 'Delete',
                            ),
                            onTap: () {
                              _showHistoryDetail(context, item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/* ================= SETTINGS PAGE ================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingSection(
            title: 'Supported Languages',
            icon: Icons.language,
            child: Column(
              children: [
                _buildLanguageItem('English', 'en-US'),
                _buildLanguageItem('French', 'fr-FR'),
                _buildLanguageItem('Kinyarwanda', 'rw-RW'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingSection(
            title: 'Recordings',
            icon: Icons.mic,
            child: SwitchListTile(
              title: const Text('Auto save transcriptions'),
              subtitle: const Text('Automatically save when recording stops'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingSection(
            title: 'Sound',
            icon: Icons.volume_up,
            child: SwitchListTile(
              title: const Text('Sound effects'),
              subtitle: const Text('Play sound for actions'),
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingSection(
            title: 'App Information',
            icon: Icons.info,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Version'),
                  trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
                ),
                ListTile(
                  title: Text('Build'),
                  trailing:
                      Text('2025.11.20', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF6C63FF), size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2B55),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String language, String code) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
        child: Text(
          language[0],
          style: const TextStyle(color: Color(0xFF6C63FF)),
        ),
      ),
      title: Text(language),
      subtitle: Text('Code: $code'),
    );
  }
}

/* ================= ABOUT PAGE ================= */

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  'VT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Vision Translator',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2B55),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Speak in any language, translate instantly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'Supports speech recognition and translation between:\n'
              '• English\n• French\n• Kinyarwanda\n\n',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              title: 'Privacy & Security',
              content: 'Your transcriptions are stored locally. '
                  'We do not collect or share your voice data with third parties.',
              icon: Icons.security,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              title: 'Contact & Support',
              content:
                  'Need help or have feedback?\nWe\'d love to hear from you.',
              icon: Icons.support,
            ),
            const SizedBox(height: 10),
            const Text(
              'albetech@gmail.com',
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF6C63FF)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2B55),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
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
