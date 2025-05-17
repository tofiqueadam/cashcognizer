import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'currency_selection.dart';
import 'about_screen.dart';
import 'settings_screen.dart';
import 'aboutus_screen.dart';
import 'language_selection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomeScreen({required this.cameras});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  String label = 'Detecting...';
  double confidence = 0.0;
  int _selectedIndex = 0;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  bool _flashOn = false;
  String currentMode = "currency";
  late TextRecognizer textRecognizer;
  late FlutterTts flutterTts;
  double _panelHeightFactor = 0.25;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _gesturesEnabled = true;
  DateTime? _lastTap;
  bool _isPaused = false;

  // Text highlighting variables
  int _currentSpokenIndex = 0;
  List<String> _textLines = [];
  final ScrollController _scrollController = ScrollController();
  String _currentSpokenText = '';
  bool _isSpeaking = false;

  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;

  late Map<String, String> _availableVoices = {};
  String _currentVoice = 'default';



  final List<String> validCurrencies = [
    '5 Birr',
    '10 Birr',
    '50 Birr',
    '100 Birr',
    '200 Birr'
  ];

  @override
  void initState() {
    super.initState();
    requestPermissions();
    loadModel();
    textRecognizer = TextRecognizer();
    flutterTts = FlutterTts();
    _initializeTts();
    _initTts();
    if (widget.cameras.isNotEmpty) {
      _initializeCamera(widget.cameras.first);
    }
  }

  Future<void> _initTts() async {
    await flutterTts.awaitSpeakCompletion(true);

    // Get available voices
    var voices = await flutterTts.getVoices;
    if (voices != null) {
      _availableVoices = {
        for (var voice in voices.cast<Map<dynamic, dynamic>>())
          if (voice['name'] != null && voice['locale'] != null)
            voice['name']: "${voice['name']} (${voice['locale']})"
      };
    }
    // Fallback if no voices found
    if (_availableVoices.isEmpty) {
      _availableVoices = {
        'default': 'Default System Voice',
        'male': 'Male Voice (Simulated)',
        'female': 'Female Voice (Simulated)'
      };
    }

    setState(() {});
  }
  Future<void> _setVoice(String voiceId) async {
    try {
      if (_availableVoices.containsKey(voiceId)) {
        await flutterTts.setVoice({"name": voiceId});
        setState(() => _currentVoice = voiceId);
      } else {
        // Handle simulated voices
        if (voiceId == 'male') {
          await flutterTts.setPitch(0.8);
          await flutterTts.setSpeechRate(0.4);
        } else if (voiceId == 'female') {
          await flutterTts.setPitch(1.2);
          await flutterTts.setSpeechRate(0.5);
        }
      }
    } catch (e) {
      print("Error setting voice: $e");
    }
  }

  Future<void> _initializeTts() async {
    try {

      await flutterTts.setSpeechRate(_speechRate);
      await flutterTts.setPitch(_pitch);
      await flutterTts.setVolume(_volume);
      await flutterTts.setLanguage('en-US');
      await flutterTts.awaitSpeakCompletion(true);
      await _speak("App ready. Swipe to navigate, double tap to capture.");
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    _cameraController?.dispose();
    _cameraController = CameraController(camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController!.initialize();
    await _initializeControllerFuture;
    if (!mounted) return;
    setState(() {});
  }



  Future<void> classifyImage(File image) async {
    if (currentMode == 'currency') {
      try {
        var recognitions = await Tflite.runModelOnImage(
          path: image.path,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 5,
          threshold: 0.4,
        );

        if (recognitions != null && recognitions.isNotEmpty) {
          final best = recognitions.firstWhere(
                (r) => validCurrencies.contains(r['label']),
            orElse: () => recognitions.first,
          );

          setState(() {
            label = validCurrencies.contains(best['label'])
                ? best['label']
                : 'Unrecognized Note';
            confidence = (best['confidence'] * 100);
          });

          final message = label == 'Unrecognized Note'
              ? 'Unrecognized currency. Please try again.'
              : '${label.replaceAll(' Birr', '')} Birr detected with ${confidence.toStringAsFixed(1)} percent confidence';
          await _speak(message);
        }
      } catch (e) {
        await _speak('Error detecting currency. Please try again.');
      }
    } else {
      try {
        final inputImage = InputImage.fromFilePath(image.path);
        final recognizedText = await textRecognizer.processImage(inputImage);

        setState(() {
          label = recognizedText.text.isNotEmpty
              ? recognizedText.text
              : 'No text detected';
          confidence = 100.0;
          _textLines = label.split('\n');
          _currentSpokenIndex = 0;
          _currentSpokenText = '';
        });

        if (recognizedText.text.isEmpty) {
          await _speak('No text detected');
        } else {
          _isSpeaking = true;
          await _speakTextSequentially(_textLines);
          _isSpeaking = false;
        }
      } catch (e) {
        setState(() {
          label = 'Text recognition failed';
          confidence = 0.0;
        });
        await _speak('Text recognition failed. Please try again.');
      }
    }
  }

  Future<void> _speakTextSequentially(List<String> lines) async {
    try {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });

      for (int i = 0; i < lines.length; i++) {
        // Check if mode changed or view switched
        if (currentMode != 'text' || !_isSpeaking || _isPaused) {
          break;
        }

        final line = lines[i].trim();
        if (line.isEmpty) continue;

        setState(() {
          _currentSpokenIndex = i;
          _currentSpokenText = line;
        });

        _scrollToLine(i);
        await _speak("Line ${i + 1}. $line");

        if (i < lines.length - 1) {
          await Future.delayed(Duration(milliseconds: 300));
        }
      }

      if (currentMode == 'text' && _isSpeaking && !_isPaused) {
        await _speak("Finished reading text.");
      }
    } finally {
      setState(() {
        _isSpeaking = false;
        _currentSpokenText = '';
      });
    }
  }

  void _scrollToLine(int lineIndex) {
    if (!_scrollController.hasClients) return;

    final lineHeight = 24.0;
    final panelHeight = MediaQuery.of(context).size.height * _panelHeightFactor;
    final targetOffset = (lineIndex * lineHeight) - (panelHeight / 3);

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> _takePicture() async {
    await flutterTts.stop();
    if (!_cameraController!.value.isInitialized) return;
    try {
      setState(() {
        label = 'Processing...';
        confidence = 0.0;
        _panelHeightFactor = 0.25;
      });

      final XFile image = await _cameraController!.takePicture();
      File imageFile = File(image.path);
      setState(() {
        _imageFile = imageFile;
        _selectedIndex = 1;
      });
      await classifyImage(imageFile);
    } catch (e) {
      print("Error capturing image: $e");
      await _speak("Error capturing image");
    }
  }

  Future<void> _pickImage() async {
    await flutterTts.stop();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        label = 'Processing...';
        confidence = 0.0;
        _panelHeightFactor = 0.25;
      });
      await classifyImage(_imageFile!);
    }
  }

  void _toggleFlash() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      if (_flashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _flashOn = !_flashOn;
      });
      await _speak(_flashOn ? "Flash on" : "Flash off");
    }
  }
  void _resetState() {
    setState(() {
      _imageFile = null;
      label = currentMode == 'currency' ? 'Detecting...' : 'Reading text...';
      confidence = 0.0;
      _panelHeightFactor = 0.25;
      _isSpeaking = false;
      _isPaused = false;
      _currentSpokenIndex = 0;
      _currentSpokenText = '';
      _textLines = [];
    });
  }

  void _handleModeChange(String? value) async {
    if (value == null) return;
    await flutterTts.stop();
    _resetState();
    setState(() {
      currentMode = value;
      _selectedIndex = 0; // Reset to camera view when mode changes
    });
    await _speak("Switched to ${currentMode == 'currency' ? 'currency' : 'text'} mode");
  }

  Future<void> _speak(String message) async {
    try {
      await flutterTts.stop(); // Stop any ongoing speech first
      await flutterTts.speak(message);
    } catch (e) {
      print("Error speaking: $e");
    }
  }

  Future<void> _playSound(String sound) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/$sound.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 50);
    }
  }

  Widget _buildGestureDetector(Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (!_gesturesEnabled) return;
        _vibrate();
        flutterTts.stop();
        if (details.primaryVelocity! > 0) {
          // Swiped right - switch to camera
          _resetState();
          setState(() => _selectedIndex = 0);
          _speak("Camera mode");
        } else {
          // Swiped left - switch to gallery
          _resetState();
          setState(() => _selectedIndex = 1);
          _speak("Gallery mode");
        }
      },

      onVerticalDragEnd: (details) {
        if (!_gesturesEnabled) return;
        _vibrate();
        flutterTts.stop(); // Stop speech when switching views

        if (details.primaryVelocity! > 0) {
          // Swiped down - switch to currency mode
          _handleModeChange('currency');
        } else {
          // Swiped up - switch to text mode
          _handleModeChange('text');
        }
      },
      onTap: () {
        if (!_gesturesEnabled) return;

        final now = DateTime.now();
        if (_lastTap != null && now.difference(_lastTap!) < Duration(milliseconds: 300)) {
          // Double tap - take picture/select image
          _lastTap = null;
          _vibrate();
          _takePictureOrSelect();
        } else {
          // Single tap - pause/play in text mode
          _lastTap = now;
          if (currentMode == 'text' && _textLines.isNotEmpty) {
            _vibrate();
            _toggleTextPlayback();
          }
        }
      },
      child: child,
    );
  }

  Future<void> _takePictureOrSelect() async {
    if (_selectedIndex == 0) {
      await _takePicture();
    } else {
      await _pickImage();
    }
  }

  Future<void> _toggleTextPlayback() async {
    if (_isSpeaking && !_isPaused) {
      await flutterTts.pause();
      setState(() => _isPaused = true);
      _speak("Paused");
    } else if (_isPaused) {
      setState(() => _isPaused = false);
      _speak("Resumed");
    } else if (_textLines.isNotEmpty) {
      _speakTextSequentially(_textLines);
    }
  }

  Future<void> _showGestureHelp() async {
    await _speak(
        "Gesture Help Guide. "
            "Swipe left or right to switch between camera and gallery. "
            "Swipe up or down to change between text and currency modes. "
            "Double tap to capture image or select from gallery. "
            "In text mode, single tap to pause or resume reading. "
            "You can disable gestures in settings if needed."
    );
  }

  @override
  void dispose() {
    Tflite.close();
    textRecognizer.close();
    flutterTts.stop();
    _cameraController?.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff281537),
    ));

    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = screenHeight * _panelHeightFactor;

    return _buildGestureDetector(
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff281537),
          title: Text(
            currentMode == 'currency'
                ? 'Currency Detection'
                : 'Text Recognition',
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            if (_isSpeaking && currentMode == 'text')
              IconButton(
                icon: Icon(Icons.stop, color: Colors.white),
                onPressed: () async {
                  await flutterTts.stop();
                  setState(() {
                    _isSpeaking = false;
                    _currentSpokenText = '';
                    _currentSpokenIndex = -1;
                  });
                },
              ),
            IconButton(
              icon: currentMode == "text"
                  ? Icon(Icons.language, color: Colors.white)
                  : Image.asset('assets/ethiopian_flag.png', width: 24, height: 24),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => currentMode == "text"
                      ? LanguageSelectionScreen()
                      : CurrencySelectionScreen(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child:_selectedIndex == 0
                ? (_cameraController == null || !_cameraController!.value.isInitialized)
                ? Center(child: CircularProgressIndicator())
                : LayoutBuilder(
              builder: (context, constraints) {
                final previewSize = _cameraController!.value.previewSize!;
                final screenRatio = constraints.maxWidth / constraints.maxHeight;
                final previewRatio = previewSize.height / previewSize.width;

                return Stack(
                  children: [
                    // Cropping vertically by expanding width and cropping extra height
                    OverflowBox(
                      maxWidth: screenRatio > previewRatio
                          ? constraints.maxWidth
                          : constraints.maxHeight * previewRatio,
                      maxHeight: screenRatio > previewRatio
                          ? constraints.maxWidth / previewRatio
                          : constraints.maxHeight,
                      child: CameraPreview(_cameraController!),
                    ),

                    // Flash button
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: _toggleFlash,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Icon(
                            _flashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                    // Capture button
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: _takePicture,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )

                : GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Select ${currentMode == 'currency' ? 'banknote' : 'text'} image',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              )
                  : Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.file(
                          File(_imageFile!.path),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: currentMode == 'currency'
                        ? Container(
                      color: Colors.black54,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${confidence.toStringAsFixed(1)}% Confidence",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      height: panelHeight,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              final deltaFactor = -details.delta.dy / screenHeight;
                              setState(() {
                                _panelHeightFactor = (_panelHeightFactor + deltaFactor)
                                    .clamp(0.25, 0.75);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Detected Text ▼',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              child: RichText(
                                text: TextSpan(
                                  children: _textLines.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final line = entry.value;
                                    final isCurrentLine = index == _currentSpokenIndex;

                                    return TextSpan(
                                      text: '$line\n',
                                      style: TextStyle(
                                        color: isCurrentLine ? Colors.yellow : Colors.white,
                                        fontSize: 16,
                                        height: 1.4,
                                        backgroundColor: isCurrentLine ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff387780), Color(0xff281537)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: Text('T',
                          style: TextStyle(fontSize: 40, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    Text('tofique',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    Text('tofique@gmail.com',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Currency'),
                trailing: Radio<String>(
                  value: 'currency',
                  groupValue: currentMode,
                  onChanged: _handleModeChange,
                ),
              ),
              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('Text'),
                trailing: Radio<String>(
                  value: 'text',
                  groupValue: currentMode,
                  onChanged: _handleModeChange,
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  _speak("Home");
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _speak("Profile");
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      initialGestureState: _gesturesEnabled,
                      initialSpeechRate: _speechRate,
                      initialVolume: _volume,
                      initialPitch: _pitch,
                      availableVoices: _availableVoices,
                      initialVoice: _currentVoice,
                      onGestureStateChanged: (value) => setState(() => _gesturesEnabled = value),
                      onSpeechRateChanged: (value) {
                        setState(() => _speechRate = value);
                        flutterTts.setSpeechRate(value);
                      },
                      onVolumeChanged: (value) {
                        setState(() => _volume = value);
                        flutterTts.setVolume(value);
                      },
                      onPitchChanged: (value) {
                        setState(() => _pitch = value);
                        flutterTts.setPitch(value);
                      },
                      onVoiceChanged: _setVoice,

                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Gesture Help'),
                onTap: () {
                  Navigator.pop(context);
                  _showGestureHelp();
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsScreen())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Exit'),
                      content: Text('Are you sure you want to exit the app?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _speak("Cancelled");
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text('Exit'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xff281537),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    flutterTts.stop();
                    _resetState();
                    setState(() {
                      _selectedIndex = 0;

                      if (widget.cameras.isNotEmpty &&
                          (_cameraController == null ||
                              !_cameraController!.value.isInitialized)) {
                        _initializeCamera(widget.cameras.first);
                      }
                    });
                    _speak("Camera mode");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0 ? Colors.lightBlue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    flutterTts.stop();
                    _resetState();
                    setState(() => _selectedIndex = 1);
                    _speak("Gallery mode");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1 ? Colors.lightBlue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.photo,
                      size: 30,
                      color: _selectedIndex == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}