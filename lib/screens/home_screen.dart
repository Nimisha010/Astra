/*import 'package:flutter/material.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: 12,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
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

                _buildFeatureCard(
                  title: 'Verify image integrity',
                  subtitle:
                      'Check photos for signs of digital manipulation or face morphing',
                  buttonLabel: 'Check image',
                  icon: Icons.photo_camera,
                  onTap: () => _onCardTap('check_image'),
                ),

                const SizedBox(height: 16),

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
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextSpan(
                        text: 'High Morph Risk',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _onCardTap('history'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Full History'),
                ),

                const SizedBox(height: 18),
                _buildSafetyTips(),
              ],
            ),
          ),
        ),
      ),

      /// ✅ FIXED FULL-WIDTH BOTTOM NAV BAR
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 0),
            _bottomNavItem(Icons.mail_outline, 1),
            _bottomNavItem(Icons.history, 2),
            _bottomNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, int idx) {
    final bool selected = _selectedIndex == idx;
    return GestureDetector(
      onTap: () => _onBottomNavTap(idx),
      child: Icon(
        icon,
        size: 28,
        color: selected ? Colors.white : Colors.white70,
      ),
    );
  }

  // ---- NO CHANGES BELOW ----

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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}*/

/*correct one 

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'analyze_text_screen.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'verify_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // 🔹 Expanded state for tips
  late List<bool> _expanded;

  // 🔹 Safety tips data
  final List<Map<String, dynamic>> _tipsData = [
    {
      "title": "How cyberbullying text detection works",
      "icon": Icons.text_snippet,
      "points": [
        "Paste any message or post into Analyze Text.",
        "The system evaluates abusive or harmful language.",
        "Bullying severity is shown as a percentage.",
        "Safe or normal messages are not flagged."
      ],
    },
    {
      "title": "Understanding the bullying percentage score",
      "icon": Icons.percent,
      "points": [
        "Higher percentage means higher bullying intensity.",
        "Low scores indicate mild or contextual language.",
        "High scores indicate harassment, threats, or abuse.",
        "Only harmful content triggers alerts."
      ],
    },
    {
      "title": "How morphed image detection protects you",
      "icon": Icons.photo_camera,
      "points": [
        "Upload an image to verify authenticity.",
        "The system checks for face morphing or manipulation.",
        "Risk level is shown if tampering is detected.",
        "Original images remain private and secure."
      ],
    },
    {
      "title": "What to do when bullying or morphing is detected",
      "icon": Icons.warning_amber,
      "points": [
        "Do not delete the evidence immediately.",
        "Save screenshots or original files.",
        "Review the detection result carefully.",
        "Proceed to complaint option if needed."
      ],
    },
    {
      "title": "Forwarding complaints to cybercell",
      "icon": Icons.outgoing_mail,
      "points": [
        "Use the complaint option after detection.",
        "Attach detected text or morphed image as proof.",
        "Details are forwarded securely to cybercell.",
        "Your identity and data are kept confidential."
      ],
    },
    {
      "title": "Why safe messages show no result",
      "icon": Icons.verified_user,
      "points": [
        "Normal conversations are not flagged.",
        "This avoids unnecessary fear or confusion.",
        "The system focuses only on harmful content.",
        "Ensures ethical and responsible detection."
      ],
    },
    {
      "title": "Tips to stay safe online",
      "icon": Icons.shield,
      "points": [
        "Avoid responding to abusive messages.",
        "Keep evidence before blocking the sender.",
        "Report repeated harassment early.",
        "Use strong privacy settings on social media."
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(_tipsData.length, false);
  }

  void _onCardTap(String route) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Tapped: $route')));
  }

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);

    if (idx == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()));
    } else if (idx == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    } else if (idx == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome back',
                        style: AppText.heading.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Protect yourself from cyber abuse and digital manipulation.',
                        textAlign: TextAlign.center,
                        style: AppText.body.copyWith(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                _buildFeatureCard(
                  title: 'Verify image integrity',
                  subtitle:
                      'Check photos for signs of digital manipulation or face morphing',
                  buttonLabel: 'Check image',
                  icon: Icons.photo_camera,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerifyImageScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

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
                        builder: (_) => const AnalyzeTextScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // Text('Recent Checks',
                //     style: AppText.heading.copyWith(fontSize: 16)),
                // const SizedBox(height: 8),

                // const SizedBox(height: 18),

                /// ✅ UPDATED SAFETY TIPS
                _buildSafetyTips(),
              ],
            ),
          ),
        ),
      ),

      /// ✅ ORIGINAL FIXED FULL-WIDTH BOTTOM NAV (UNCHANGED)
      bottomNavigationBar: Container(
        height: 70,
        color: AppColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 0),
            _bottomNavItem(Icons.mail_outline, 1),
            _bottomNavItem(Icons.history, 2),
            _bottomNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, int idx) {
    final selected = _selectedIndex == idx;
    return GestureDetector(
      onTap: () => _onBottomNavTap(idx),
      child: Icon(
        icon,
        size: 28,
        color: selected ? Colors.white : Colors.white70,
      ),
    );
  }

  // ---------------- SAFETY TIPS ----------------

  Widget _buildSafetyTips() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Safety Tips & News",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _tipsData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _tipsData[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded[index] = !_expanded[index];
                    });
                  },
                  child: _buildExpandableTipItem(
                    title: item['title'],
                    icon: item['icon'],
                    points: List<String>.from(item['points']),
                    expanded: _expanded[index],
                  ),
                );
              },
            ),
          ),
        ],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
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

  Widget _buildExpandableTipItem({
    required String title,
    required IconData icon,
    required List<String> points,
    required bool expanded,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: points
                    .map((p) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• "),
                            Expanded(child: Text(p)),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'analyze_text_screen.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'verify_image.dart';
import 'reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<bool> _expanded;
  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(_tipsData.length, false);
  }
  // ================= HEADER =================

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "User";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, $userName 👋",
          style: AppText.heading.copyWith(
            fontSize: 22,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Stay protected from cyber abuse and digital threats.",
          style: AppText.body.copyWith(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _statItem(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
  // ================= REAL-TIME STATS =================

  Widget _buildQuickStats() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<List<QuerySnapshot>>(
      future: Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cyberbullying_history')
            .get(),
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('morphing_history')
            .get(),
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('reports')
            .get(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final textCount = snapshot.data![0].docs.length;
        final imageCount = snapshot.data![1].docs.length;
        final reportCount = snapshot.data![2].docs.length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF4F8FF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(
                "Texts Checked",
                textCount.toString(),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(initialTab: 0),
                    ),
                  );
                },
              ),
              _statItem(
                "Images Verified",
                imageCount.toString(),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(initialTab: 1),
                    ),
                  );
                },
              ),
              _statItem(
                "Reports Sent",
                reportCount.toString(),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= FEATURE CARD =================

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF7FAFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.heading.copyWith(fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppText.body
                      .copyWith(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ✅ makes text white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SAFETY TIPS =================

  final List<Map<String, dynamic>> _tipsData = [
    {
      "title": "How cyberbullying text detection works",
      "icon": Icons.text_snippet,
      "points": [
        "Paste any message or post into Analyze Text.",
        "The system evaluates abusive or harmful language.",
        "Bullying severity is shown as a percentage.",
        "Safe or normal messages are not flagged."
      ],
    },
    {
      "title": "Understanding the bullying percentage score",
      "icon": Icons.percent,
      "points": [
        "Higher percentage means higher bullying intensity.",
        "Low scores indicate mild or contextual language.",
        "High scores indicate harassment, threats, or abuse.",
        "Only harmful content triggers alerts."
      ],
    },
    {
      "title": "How morphed image detection protects you",
      "icon": Icons.photo_camera,
      "points": [
        "Upload an image to verify authenticity.",
        "The system checks for face morphing or manipulation.",
        "Risk level is shown if tampering is detected.",
        "Original images remain private and secure."
      ],
    },
    {
      "title": "What to do when bullying or morphing is detected",
      "icon": Icons.warning_amber,
      "points": [
        "Do not delete the evidence immediately.",
        "Save screenshots or original files.",
        "Review the detection result carefully.",
        "Proceed to complaint option if needed."
      ],
    },
    {
      "title": "Forwarding complaints to cybercell",
      "icon": Icons.outgoing_mail,
      "points": [
        "Use the complaint option after detection.",
        "Attach detected text or morphed image as proof.",
        "Details are forwarded securely to cybercell.",
        "Your identity and data are kept confidential."
      ],
    },
    {
      "title": "Why safe messages show no result",
      "icon": Icons.verified_user,
      "points": [
        "Normal conversations are not flagged.",
        "This avoids unnecessary fear or confusion.",
        "The system focuses only on harmful content.",
        "Ensures ethical and responsible detection."
      ],
    },
    {
      "title": "Tips to stay safe online",
      "icon": Icons.shield,
      "points": [
        "Avoid responding to abusive messages.",
        "Keep evidence before blocking the sender.",
        "Report repeated harassment early.",
        "Use strong privacy settings on social media."
      ],
    },
  ];
  Widget _buildSafetyTips() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Safety Tips & News",
            style: AppText.heading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tipsData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _tipsData[index];
              final expanded = _expanded[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded[index] = !_expanded[index];
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item['icon'], color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 10),
                        Column(
                          children: List<String>.from(item['points'])
                              .map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("• "),
                                      Expanded(
                                        child: Text(
                                          p,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  // ================= BOTTOM NAV =================

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);

    if (idx == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()));
    } else if (idx == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    } else if (idx == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }

  Widget _bottomNavItem(IconData icon, int idx) {
    final selected = _selectedIndex == idx;
    return GestureDetector(
      onTap: () => _onBottomNavTap(idx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: selected ? Colors.white : Colors.white70,
          ),
          const SizedBox(height: 4),
          if (selected)
            Container(
              height: 4,
              width: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildQuickStats(),
                const SizedBox(height: 24),
                _buildFeatureCard(
                  title: "Image Morphing Detection",
                  subtitle:
                      "Upload and verify photos for signs of manipulation.",
                  buttonLabel: "Check Image",
                  icon: Icons.photo_camera,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VerifyImageScreen()),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _buildFeatureCard(
                  title: "Cyberbullying Detection",
                  subtitle:
                      "Analyze text messages for harassment or abusive language.",
                  buttonLabel: "Analyze Text",
                  icon: Icons.text_fields,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AnalyzeTextScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildSafetyTips(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: AppColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 0),
            _bottomNavItem(Icons.mail_outline, 1),
            _bottomNavItem(Icons.history, 2),
            _bottomNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }
}
