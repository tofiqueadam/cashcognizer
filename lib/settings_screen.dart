import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialGestureState;
  final double initialSpeechRate;
  final double initialVolume;
  final double initialPitch;
  final List<Map<String, String>> availableVoices;
  final String initialVoice;
  final bool initialDarkMode;
  final bool initialVoiceGuidance;
  final bool initialHighContrast;
  final String initialLanguage;
  final ValueChanged<bool>? onGestureStateChanged;
  final ValueChanged<double>? onSpeechRateChanged;
  final ValueChanged<double>? onVolumeChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<Map<String, String>>? onVoiceChanged;
  final ValueChanged<bool>? onDarkModeChanged;
  final ValueChanged<bool>? onVoiceGuidanceChanged;
  final ValueChanged<bool>? onHighContrastChanged;
  final ValueChanged<String>? onLanguageChanged;

  const SettingsScreen({
    Key? key,
    required this.initialGestureState,
    this.initialSpeechRate = 0.5,
    this.initialVolume = 1.0,
    this.initialPitch = 1.0,
    required this.availableVoices,
    required this.initialVoice,
    this.initialDarkMode = false,
    this.initialVoiceGuidance = true,
    this.initialHighContrast = false,
    this.initialLanguage = "English",
    this.onGestureStateChanged,
    this.onSpeechRateChanged,
    this.onVolumeChanged,
    this.onPitchChanged,
    this.onVoiceChanged,
    this.onDarkModeChanged,
    this.onVoiceGuidanceChanged,
    this.onHighContrastChanged,
    this.onLanguageChanged,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _gesturesEnabled;
  late double _speechRate;
  late double _volume;
  late double _pitch;
  late String _selectedVoice;
  late bool _darkMode;
  late bool _voiceGuidance;
  late bool _highContrast;
  late String _language;
  late bool _largeText;

  @override
  void initState() {
    super.initState();
    _gesturesEnabled = widget.initialGestureState;
    _speechRate = widget.initialSpeechRate;
    _volume = widget.initialVolume;
    _pitch = widget.initialPitch;
    _selectedVoice = widget.initialVoice;
    _darkMode = widget.initialDarkMode;
    _voiceGuidance = widget.initialVoiceGuidance;
    _highContrast = widget.initialHighContrast;
    _language = widget.initialLanguage;
    _largeText = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: _darkMode ? Colors.black : Colors.grey[100],
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionHeader("Appearance"),
            _buildDarkModeToggle(),
            _buildLargeTextToggle(),

            _buildSectionHeader("Voice Settings"),
            _buildVoiceSelection(),
            _buildSpeechRateSlider(),
            _buildVolumeSlider(),
            _buildPitchSlider(),

            _buildSectionHeader("Accessibility"),
            _buildGestureToggle(),
            _buildVoiceGuidanceToggle(),
            _buildHighContrastToggle(),
            _buildAccessibilityOptions(),

            _buildLanguageSelection(),




            _buildSectionHeader("Other Preferences"),
            _buildResetSettingsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: _darkMode ? Colors.white70 : Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text(
          "Dark Mode",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        value: _darkMode,
        onChanged: (value) {
          setState(() => _darkMode = value);
          widget.onDarkModeChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }

  Widget _buildLargeTextToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text(
          "Large Text",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        value: _largeText,
        onChanged: (value) {
          setState(() => _largeText = value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }

  Widget _buildGestureToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text(
          "Gesture Controls",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        value: _gesturesEnabled,
        onChanged: (value) {
          setState(() => _gesturesEnabled = value);
          widget.onGestureStateChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }

  Widget _buildVoiceGuidanceToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text(
          "Voice Guidance",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        value: _voiceGuidance,
        onChanged: (value) {
          setState(() => _voiceGuidance = value);
          widget.onVoiceGuidanceChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }

  Widget _buildHighContrastToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text(
          "High Contrast Mode",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        value: _highContrast,
        onChanged: (value) {
          setState(() => _highContrast = value);
          widget.onHighContrastChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }
  Widget _buildAccessibilityOptions() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              "Screen Reader",
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
            value: true,
            onChanged: (value) {},
            activeColor: Color(0xff6a1b9a),
          ),

        ],
      ),
    );
  }
  Widget _buildLanguageSelection() {
    final languages = ["English", "Amharic", "Oromo", "Tigrinya", "Other"];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Preferred Language",
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              dropdownColor: _darkMode ? Color(0xff281537) : Colors.white,
              value: _language,
              items: languages.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: _darkMode ? Colors.white : Colors.black,
                      fontSize: _largeText ? 18 : 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _language = value);
                  widget.onLanguageChanged?.call(value);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xff6a1b9a)),
                ),
                filled: true,
                fillColor: _darkMode ? Color(0xff281537) : Colors.white,
              ),
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceSelection() {
    if (widget.availableVoices.isEmpty) {
      return SizedBox.shrink();
    }

    final currentVoice = widget.availableVoices.firstWhere(
          (voice) => voice['name'] == _selectedVoice,
      orElse: () => widget.availableVoices.first,
    );

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Voice Type",
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<Map<String, String>>(
              dropdownColor: _darkMode ? Color(0xff281537) : Colors.white,
              value: currentVoice,
              items: widget.availableVoices.map((voice) {
                return DropdownMenuItem<Map<String, String>>(
                  value: voice,
                  child: Text(
                    "${voice['name']} (${voice['locale'] == 'simulated' ? 'Simulated' : voice['locale']})",
                    style: TextStyle(
                      color: _darkMode ? Colors.white : Colors.black,
                      fontSize: _largeText ? 18 : 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedVoice = value['name']!);
                  widget.onVoiceChanged?.call(value);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xff6a1b9a)),
                ),
                filled: true,
                fillColor: _darkMode ? Color(0xff281537) : Colors.white,
              ),
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechRateSlider() {
    return _buildSlider(
      "Speech Rate",
      _speechRate,
      0.3,
      1.0,
          (value) {
        setState(() => _speechRate = value);
        widget.onSpeechRateChanged?.call(value);
      },
      "${_speechRate.toStringAsFixed(1)}x",
    );
  }

  Widget _buildVolumeSlider() {
    return _buildSlider(
      "Volume",
      _volume,
      0.0,
      1.0,
          (value) {
        setState(() => _volume = value);
        widget.onVolumeChanged?.call(value);
      },
      "${(_volume * 100).toStringAsFixed(0)}%",
    );
  }

  Widget _buildPitchSlider() {
    return _buildSlider(
      "Pitch",
      _pitch,
      0.5,
      2.0,
          (value) {
        setState(() => _pitch = value);
        widget.onPitchChanged?.call(value);
      },
      _pitch.toStringAsFixed(1),
    );
  }

  Widget _buildSlider(
      String title,
      double value,
      double min,
      double max,
      ValueChanged<double> onChanged,
      String label,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title: $label",
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
                fontSize: _largeText ? 18 : 16,
              ),
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min) ~/ 0.1,
              label: label,
              activeColor: Color(0xff6a1b9a),
              inactiveColor: _darkMode ? Colors.grey[800] : Colors.grey[400],
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildResetSettingsButton() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.restore,
          color: _darkMode ? Colors.white70 : Colors.black54,
        ),
        title: Text(
          "Reset to Default Settings",
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
            fontSize: _largeText ? 18 : 16,
          ),
        ),
        onTap: () {
          _showResetConfirmationDialog();
        },
      ),
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset Settings",
            style: TextStyle(
              color: _darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 20 : 18,
            ),
          ),
          content: Text(
            "Are you sure you want to reset all settings to their default values?",
            style: TextStyle(
              color: _darkMode ? Colors.white70 : Colors.black54,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          backgroundColor: _darkMode ? Color(0xff1a0d24) : Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xff6a1b9a),
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetAllSettings();
                Navigator.of(context).pop();
              },
              child: Text(
                "Reset",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
            ),
          ],

        );
      },
    );
  }

  void _resetAllSettings() {
    setState(() {
      _gesturesEnabled = true;
      _speechRate = 0.5;
      _volume = 1.0;
      _pitch = 1.0;
      _selectedVoice = widget.availableVoices.isNotEmpty
          ? widget.availableVoices.first['name']!
          : "";
      _darkMode = false;
      _voiceGuidance = true;
      _highContrast = false;
      _language = "English";
      _largeText = false;
    });

    // Call all change callbacks
    widget.onGestureStateChanged?.call(true);
    widget.onSpeechRateChanged?.call(0.5);
    widget.onVolumeChanged?.call(1.0);
    widget.onPitchChanged?.call(1.0);
    if (widget.availableVoices.isNotEmpty) {
      widget.onVoiceChanged?.call(widget.availableVoices.first);
    }
    widget.onDarkModeChanged?.call(false);
    widget.onVoiceGuidanceChanged?.call(true);
    widget.onHighContrastChanged?.call(false);
    widget.onLanguageChanged?.call("English");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All settings have been reset to default'),
        backgroundColor: _darkMode ? Color(0xff6a1b9a) : Color(0xff281537),
      ),
    );
  }
}