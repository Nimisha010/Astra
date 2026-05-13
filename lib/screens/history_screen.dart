import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'analyze_text_screen.dart';
import 'verify_image.dart';

class HistoryScreen extends StatelessWidget {
  final int initialTab;

  const HistoryScreen({super.key, this.initialTab = 0});

  // ================= DELETE FUNCTION =================

  Future<void> _deleteHistory(
      BuildContext context, String uid, String collection, String docId) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete History"),
        content: const Text(
            "Are you sure you want to remove this item from your history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(collection)
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("History item deleted")),
      );
    }
  }

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
              _buildMorphHistory(context, user.uid),
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
        return _buildHistoryList(context, snapshot, uid, false);
      },
    );
  }

  // ================= MORPH HISTORY =================

  Widget _buildMorphHistory(BuildContext context, String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('morph_history')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return _buildHistoryList(context, snapshot, uid, true);
      },
    );
  }

  // ================= COMMON LIST =================

  Widget _buildHistoryList(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, String uid, bool isMorphing) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text(
          "No history yet.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final docs = snapshot.data!.docs;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final data = doc.data() as Map<String, dynamic>;
        final docId = doc.id;

        if (isMorphing) {
          return _buildMorphCard(context, data, uid, docId);
        } else {
          return _buildCyberCard(context, data, uid, docId);
        }
      },
    );
  }

  // ================= CYBERBULLYING CARD =================

  Widget _buildCyberCard(BuildContext context, Map<String, dynamic> data,
      String uid, String docId) {
    final result = data['result'] ?? '';
    final confidence = (data['confidence'] ?? 0.0) * 100;
    final text = data['inputText'] ?? '';

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
              initialText: text,
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
                const SizedBox(width: 8),

                // DELETE BUTTON
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                    _deleteHistory(
                      context,
                      uid,
                      "cyberbullying_history",
                      docId,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: AppText.body.copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MORPH CARD =================

  Widget _buildMorphCard(BuildContext context, Map<String, dynamic> data,
      String uid, String docId) {
    final label = data['label'] ?? '';
    final confidence = (data['confidence'] ?? 0.0) * 100;
    final imageUrl = data['imageUrl'];

    final isRisky = label.toString().toLowerCase().contains("risk");

    final icon =
        isRisky ? Icons.warning_amber_rounded : Icons.check_circle_outline;

    final percentageColor = isRisky ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyImageScreen(
              imageUrl: imageUrl,
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
                const SizedBox(width: 8),

                // DELETE BUTTON
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                    _deleteHistory(
                      context,
                      uid,
                      "morph_history",
                      docId,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (imageUrl != null && imageUrl.toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text("Image unavailable"),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
