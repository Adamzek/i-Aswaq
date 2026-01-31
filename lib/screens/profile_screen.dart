import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea keeps content away from the camera notch
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
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
                      // TODO: Navigate to settings screen
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 2. The User Info Card (Cream colored box)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E7), // Light cream color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // The 'A' Avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFF2D06B).withValues(alpha: 0.3),
                          child: const Text("A", style: TextStyle(fontSize: 30, color: Color(0xFFD4A017))),
                        ),
                        const SizedBox(width: 15),
                        // Name and Email
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ahmad Faisal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //
                            Text("ahmad.faisal@live.iium.edu.my", style: TextStyle(color: Colors.grey, fontSize: 13)), // 
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to edit profile screen
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFD4A017)),
                        label: const Text("Edit Profile", style: TextStyle(color: Color(0xFFD4A017))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD4A017)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 3. Stats Row (The 3 small cards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("3", "Active Listings"),
                  _buildStatCard("12", "Items Sold"),
                  _buildStatCard("2024", "Member Since"),
                ],
              ),
              const SizedBox(height: 30),

              // 4. Menu Items
              const Text("My Activity", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                child: Column(
                  children: [
                    _buildMenuTile(Icons.inventory_2_outlined, "My Listings", "3", () {
                      // TODO: Navigate to my listings screen
                    }),
                    _buildMenuTile(Icons.favorite_border, "Saved Items", "12", () {
                      // TODO: Navigate to saved items screen
                    }),
                    _buildMenuTile(Icons.history, "Purchase History", "", () {
                      // TODO: Navigate to purchase history screen
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 5. Settings Section
              const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                child: Column(
                  children: [
                    _buildMenuTile(Icons.edit_outlined, "Edit Profile", "", () {
                      // TODO: Navigate to edit profile screen
                    }),
                    _buildMenuTile(Icons.notifications_outlined, "Notifications", "", () {
                      // TODO: Navigate to notifications settings screen
                    }),
                    _buildMenuTile(Icons.shield_outlined, "Privacy & Safety", "", () {
                      // TODO: Navigate to privacy & safety screen
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 6. About Section
              const Text("About", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                child: Column(
                  children: [
                    _buildMenuTile(Icons.description_outlined, "Terms & Conditions", "", () {
                      // TODO: Navigate to terms & conditions screen
                    }),
                    _buildMenuTile(Icons.help_outline, "Contact Support", "", () {
                      // TODO: Navigate to contact support screen
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 7. Logout Button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Show logout confirmation dialog and handle logout
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Logout", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // A helper function to create those 3 small white cards
  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD4A017))),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // A helper function to create the list rows (My Listings, etc.)
  Widget _buildMenuTile(IconData icon, String title, String trailing, VoidCallback onTap) {
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
            decoration: BoxDecoration(color: const Color(0xFFFFF9E7), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFFD4A017)),
          ),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing.isNotEmpty) Text(trailing, style: const TextStyle(color: Colors.grey)),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}