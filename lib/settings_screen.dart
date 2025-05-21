import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialGestureState;
  final double initialSpeechRate;
  final double initialVolume;
  final double initialPitch;
  final List<Map<String, String>> availableVoices;
  final String initialVoice;
  final ValueChanged<bool>? onGestureStateChanged;
  final ValueChanged<double>? onSpeechRateChanged;
  final ValueChanged<double>? onVolumeChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<Map<String, String>>? onVoiceChanged;
  final bool initialDarkMode;
  final ValueChanged<bool>? onDarkModeChanged;


  const SettingsScreen({
    Key? key,
    required this.initialGestureState,
    this.initialSpeechRate = 0.5,
    this.initialVolume = 1.0,
    this.initialPitch = 1.0,
    required this.availableVoices,
    required this.initialVoice,
    this.initialDarkMode = false, // Add this
    this.onGestureStateChanged,
    this.onSpeechRateChanged,
    this.onVolumeChanged,
    this.onPitchChanged,
    this.onVoiceChanged,
    this.onDarkModeChanged, // Add this

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
  late bool _darkMode; // Add this


  @override
  void initState() {
    super.initState();
    _gesturesEnabled = widget.initialGestureState;
    _speechRate = widget.initialSpeechRate;
    _volume = widget.initialVolume;
    _pitch = widget.initialPitch;
    _selectedVoice = widget.initialVoice;
    _darkMode = widget.initialDarkMode; // Initialize dark mode

  }
  // Add this new method for dark mode toggle
  Widget _buildDarkModeToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text("Dark Mode",
            style: TextStyle(color: _darkMode ? Colors.white : Colors.black)),
        subtitle: Text("Toggle between light and dark theme",
            style: TextStyle(color: _darkMode ? Colors.white54 : Colors.black54)),
        value: _darkMode,
        onChanged: (value) {
          setState(() => _darkMode = value);
          widget.onDarkModeChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
      ),
    );
  }

  Widget _buildVoiceSelection() {
    if (widget.availableVoices.isEmpty) {
      return SizedBox.shrink();
    }

    // Find the current voice in the available voices
    final currentVoice = widget.availableVoices.firstWhere(
          (voice) => voice['name'] == _selectedVoice,
      orElse: () => widget.availableVoices.first,
    );

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Voice Type", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<Map<String, String>>(
              dropdownColor: Color(0xff281537),
              value: currentVoice,
              items: widget.availableVoices.map((voice) {
                return DropdownMenuItem<Map<String, String>>(
                  value: voice,
                  child: Text(
                    "${voice['name']} (${voice['locale'] == 'simulated' ? 'Simulated' : voice['locale']})",
                    style: TextStyle(color: Colors.white),
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
                fillColor: Color(0xff281537),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text("Settings",
            style: TextStyle(color: _darkMode ? Colors.white : Colors.white)),
        iconTheme: IconThemeData(color: _darkMode ? Colors.white : Colors.white),
      ),
      body: Container(
        color: _darkMode ? Colors.black : Colors.grey[100],
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionHeader("Appearance"),
            _buildDarkModeToggle(), // Add this
            _buildSectionHeader("Accessibility"),
            _buildGestureToggle(),
            _buildSectionHeader("Voice Settings"),
            _buildVoiceSelection(),
            _buildSpeechRateSlider(),
            _buildVolumeSlider(),
            _buildPitchSlider(),
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

  Widget _buildGestureToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SwitchListTile(
        title: Text("Gesture Controls", style: TextStyle(color: Colors.white)),
        subtitle: Text("Enable swipe and tap gestures for navigation",
            style: TextStyle(color: Colors.white54)),
        value: _gesturesEnabled,
        onChanged: (value) {
          setState(() => _gesturesEnabled = value);
          widget.onGestureStateChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
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

  Widget _buildSlider(String title, double value, double min, double max,
      ValueChanged<double> onChanged, String label) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$title: $label", style: TextStyle(color: Colors.white)),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min) ~/ 0.1,
              label: label,
              activeColor: Color(0xff6a1b9a),
              inactiveColor: Colors.grey[800],
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}