import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialGestureState;
  final double initialSpeechRate;
  final double initialVolume;
  final double initialPitch;
  final Map<String, String> availableVoices;
  final String initialVoice;

  final ValueChanged<bool>? onGestureStateChanged;
  final ValueChanged<double>? onSpeechRateChanged;
  final ValueChanged<double>? onVolumeChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<String>? onVoiceChanged;


  const SettingsScreen({
    Key? key,
    required this.initialGestureState,
    this.initialSpeechRate = 0.5,
    this.initialVolume = 1.0,
    this.initialPitch = 1.0,
    required this.availableVoices,
    required this.initialVoice,
    this.onGestureStateChanged,
    this.onSpeechRateChanged,
    this.onVolumeChanged,
    this.onPitchChanged,
    this.onVoiceChanged,

  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  late bool _gesturesEnabled;
  late double _speechRate;
  late double _volume;
  late double _pitch;
  late String _selectedVoice;

  @override
  void initState() {
    super.initState();
    _gesturesEnabled = widget.initialGestureState;
    _speechRate = widget.initialSpeechRate;
    _volume = widget.initialVolume;
    _pitch = widget.initialPitch;
    _selectedVoice = widget.initialVoice;

  }

  Widget _buildVoiceSelection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Voice Type",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              dropdownColor: Color(0xff281537),
              value: _selectedVoice,
              items: widget.availableVoices.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedVoice = value);
                  widget.onVoiceChanged?.call(value);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xff6a1b9a)),
                ),
                enabledBorder: OutlineInputBorder(
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff281537),
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff281537),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionHeader("Accessibility"),
            _buildGestureToggle(),
            _buildDarkModeToggle(),
            _buildSectionHeader("Voice Settings"),
            _buildSpeechRateSlider(),
            _buildVolumeSlider(),
            _buildPitchSlider(),
            _buildSectionHeader("Appearance"),
            _buildThemeOptions(),
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
          color: Colors.white70,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        title: Text(
          "Gesture Controls",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Text(
          "Enable swipe and tap gestures for navigation",
          style: TextStyle(color: Colors.white54),
        ),
        value: _gesturesEnabled,
        onChanged: (value) {
          setState(() {
            _gesturesEnabled = value;
          });
          widget.onGestureStateChanged?.call(value);
        },
        activeColor: Color(0xff6a1b9a),
        inactiveThumbColor: Colors.grey[600],
        inactiveTrackColor: Colors.grey[800],
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        title: Text(
          "Dark Mode",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Text(
          "Switch between light and dark theme",
          style: TextStyle(color: Colors.white54),
        ),
        value: isDarkMode,
        onChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
        activeColor: Color(0xff6a1b9a),
        inactiveThumbColor: Colors.grey[600],
        inactiveTrackColor: Colors.grey[800],
      ),
    );
  }

  Widget _buildSpeechRateSlider() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Speech Rate: ${_speechRate.toStringAsFixed(1)}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _speechRate,
              min: 0.3,
              max: 1.0,
              divisions: 7,
              label: _speechRate.toStringAsFixed(1),
              activeColor: Color(0xff6a1b9a),
              inactiveColor: Colors.grey[800],
              onChanged: (value) {
                setState(() {
                  _speechRate = value;
                });
                widget.onSpeechRateChanged?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Volume: ${(_volume * 100).toStringAsFixed(0)}%",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: (_volume * 100).toStringAsFixed(0),
              activeColor: Color(0xff6a1b9a),
              inactiveColor: Colors.grey[800],
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                widget.onVolumeChanged?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPitchSlider() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pitch: ${_pitch.toStringAsFixed(1)}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _pitch,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: _pitch.toStringAsFixed(1),
              activeColor: Color(0xff6a1b9a),
              inactiveColor: Colors.grey[800],
              onChanged: (value) {
                setState(() {
                  _pitch = value;
                });
                widget.onPitchChanged?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptions() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Color(0xff1a0d24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Primary Color",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.white12),
          ListTile(
            title: Text(
              "Font Size",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}