import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool>? onDarkModeChanged;
  final File? initialProfileImage; // Add this


  const ProfileScreen({
    Key? key,
    required this.darkMode,
    this.onDarkModeChanged,
    this.initialProfileImage, // Add this

  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // User data
  String _name = "Loading...";
  String _email = "Loading...";
  String _blindnessLevel = "Partially Sighted";
  int _age = 23;
  String _gender = "Male";
  String _preferredLanguage = "English";
  bool _isEditing = false;
  bool _voiceGuidance = true;
  bool _highContrast = false;


  @override
  void initState() {
    super.initState();
    _profileImage = widget.initialProfileImage; // Initialize with passed image

    _loadUserData();

  }
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Force refresh
      final refreshedUser = FirebaseAuth.instance.currentUser;

      setState(() {
        _name = refreshedUser?.displayName ?? "User";
        _email = refreshedUser?.email ?? "No email";
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }
  void _toggleEditing() async {
    if (_isEditing && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.currentUser?.updateProfile(
          displayName: _name,
        );
        await FirebaseAuth.instance.currentUser?.reload();
        _loadUserData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: widget.darkMode ? Color(0xff6a1b9a) : Color(0xff281537),
            ),
          );

          // Return the profile image when navigating back
          Navigator.pop(context, _profileImage);
          return;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.darkMode ? Colors.black : Colors.grey[100];
    final primaryColor = widget.darkMode ? Color(0xff281537) : Color(0xff6a1b9a);
    final cardColor = widget.darkMode ? Color(0xff1a0d24) : Colors.white;
    final textColor = widget.darkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: _toggleEditing,
            color: Colors.white,
            tooltip: _isEditing ? 'Save' : 'Edit',
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture with Edit Button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 24),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: _profileImage != null
                            ? ClipOval(
                          child: Image.file(
                            _profileImage!,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 70,
                          color: primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 20,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Personal Information Card
                Card(
                  color: cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildEditableField(
                          label: "Full Name",
                          value: _name,
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.person_outline,
                          onSaved: (value) => _name = value!,
                        ),
                        _buildDivider(),
                        _buildEditableField(
                          label: "Email",
                          value: _email,
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email = value!,
                        ),
                        _buildDivider(),
                        _buildDropdownField(
                          label: "Blindness Level",
                          value: _blindnessLevel,
                          items: ["Fully Blind", "Partially Sighted", "Low Vision", "Not Blind"],
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.visibility_outlined,
                          onChanged: (value) => setState(() => _blindnessLevel = value!),
                        ),
                        _buildDivider(),
                        _buildEditableField(
                          label: "Age",
                          value: _age.toString(),
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.cake_outlined,
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _age = int.parse(value!),
                        ),
                        _buildDivider(),
                        _buildDropdownField(
                          label: "Gender",
                          value: _gender,
                          items: ["Male", "Female"],
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.transgender,
                          onChanged: (value) => setState(() => _gender = value!),
                        ),
                        _buildDivider(),
                        _buildDropdownField(
                          label: "Preferred Language",
                          value: _preferredLanguage,
                          items: ["English", "Amharic", "Oromo", "Tigrinya", "Other"],
                          isEditing: _isEditing,
                          textColor: textColor,
                          icon: Icons.language,
                          onChanged: (value) => setState(() => _preferredLanguage = value!),
                        ),
                      ],
                    ),
                  ),
                ),

                // Accessibility Preferences Card
                Card(
                  color: cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.accessibility_new,
                                color: primaryColor,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Accessibility Preferences",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildSwitchTile(
                          title: "Dark Mode",
                          value: widget.darkMode,
                          icon: Icons.dark_mode_outlined,
                          onChanged: _isEditing ? (value) {
                            widget.onDarkModeChanged?.call(value);
                          } : null,
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          title: "Voice Guidance",
                          value: _voiceGuidance,
                          icon: Icons.volume_up_outlined,
                          onChanged: _isEditing ? (value) {
                            setState(() => _voiceGuidance = value);
                          } : null,
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
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 24,
      thickness: 1,
      color: widget.darkMode ? Colors.grey[800] : Colors.grey[200],
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required bool isEditing,
    required Color textColor,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.6),
          size: 24,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              isEditing
                  ? TextFormField(
                initialValue: value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                onSaved: onSaved,
              )
                  : Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required bool isEditing,
    required Color textColor,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.6),
          size: 24,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              isEditing
                  ? DropdownButtonFormField<String>(
                value: value,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                dropdownColor: widget.darkMode ? Color(0xff1a0d24) : Colors.white,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: textColor.withOpacity(0.6),
                ),
              )
                  : Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required IconData icon,
    required ValueChanged<bool>? onChanged,
  }) {
    final textColor = widget.darkMode ? Colors.white : Colors.black87;

    return Row(
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.6),
          size: 24,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.9,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: widget.darkMode ? Color(0xff6a1b9a) : Color(0xff543378),
            activeTrackColor: widget.darkMode ? Color(0xff6a1b9a).withOpacity(0.5) : Color(0xff543378).withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}