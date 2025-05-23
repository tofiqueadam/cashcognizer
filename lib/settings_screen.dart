import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'screen_reader_helper.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialGestureState;
  final double initialSpeechRate;
  final double initialVolume;
  final double initialPitch;
  final List<Map<String, String>> availableVoices;
  final String initialVoice;
  final bool initialVoiceGuidance;
  final bool initialHighContrast;
  final String initialLanguage;
  final ValueChanged<bool>? onGestureStateChanged;
  final ValueChanged<double>? onSpeechRateChanged;
  final ValueChanged<double>? onVolumeChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<Map<String, String>>? onVoiceChanged;
  final ValueChanged<bool>? onVoiceGuidanceChanged;
  final ValueChanged<bool>? onHighContrastChanged;
  final ValueChanged<String>? onLanguageChanged;

  final bool initialScreenReaderEnabled;

  const SettingsScreen({
    Key? key,
    required this.initialGestureState,
    this.initialSpeechRate = 0.5,
    this.initialVolume = 1.0,
    this.initialPitch = 1.0,
    required this.availableVoices,
    required this.initialVoice,
    this.initialVoiceGuidance = true,
    this.initialHighContrast = false,
    this.initialLanguage = "English",
    this.onGestureStateChanged,
    this.onSpeechRateChanged,
    this.onVolumeChanged,
    this.onPitchChanged,
    this.onVoiceChanged,
    this.onVoiceGuidanceChanged,
    this.onHighContrastChanged,
    this.onLanguageChanged,
    this.initialScreenReaderEnabled = true,
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
  late bool _screenReaderEnabled;
  late bool _largeText;
  late bool _voiceGuidance;
  late bool _highContrast;
  late String _language;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _gesturesEnabled = widget.initialGestureState;
    _speechRate = widget.initialSpeechRate;
    _volume = widget.initialVolume;
    _pitch = widget.initialPitch;
    _selectedVoice = widget.initialVoice;
    _voiceGuidance = widget.initialVoiceGuidance;
    _highContrast = widget.initialHighContrast;
    _language = widget.initialLanguage;
    _largeText = false;

    _screenReaderEnabled = widget.initialScreenReaderEnabled;
    flutterTts = FlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final textColor = settingsProvider.darkMode ? Colors.white : Colors.black;
    final cardColor = settingsProvider.darkMode ? const Color(0xff1a0d24) : Colors.grey[200]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingsProvider.darkMode ? const Color(0xff281537) : const Color(0xff6a1b9a),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: _largeText ? 22 : 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: settingsProvider.darkMode ? Colors.black : Colors.grey[100],
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionHeader("Appearance", textColor),
            _buildDarkModeToggle(settingsProvider, cardColor),
            _buildLargeTextToggle(settingsProvider, cardColor),

            _buildSectionHeader("Voice Settings", textColor),
            if (widget.availableVoices.isNotEmpty)
              _buildVoiceSelection(settingsProvider, cardColor, textColor),
            _buildSpeechRateSlider(settingsProvider, cardColor, textColor),
            _buildVolumeSlider(settingsProvider, cardColor, textColor),
            _buildPitchSlider(settingsProvider, cardColor, textColor),


            _buildSectionHeader("Accessibility", textColor),
            _buildGestureToggle(),
            _buildVoiceGuidanceToggle(),
            _buildScreenReaderToggle(settingsProvider, cardColor),
            _buildHighContrastToggle(settingsProvider, cardColor),


            _buildSectionHeader("Actions", textColor),
            _buildResetSettingsButton(settingsProvider, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: textColor.withOpacity(0.8),
          fontSize: _largeText ? 18 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildVoiceGuidanceToggle() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: settingsProvider.darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Semantics(
        label: "Voice guidance toggle",
        child: SwitchListTile(
          title: Text(
            "Voice Guidance",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: _voiceGuidance,
          onChanged: (value) {
            setState(() => _voiceGuidance = value);
            widget.onVoiceGuidanceChanged?.call(value);
            if (settingsProvider.screenReaderEnabled) {
              ScreenReaderHelper.readContent(
                  value ? "Voice guidance enabled" : "Voice guidance disabled"
              );
            }
          },
          activeColor: Color(0xff6a1b9a),
        ),
      ),
    );
  }

  Widget _buildScreenReaderToggle(SettingsProvider settingsProvider, Color cardColor) {
    return Semantics(
      label: "Screen reader toggle",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SwitchListTile(
          title: Text(
            "Screen Reader",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: settingsProvider.screenReaderEnabled,
          onChanged: (value) {
            setState(() {
              settingsProvider.setScreenReaderEnabled(value);
              if (value) {
                ScreenReaderHelper.readContent("Screen reader enabled");
              } else {
                ScreenReaderHelper.stop();
                ScreenReaderHelper.readContent("Screen reader disabled", force: true);
              }
            });
          },
          activeColor: const Color(0xff6a1b9a),
        ),
      ),
    );
  }

  Widget _buildLargeTextToggle(SettingsProvider settingsProvider, Color cardColor) {
    return Semantics(
      label: "Large text toggle",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SwitchListTile(
          title: Text(
            "Large Text",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: _largeText,
          onChanged: (value) {
            setState(() => _largeText = value);
            if (settingsProvider.screenReaderEnabled) {
              ScreenReaderHelper.readContent(
                  value ? "Large text enabled" : "Large text disabled"
              );
            }
          },
          activeColor: const Color(0xff6a1b9a),
        ),
      ),
    );
  }

  Widget _buildHighContrastToggle(SettingsProvider settingsProvider, Color cardColor) {
    return Semantics(
      label: "High contrast mode toggle",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SwitchListTile(
          title: Text(
            "High Contrast Mode",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: false, // Placeholder - implement your high contrast logic
          onChanged: (value) {
            if (settingsProvider.screenReaderEnabled) {
              ScreenReaderHelper.readContent(
                  value ? "High contrast mode enabled" : "High contrast mode disabled"
              );
            }
          },
          activeColor: const Color(0xff6a1b9a),
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle(SettingsProvider settingsProvider, Color cardColor) {
    return Semantics(
      label: "Dark mode toggle",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SwitchListTile(
          title: Text(
            "Dark Mode",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: settingsProvider.darkMode,
          onChanged: (value) {
            settingsProvider.setDarkMode(value);
            if (settingsProvider.screenReaderEnabled) {
              ScreenReaderHelper.readContent(
                  value ? "Dark mode enabled" : "Dark mode disabled"
              );
            }
          },
          activeColor: const Color(0xff6a1b9a),
        ),
      ),
    );
  }

  Widget _buildGestureToggle() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: settingsProvider.darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Semantics(
        label: "Gesture controls toggle",
        child: SwitchListTile(
          title: Text(
            "Gesture Controls",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          value: _gesturesEnabled,
          onChanged: (value) {
            setState(() => _gesturesEnabled = value);
            widget.onGestureStateChanged?.call(value);
            if (settingsProvider.screenReaderEnabled) {
              ScreenReaderHelper.readContent(
                  value ? "Gesture controls enabled" : "Gesture controls disabled"
              );
            }
          },
          activeColor: Color(0xff6a1b9a),
        ),
      ),
    );
  }


  Widget _buildVoiceSelection(SettingsProvider settingsProvider, Color cardColor, Color textColor) {
    final currentVoice = widget.availableVoices.firstWhere(
          (voice) => voice['name'] == _selectedVoice,
      orElse: () => widget.availableVoices.first,
    );

    return Semantics(
      label: "Voice selection dropdown",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Voice Type",
                style: TextStyle(
                  color: textColor,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Map<String, String>>(
                dropdownColor: settingsProvider.darkMode ? const Color(0xff281537) : Colors.white,
                value: currentVoice,
                items: widget.availableVoices.map((voice) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: voice,
                    child: Text(
                      "${voice['name']} (${voice['locale'] == 'simulated' ? 'Simulated' : voice['locale']})",
                      style: TextStyle(
                        color: textColor,
                        fontSize: _largeText ? 18 : 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedVoice = value['name']!);
                    flutterTts.setVoice({
                      'name': value['name']!,
                      'locale': value['locale']!,
                    });
                    if (settingsProvider.screenReaderEnabled) {
                      ScreenReaderHelper.readContent(
                          "Voice changed to ${value['name']}"
                      );
                    }
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff6a1b9a)),
                  ),
                  filled: true,
                  fillColor: settingsProvider.darkMode ? const Color(0xff281537) : Colors.white,
                ),
                style: TextStyle(
                  color: textColor,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechRateSlider(SettingsProvider settingsProvider, Color cardColor, Color textColor) {
    return Semantics(
      label: "Speech rate slider",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Speech Rate: ${_speechRate.toStringAsFixed(1)}x",
                style: TextStyle(
                  color: textColor,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
              Slider(
                value: _speechRate,
                min: 0.3,
                max: 1.0,
                divisions: 7,
                label: "${_speechRate.toStringAsFixed(1)}x",
                activeColor: const Color(0xff6a1b9a),
                inactiveColor: settingsProvider.darkMode ? Colors.grey[800] : Colors.grey[400],
                onChanged: (value) {
                  setState(() => _speechRate = value);
                  if (settingsProvider.screenReaderEnabled) {
                    ScreenReaderHelper.readContent(
                        "Speech rate set to ${value.toStringAsFixed(1)}",
                        force: true
                    );
                  }
                },
                onChangeEnd: (value) {
                  flutterTts.setSpeechRate(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(SettingsProvider settingsProvider, Color cardColor, Color textColor) {
    return Semantics(
      label: "Volume slider",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Volume: ${(_volume * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: textColor,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
              Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: "${(_volume * 100).toStringAsFixed(0)}%",
                activeColor: const Color(0xff6a1b9a),
                inactiveColor: settingsProvider.darkMode ? Colors.grey[800] : Colors.grey[400],
                onChanged: (value) {
                  setState(() => _volume = value);
                  if (settingsProvider.screenReaderEnabled) {
                    ScreenReaderHelper.readContent(
                        "Volume set to ${(value * 100).toStringAsFixed(0)} percent",
                        force: true
                    );
                  }
                },
                onChangeEnd: (value) {
                  flutterTts.setVolume(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPitchSlider(SettingsProvider settingsProvider, Color cardColor, Color textColor) {
    return Semantics(
      label: "Pitch slider",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pitch: ${_pitch.toStringAsFixed(1)}",
                style: TextStyle(
                  color: textColor,
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
              Slider(
                value: _pitch,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                label: _pitch.toStringAsFixed(1),
                activeColor: const Color(0xff6a1b9a),
                inactiveColor: settingsProvider.darkMode ? Colors.grey[800] : Colors.grey[400],
                onChanged: (value) {
                  setState(() => _pitch = value);
                  if (settingsProvider.screenReaderEnabled) {
                    ScreenReaderHelper.readContent(
                        "Pitch set to ${value.toStringAsFixed(1)}",
                        force: true
                    );
                  }
                },
                onChangeEnd: (value) {
                  flutterTts.setPitch(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetSettingsButton(SettingsProvider settingsProvider, Color cardColor) {
    return Semantics(
      button: true,
      label: "Reset settings button",
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(
            Icons.restore,
            color: settingsProvider.darkMode ? Colors.white70 : Colors.black54,
          ),
          title: Text(
            "Reset to Default Settings",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          onTap: () {
            _showResetConfirmationDialog(settingsProvider);
          },
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset Settings",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              fontSize: _largeText ? 20 : 18,
            ),
          ),
          content: Text(
            "Are you sure you want to reset all settings to their default values?",
            style: TextStyle(
              color: settingsProvider.darkMode ? Colors.white70 : Colors.black54,
              fontSize: _largeText ? 18 : 16,
            ),
          ),
          backgroundColor: settingsProvider.darkMode ? const Color(0xff1a0d24) : Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (settingsProvider.screenReaderEnabled) {
                  ScreenReaderHelper.readContent("Reset cancelled");
                }
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: const Color(0xff6a1b9a),
                  fontSize: _largeText ? 18 : 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetAllSettings(settingsProvider);
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

  void _resetAllSettings(SettingsProvider settingsProvider) {
    setState(() {
      _speechRate = 0.5;
      _volume = 1.0;
      _pitch = 1.0;
      settingsProvider.setDarkMode(false); // Use the setter method instead
      _largeText = false;
      _selectedVoice = widget.availableVoices.isNotEmpty
          ? widget.availableVoices.first['name']!
          : "";
    });

    settingsProvider.setScreenReaderEnabled(true);
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    if (widget.availableVoices.isNotEmpty) {
      flutterTts.setVoice({
        'name': widget.availableVoices.first['name']!,
        'locale': widget.availableVoices.first['locale']!,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All settings have been reset to default'),
        backgroundColor: settingsProvider.darkMode ? const Color(0xff6a1b9a) : const Color(0xff281537),
      ),
    );

    if (settingsProvider.screenReaderEnabled) {
      ScreenReaderHelper.readContent("Settings have been reset to default values");
    }
  }
}