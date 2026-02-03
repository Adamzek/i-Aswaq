import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'terms_and_conditions_screen.dart';
import 'contact_support_screen.dart';
import '../../auth/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  
  // Profile picture
  File? _profileImage;
  bool _isUploadingImage = false;
  
  // Profile settings
  final TextEditingController _nameController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _messageNotifications = true;
  bool _listingUpdates = true;

  // Privacy settings
  bool _showEmail = false;
  bool _showPhone = true;
  bool _showActiveStatus = true;
  String _profileVisibility = 'Public';

  // Track changes
  bool _hasProfileChanges = false;
  bool _hasNotificationChanges = false;
  bool _hasPrivacyChanges = false;

  // Original values for reset
  late String _originalName;
  late String _originalEmail;
  late String _originalPhone;
  late bool _originalPushNotifications;
  late bool _originalEmailNotifications;
  late bool _originalMessageNotifications;
  late bool _originalListingUpdates;
  late bool _originalShowEmail;
  late bool _originalShowPhone;
  late bool _originalShowActiveStatus;
  late String _originalProfileVisibility;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSettings();

    // Listen to text field changes
    _nameController.addListener(_checkProfileChanges);
    _emailController.addListener(_checkProfileChanges);
    _phoneController.addListener(_checkProfileChanges);
  }
  
  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      // Load email from Firebase (email is always available)
      _emailController.text = user.email ?? '';
      
      // Display name and phone would typically be stored in Firestore
      // For now, we leave them empty as per user's request
      _nameController.text = user.displayName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
    
    // Store original profile values
    _originalName = _nameController.text;
    _originalEmail = _emailController.text;
    _originalPhone = _phoneController.text;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load notification settings
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _emailNotifications = prefs.getBool('emailNotifications') ?? false;
      _messageNotifications = prefs.getBool('messageNotifications') ?? true;
      _listingUpdates = prefs.getBool('listingUpdates') ?? true;

      // Load privacy settings
      _showEmail = prefs.getBool('showEmail') ?? false;
      _showPhone = prefs.getBool('showPhone') ?? true;
      _showActiveStatus = prefs.getBool('showActiveStatus') ?? true;
      _profileVisibility = prefs.getString('profileVisibility') ?? 'Public';

      // Store original values
      _originalPushNotifications = _pushNotifications;
      _originalEmailNotifications = _emailNotifications;
      _originalMessageNotifications = _messageNotifications;
      _originalListingUpdates = _listingUpdates;
      _originalShowEmail = _showEmail;
      _originalShowPhone = _showPhone;
      _originalShowActiveStatus = _showActiveStatus;
      _originalProfileVisibility = _profileVisibility;
    });
  }

  Future<void> _saveNotificationSettingsToPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', _pushNotifications);
    await prefs.setBool('emailNotifications', _emailNotifications);
    await prefs.setBool('messageNotifications', _messageNotifications);
    await prefs.setBool('listingUpdates', _listingUpdates);
  }

  Future<void> _savePrivacySettingsToPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showEmail', _showEmail);
    await prefs.setBool('showPhone', _showPhone);
    await prefs.setBool('showActiveStatus', _showActiveStatus);
    await prefs.setString('profileVisibility', _profileVisibility);
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _isUploadingImage = true;
        });

        // Here you would upload to Firebase Storage
        // For now, we'll just show success message
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _isUploadingImage = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully'),
              backgroundColor: Color(0xFFD4A017),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _auth.signOut();
        if (mounted) {
          // Navigate to login screen and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: Implement account deletion logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion feature coming soon'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _checkProfileChanges() {
    setState(() {
      _hasProfileChanges = _nameController.text != _originalName ||
          _emailController.text != _originalEmail ||
          _phoneController.text != _originalPhone;
    });
  }

  void _checkNotificationChanges() {
    setState(() {
      _hasNotificationChanges =
          _pushNotifications != _originalPushNotifications ||
              _emailNotifications != _originalEmailNotifications ||
              _messageNotifications != _originalMessageNotifications ||
              _listingUpdates != _originalListingUpdates;
    });
  }

  void _checkPrivacyChanges() {
    setState(() {
      _hasPrivacyChanges = _showEmail != _originalShowEmail ||
          _showPhone != _originalShowPhone ||
          _showActiveStatus != _originalShowActiveStatus ||
          _profileVisibility != _originalProfileVisibility;
    });
  }

  void _saveProfileSettings() async {
    // Save profile settings to Firebase
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Update display name in Firebase Auth
        if (_nameController.text != user.displayName) {
          await user.updateDisplayName(_nameController.text);
        }
        
        // Note: You would typically save phone number to Firestore
        // as Firebase Auth phone number requires separate verification
        
        setState(() {
          _originalName = _nameController.text;
          _originalEmail = _emailController.text;
          _originalPhone = _phoneController.text;
          _hasProfileChanges = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile settings saved successfully'),
              backgroundColor: Color(0xFFD4A017),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _resetProfileSettings() {
    setState(() {
      _nameController.text = _originalName;
      _emailController.text = _originalEmail;
      _phoneController.text = _originalPhone;
      _hasProfileChanges = false;
    });
  }

  Future<void> _saveNotificationSettings() async {
    await _saveNotificationSettingsToPersistence();
    setState(() {
      _originalPushNotifications = _pushNotifications;
      _originalEmailNotifications = _emailNotifications;
      _originalMessageNotifications = _messageNotifications;
      _originalListingUpdates = _listingUpdates;
      _hasNotificationChanges = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved successfully'),
          backgroundColor: Color(0xFFD4A017),
        ),
      );
    }
  }

  void _resetNotificationSettings() {
    setState(() {
      _pushNotifications = _originalPushNotifications;
      _emailNotifications = _originalEmailNotifications;
      _messageNotifications = _originalMessageNotifications;
      _listingUpdates = _originalListingUpdates;
      _hasNotificationChanges = false;
    });
  }

  Future<void> _savePrivacySettings() async {
    await _savePrivacySettingsToPersistence();
    setState(() {
      _originalShowEmail = _showEmail;
      _originalShowPhone = _showPhone;
      _originalShowActiveStatus = _showActiveStatus;
      _originalProfileVisibility = _profileVisibility;
      _hasPrivacyChanges = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Privacy settings saved successfully'),
          backgroundColor: Color(0xFFD4A017),
        ),
      );
    }
  }

  void _resetPrivacySettings() {
    setState(() {
      _showEmail = _originalShowEmail;
      _showPhone = _originalShowPhone;
      _showActiveStatus = _originalShowActiveStatus;
      _profileVisibility = _originalProfileVisibility;
      _hasPrivacyChanges = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFFF2D06B).withValues(alpha: 0.3),
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text[0].toUpperCase()
                                      : _emailController.text.isNotEmpty
                                          ? _emailController.text[0].toUpperCase()
                                          : 'U',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Color(0xFFD4A017),
                                  ),
                                )
                              : null,
                        ),
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFD4A017),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploadingImage ? null : _pickProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4A017),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _isUploadingImage ? null : _pickProfileImage,
                      child: const Text(
                        'Change Profile Picture',
                        style: TextStyle(
                          color: Color(0xFFD4A017),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Profile Settings Section
              _buildSectionHeader('Profile Settings'),
              const SizedBox(height: 15),
              _buildProfileSection(),
              const SizedBox(height: 30),

              // Notification Settings Section
              _buildSectionHeader('Notifications'),
              const SizedBox(height: 15),
              _buildNotificationSection(),
              const SizedBox(height: 30),

              // Privacy & Safety Section
              _buildSectionHeader('Privacy & Safety'),
              const SizedBox(height: 15),
              _buildPrivacySection(),
              const SizedBox(height: 30),

              // About Section
              _buildSectionHeader('About'),
              const SizedBox(height: 15),
              _buildAboutSection(),
              const SizedBox(height: 30),

              // Logout and Delete Account Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                      label: const Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Full Name',
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Email',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Phone Number',
            controller: _phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          if (_hasProfileChanges) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetProfileSettings,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfileSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications on your device',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
                _checkNotificationChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
                _checkNotificationChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Message Notifications',
            subtitle: 'Get notified about new messages',
            value: _messageNotifications,
            onChanged: (value) {
              setState(() {
                _messageNotifications = value;
                _checkNotificationChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Listing Updates',
            subtitle: 'Notifications about your listings',
            value: _listingUpdates,
            onChanged: (value) {
              setState(() {
                _listingUpdates = value;
                _checkNotificationChanges();
              });
            },
          ),
          if (_hasNotificationChanges) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetNotificationSettings,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNotificationSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Visibility',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _buildRadioTile(
            title: 'Public',
            subtitle: 'Anyone can see your profile',
            value: 'Public',
            groupValue: _profileVisibility,
            onChanged: (value) {
              setState(() {
                _profileVisibility = value!;
                _checkPrivacyChanges();
              });
            },
          ),
          _buildRadioTile(
            title: 'Private',
            subtitle: 'Only you can see your profile',
            value: 'Private',
            groupValue: _profileVisibility,
            onChanged: (value) {
              setState(() {
                _profileVisibility = value!;
                _checkPrivacyChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Show Email',
            subtitle: 'Display email on your public profile',
            value: _showEmail,
            onChanged: (value) {
              setState(() {
                _showEmail = value;
                _checkPrivacyChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Show Phone Number',
            subtitle: 'Display phone number on your profile',
            value: _showPhone,
            onChanged: (value) {
              setState(() {
                _showPhone = value;
                _checkPrivacyChanges();
              });
            },
          ),
          const Divider(height: 30),
          _buildSwitchTile(
            title: 'Show Active Status',
            subtitle: 'Let others see when you\'re online',
            value: _showActiveStatus,
            onChanged: (value) {
              setState(() {
                _showActiveStatus = value;
                _checkPrivacyChanges();
              });
            },
          ),
          if (_hasPrivacyChanges) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetPrivacySettings,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePrivacySettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Contact Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactSupportScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'App Version',
            trailing: '1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFD4A017)),
            filled: true,
            fillColor: const Color(0xFFFFF9E7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD4A017),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFD4A017),
        ),
      ],
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFFD4A017),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
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

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFD4A017)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              if (trailing == null)
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
