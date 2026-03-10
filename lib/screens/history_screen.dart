import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'analyze_text_screen.dart';

class HistoryScreen extends StatelessWidget {
  final int initialTab;

  const HistoryScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("History"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Cyberbullying"),
              Tab(text: "Image Morphing"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              _buildCyberbullyingHistory(context, user.uid),
              _buildMorphHistory(user.uid),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CYBERBULLYING HISTORY =================

  Widget _buildCyberbullyingHistory(BuildContext context, String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cyberbullying_history')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return _buildHistoryList(context, snapshot, isMorphing: false);
      },
    );
  }

  // ================= MORPH HISTORY =================

  Widget _buildMorphHistory(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('morph_history') // ✅ CORRECT COLLECTION NAME
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return _buildHistoryList(context, snapshot, isMorphing: true);
      },
    );
  }

  Widget _buildHistoryList(BuildContext context, AsyncSnapshot snapshot,
      {required bool isMorphing}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
      return const Center(
        child: Text(
          "No history yet.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final docs = snapshot.data.docs;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;

        if (isMorphing) {
          return _buildMorphCard(data);
        } else {
          return _buildCyberCard(context, data);
        }
      },
    );
  }

  // ================= CYBERBULLYING CARD =================

  Widget _buildCyberCard(BuildContext context, Map<String, dynamic> data) {
    final result = data['result'] ?? '';
    final confidence = (data['confidence'] ?? 0.0) * 100;

    final isHarmful = result.toString().toLowerCase() == "harmful";

    final icon =
        isHarmful ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    final percentageColor = isHarmful ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnalyzeTextScreen(
              initialText: data['inputText'],
              fromHistory: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: percentageColor),
                const SizedBox(width: 8),
                Text(
                  result,
                  style: AppText.heading.copyWith(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  "${confidence.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: percentageColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data['inputText'] ?? '',
              style: AppText.body.copyWith(
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MORPH CARD =================

  Widget _buildMorphCard(Map<String, dynamic> data) {
    final label = data['label'] ?? '';
    final confidence = (data['confidence'] ?? 0.0) * 100;
    final imageUrl = data['imageUrl'];

    final isRisky = label.toString().toLowerCase().contains("risk");

    final icon =
        isRisky ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    final percentageColor = isRisky ? Colors.red : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: percentageColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppText.heading.copyWith(fontSize: 16),
              ),
              const Spacer(),
              Text(
                "${confidence.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: percentageColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔥 IMAGE PREVIEW
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_text.dart';
// import 'analyze_text_screen.dart';

// class HistoryScreen extends StatelessWidget {
//   final int initialTab;

//   const HistoryScreen({super.key, this.initialTab = 0});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("User not logged in")),
//       );
//     }

//     return DefaultTabController(
//       length: 2,
//       initialIndex: initialTab,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           title: const Text("History"),
//           centerTitle: true,
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Cyberbullying"),
//               Tab(text: "Image Morphing"),
//             ],
//           ),
//         ),
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: TabBarView(
//             children: [
//               _buildCyberbullyingHistory(context, user.uid),
//               _buildMorphingHistory(user.uid),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= CYBERBULLYING HISTORY =================

//   Widget _buildCyberbullyingHistory(BuildContext context, String uid) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('cyberbullying_history')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         return _buildHistoryList(context, snapshot, isMorphing: false);
//       },
//     );
//   }

//   // ================= MORPHING HISTORY =================

//   Widget _buildMorphingHistory(String uid) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('morphing_history')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         return _buildHistoryList(context, snapshot, isMorphing: true);
//       },
//     );
//   }

//   // ================= COMMON UI BUILDER =================

//   Widget _buildHistoryList(BuildContext context, AsyncSnapshot snapshot,
//       {required bool isMorphing}) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
//       return const Center(
//         child: Text(
//           "No history yet.",
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     final docs = snapshot.data.docs;

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: docs.length,
//       itemBuilder: (context, index) {
//         final data = docs[index].data() as Map<String, dynamic>;

//         final result = data['result'] ?? '';
//         final confidence = (data['confidence'] ?? 0.0) * 100;
//         final isHarmful = result.toString().toLowerCase() == "harmful";

//         final icon = isHarmful
//             ? Icons.warning_amber_rounded
//             : Icons.check_circle_outline;

//         final percentageColor = isHarmful ? Colors.red : Colors.green;

//         Widget card = Container(
//           margin: const EdgeInsets.only(bottom: 14),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: percentageColor),
//                   const SizedBox(width: 8),
//                   Text(
//                     result,
//                     style: AppText.heading.copyWith(fontSize: 16),
//                   ),
//                   const Spacer(),
//                   Text(
//                     "${confidence.toStringAsFixed(1)}%",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: percentageColor,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               if (!isMorphing && data['inputText'] != null)
//                 Text(
//                   data['inputText'],
//                   style: AppText.body.copyWith(
//                     color: Colors.black87,
//                   ),
//                 ),
//               if (isMorphing && data['imageName'] != null)
//                 Text(
//                   "Image: ${data['imageName']}",
//                   style: AppText.body.copyWith(
//                     color: Colors.black87,
//                   ),
//                 ),
//             ],
//           ),
//         );

//         // 👇 Navigate only for cyberbullying
//         if (!isMorphing) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => AnalyzeTextScreen(
//                     initialText: data['inputText'],
//                     fromHistory: true, // 👈 IMPORTANT
//                   ),
//                 ),
//               );
//             },
//             child: card,
//           );
//         }

//         return card;
//       },
//     );
//   }
// }
