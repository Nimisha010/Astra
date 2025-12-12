/*import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header with Welcome and Security
              _buildHeader(),
              const SizedBox(height: 30),

              // 🔹 Main Features Grid
              _buildFeaturesGrid(context),
              const SizedBox(height: 30),

              // 🔹 Recent Checks Section
              _buildRecentChecks(),
              const SizedBox(height: 30),

              // 🔹 Safety Tips & News
              _buildSafetyTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WELCOME, USER!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your data is always secure and analyzed privately",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildFeatureCard(
          icon: Icons.photo_camera,
          title: "Verify image integrity",
          description:
              "Check photos for signs of digital manipulation or face morphing",
          buttonText: "Check image",
          onTap: () {
            // Navigate to image check screen
          },
          color: Colors.blue[50]!,
        ),
        _buildFeatureCard(
          icon: Icons.text_fields,
          title: "Analyze Text for Harm",
          description:
              "Paste messages or social media posts to detect harassment, threats or abuse",
          buttonText: "Analyze text",
          onTap: () {
            // Navigate to text analysis screen
          },
          color: Colors.green[50]!,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: onTap,
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChecks() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Checks",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckItem(
            "Image Check - Aug 15",
            "High Morph Risk",
            Icons.warning,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to full history
              },
              child: Text(
                "View Full History",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(
      String title, String subtitle, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Safety Tips & News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSafetyTipItem(
            "How to report abuse on Platform Astra?",
            Icons.lightbulb_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipItem(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }
}
*/

/*
//deepseek
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header with Welcome - CENTERED
              _buildHeader(),
              const SizedBox(height: 30),

              // 🔹 Main Features Grid with Scrollable Description
              _buildFeaturesGrid(context),
              const SizedBox(height: 30),

              // 🔹 Recent Checks Section (Conditional)
              _buildRecentChecks(),
              const SizedBox(height: 30),

              // 🔹 Safety Tips & News
              _buildSafetyTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Center(
      // Changed to Center
      child: Column(
        children: [
          Text(
            "WELCOME, USER!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Times New Roman',
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your data is always secure and analyzed privately",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildFeatureCard(
          icon: Icons.photo_camera,
          title: "Verify image integrity",
          description: "",
          //   "Check photos for signs of digital manipulation or face morphing. Upload images to detect any alterations or deepfake content that might compromise your safety.",
          buttonText: "Check image",
          onTap: () {
            _showimageinfo(context, "Image Verification");
          },
          color: Colors.blue[50]!,
        ),
        _buildFeatureCard(
          icon: Icons.text_fields,
          title: "Analyze Text for Harm",
          description: "",
          // "Paste messages or social media posts to detect harassment, threats or abuse. Our AI analyzes text for harmful content and provides safety recommendations.",
          buttonText: "Analyze text",
          onTap: () {
            _showtextinfo(context, "Text Analysis");
          },
          color: Colors.green[50]!,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // 🔹 Scrollable Description
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey[700], // Darker grey for better visibility
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: onTap,
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChecks() {
    // Sample data - in real app, this would come from your database
    final recentChecks = [
      _CheckItem(
        title: "Image Check - Aug 15",
        subtitle: "High Morph Risk - Suspicious alterations detected",
        icon: Icons.warning,
        color: Colors.orange,
        type: "image",
      ),
      // Add more sample data or keep empty based on user activity
    ];

    // Only show if there are recent checks
    if (recentChecks.isEmpty) {
      return const SizedBox.shrink(); // Hide section if no recent checks
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Checks",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // List of recent checks
          ...recentChecks.map((check) => Column(
                children: [
                  _buildCheckItem(
                      check.title, check.subtitle, check.icon, check.color),
                  if (recentChecks.last != check) const SizedBox(height: 12),
                ],
              )),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "View Full History",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(
      String title, String subtitle, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Safety Tips & News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSafetyTipItem(
            "How to report abuse on Platform Astra?",
            Icons.lightbulb_outline,
          ),
          const SizedBox(height: 8),
          _buildSafetyTipItem(
            "Emergency contacts for immediate help",
            Icons.emergency,
          ),
          const SizedBox(height: 8),
          _buildSafetyTipItem(
            "Privacy settings guide for social media",
            Icons.security,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipItem(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  void _showimageinfo(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName '),
        content: Text(
            'Check photos for signs of digital manipulation or face morphing. Upload images to detect any alterations or deepfake content that might compromise your safety.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showtextinfo(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName '),
        content: Text(
            'Paste messages or social media posts to detect harassment, threats or abuse. Our AI analyzes text for harmful content and provides safety recommendations.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName Coming Soon'),
        content: Text(
            'The $featureName feature is currently under development and will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Model class for recent checks
class _CheckItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type; // "image" or "text"

  _CheckItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.type,
  });
}
*/

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'analyze_text_screen.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Dummy handlers - replace with real navigation later
  void _onCardTap(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped: $route')),
    );
  }

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);

    if (idx == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      );
    } else if (idx == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    } else if (idx == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 18;
    return Scaffold(
      // make body extend behind nav to allow rounded bottom bar overlay
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 12,
                    bottom: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'WELCOME, USER!',
                            style: AppText.heading.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(255, 11, 41, 161),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your data is always secure and analyzed\nprivately',
                            textAlign: TextAlign.center,
                            style: AppText.body
                                .copyWith(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // First Card: Verify image integrity
                    _buildFeatureCard(
                      title: 'Verify image integrity',
                      subtitle:
                          'Check photos for signs of digital manipulation or face morphing',
                      buttonLabel: 'Check image',
                      icon: Icons.photo_camera,
                      onTap: () => _onCardTap('check_image'),
                    ),

                    const SizedBox(height: 16),

                    // Second Card: Analyze text
                    _buildFeatureCard(
                      title: 'Analyze Text for Harm',
                      subtitle:
                          'Paste messages or social media posts to detect harassment, threats or abuse',
                      buttonLabel: 'Analyze text',
                      icon: Icons.text_fields,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalyzeTextScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // Recent Checks
                    Text(
                      'Recent Checks',
                      style: AppText.heading.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: AppText.body.copyWith(fontSize: 13),
                        children: [
                          const TextSpan(
                              text: 'Image Check - Aug 15 : ',
                              style: TextStyle(color: Colors.black54)),
                          TextSpan(
                            text: 'High Morph Risk',
                            style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton(
                        onPressed: () => _onCardTap('history'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                        child: const Text('View Full History'),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Safety Tips & News

                    _buildSafetyTips(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Bottom navigation bar (floating, curved)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _bottomNavItem(Icons.home, 0),
                        _bottomNavItem(Icons.mail_outline, 1),
                        _bottomNavItem(Icons.history, 2),
                        _bottomNavItem(Icons.person_outline, 3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, int idx) {
    final bool selected = _selectedIndex == idx;
    return GestureDetector(
      onTap: () => _onBottomNavTap(idx),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: selected ? AppColors.white : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.transparent : Colors.white24,
          ),
        ),
        child: Icon(
          icon,
          size: 26,
          color: selected ? AppColors.primary : Colors.white,
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 14),

          // Title + subtitle + button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.heading
                        .copyWith(fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppText.body
                      .copyWith(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: Text(buttonLabel,
                      style: AppText.button
                          .copyWith(fontSize: 14, color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Safety Tips & News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSafetyTipItem(
            "How to report abuse on Platform Astra?",
            Icons.lightbulb_outline,
          ),
          const SizedBox(height: 8),
          _buildSafetyTipItem(
            "Emergency contacts for immediate help",
            Icons.emergency,
          ),
          const SizedBox(height: 8),
          _buildSafetyTipItem(
            "Privacy settings guide for social media",
            Icons.security,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipItem(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }
}
