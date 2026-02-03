import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Updated: February 3, 2026',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              _buildSection(
                title: '1. Acceptance of Terms',
                content:
                    'By accessing and using i-Aswaq, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these Terms & Conditions, please do not use this application.',
              ),
              _buildSection(
                title: '2. User Accounts',
                content:
                    'To use certain features of i-Aswaq, you must register for an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to:\n\n• Provide accurate and complete information during registration\n• Maintain and promptly update your account information\n• Notify us immediately of any unauthorized use of your account\n• Be responsible for all activities under your account',
              ),
              _buildSection(
                title: '3. Listing Items',
                content:
                    'When listing items for sale on i-Aswaq, you agree to:\n\n• Provide accurate descriptions and photos of items\n• Set fair and honest prices\n• Only list items you legally own and have the right to sell\n• Not list prohibited items (illegal goods, counterfeit items, etc.)\n• Comply with all applicable laws and regulations\n• Honor your commitments to buyers',
              ),
              _buildSection(
                title: '4. Purchases and Transactions',
                content:
                    'i-Aswaq serves as a platform to connect buyers and sellers. We are not responsible for:\n\n• The quality, safety, or legality of items listed\n• The accuracy of listings\n• The ability of sellers to complete sales\n• The ability of buyers to complete purchases\n\nAll transactions are between buyers and sellers directly. We recommend meeting in safe, public locations for exchanges.',
              ),
              _buildSection(
                title: '5. User Conduct',
                content:
                    'You agree not to:\n\n• Use the app for any illegal purposes\n• Harass, abuse, or harm other users\n• Post false, misleading, or fraudulent content\n• Attempt to gain unauthorized access to the app\n• Interfere with the proper functioning of the app\n• Use automated systems to access the app\n• Impersonate any person or entity',
              ),
              _buildSection(
                title: '6. Content and Intellectual Property',
                content:
                    'All content on i-Aswaq, including text, graphics, logos, and software, is the property of i-Aswaq or its licensors. Users retain ownership of content they post but grant i-Aswaq a license to use, display, and distribute such content within the app.',
              ),
              _buildSection(
                title: '7. Privacy',
                content:
                    'Your use of i-Aswaq is also governed by our Privacy Policy. By using the app, you consent to the collection and use of your information as outlined in the Privacy Policy.',
              ),
              _buildSection(
                title: '8. Termination',
                content:
                    'We reserve the right to suspend or terminate your account at any time, with or without notice, for any violation of these Terms & Conditions or for any other reason we deem appropriate.',
              ),
              _buildSection(
                title: '9. Limitation of Liability',
                content:
                    'i-Aswaq is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the app, including but not limited to direct, indirect, incidental, or consequential damages.',
              ),
              _buildSection(
                title: '10. Dispute Resolution',
                content:
                    'Any disputes arising from the use of i-Aswaq should be resolved through good faith negotiations. If negotiations fail, disputes will be subject to the laws and jurisdiction of Malaysia.',
              ),
              _buildSection(
                title: '11. Changes to Terms',
                content:
                    'We reserve the right to modify these Terms & Conditions at any time. Changes will be effective immediately upon posting. Your continued use of the app after changes constitutes acceptance of the modified terms.',
              ),
              _buildSection(
                title: '12. Contact Information',
                content:
                    'If you have any questions about these Terms & Conditions, please contact us through the Contact Support page in the app.',
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  '© 2026 i-Aswaq. All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4A017),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
