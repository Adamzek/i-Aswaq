import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    User? currentUser = FirebaseAuth.instance.currentUser;
    String userName = currentUser?.email?.split('@').first ?? 'User';
    String userEmail = currentUser?.email ?? 'No email';
    String userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 2. The User Info Card (Cream colored box)
              _buildUserInfoCard(screenWidth, userName, userEmail, userInitial),
              const SizedBox(height: 25),

              // 3. Stats Row (The 3 small cards)
              _buildStatsRow(screenWidth),
              const SizedBox(height: 30),

              // 4. Menu Items
              _buildSection(
                title: 'My Activity',
                children: [
                  _buildMenuTile(
                    Icons.inventory_2_outlined,
                    'My Listings',
                    '3',
                    () {},
                  ),
                  _buildMenuTile(
                    Icons.favorite_border,
                    'Saved Items',
                    '12',
                    () {},
                  ),
                  _buildMenuTile(
                    Icons.history,
                    'Purchase History',
                    '',
                    () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildSection(
                title: 'Settings',
                children: [
                  _buildMenuTile(
                    Icons.edit_outlined,
                    'Edit Profile',
                    '',
                    () {},
                  ),
                  _buildMenuTile(
                    Icons.notifications_outlined,
                    'Notifications',
                    '',
                    () {},
                  ),
                  _buildMenuTile(
                    Icons.shield_outlined,
                    'Privacy & Safety',
                    '',
                    () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildSection(
                title: 'About',
                children: [
                  _buildMenuTile(
                    Icons.description_outlined,
                    'Terms & Conditions',
                    '',
                    () {},
                  ),
                  _buildMenuTile(
                    Icons.help_outline,
                    'Contact Support',
                    '',
                    () {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(double screenWidth, String userName, String userEmail, String userInitial) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // The Avatar with user initial
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFF2D06B).withValues(alpha: 0.3),
                child: Text(
                  userInitial,
                  style: const TextStyle(fontSize: 30, color: Color(0xFFD4A017)),
                ),
              ),
              const SizedBox(width: 15),
              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFFD4A017),
              ),
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Color(0xFFD4A017)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD4A017)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(double screenWidth) {
    final isSmallScreen = screenWidth < 350;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildStatCard('3', 'Active\nListings', isSmallScreen),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: _buildStatCard('12', 'Items\nSold', isSmallScreen),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: _buildStatCard('2024', 'Member\nSince', isSmallScreen),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 15 : 20,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4A017),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              color: Colors.grey,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    String trailing,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withValues(alpha: 0.2),
        highlightColor: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFD4A017)),
          ),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing.isNotEmpty)
                Text(
                  trailing,
                  style: const TextStyle(color: Colors.grey),
                ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}