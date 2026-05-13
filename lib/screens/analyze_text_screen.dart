// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_text.dart';
// import '../services/api_service.dart';
// import '../utils/notification_service.dart';
// import 'home_screen.dart';
// import 'notification_screen.dart';
// import 'history_screen.dart';
// import 'profile_screen.dart';
// import 'chat_simulator_screen.dart';

// class AnalyzeTextScreen extends StatefulWidget {
//   final String? initialText;
//   final bool fromHistory;

//   const AnalyzeTextScreen({
//     super.key,
//     this.initialText,
//     this.fromHistory = false,
//   });

//   @override
//   State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
// }

// class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
//   final TextEditingController _controller = TextEditingController();

//   bool _loading = false;
//   String? _resultLabel;
//   double? _harmScore;
//   String? _errorMessage;

//   int _selectedIndex = 0;
//   final double threshold = 0.6;

//   // ================= BULLYING EMOJI LIST =================

//   final List<String> bullyingEmojis = [
//     "🤡",
//     "💩",
//     "🖕",
//     "🤬",
//     "👎",
//     "🐷",
//     "🐍",
//     "😡",
//     "😠",
//     "🙄",
//     "😤"
//   ];

//   bool containsBullyingEmoji(String text) {
//     for (var emoji in bullyingEmojis) {
//       if (text.contains(emoji)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   // ================= EXAMPLE TEXT =================

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialText != null) {
//       _controller.text = widget.initialText!;
//     }
//   }

//   bool _isValidProbability(double? v) => v != null && v >= 0.0 && v <= 1.0;

//   Future<void> _saveReportToFirestore() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('reports')
//         .add({
//       'type': 'cyberbullying',
//       'content': _controller.text.trim(),
//       'confidence': _harmScore,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> _saveResultToFirestore({
//     required String inputText,
//     required String result,
//     required double confidence,
//   }) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('cyberbullying_history')
//         .add({
//       'inputText': inputText,
//       'result': result,
//       'confidence': confidence,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   // ================= ANALYZE =================

//   Future<void> _analyze() async {
//     final text = _controller.text.trim();

//     if (text.isEmpty) {
//       setState(() => _errorMessage = "Please enter text to analyze.");
//       return;
//     }

//     // ================= EMOJI DETECTION =================

//     if (containsBullyingEmoji(text)) {
//       setState(() {
//         _resultLabel = "Harmful";
//         _harmScore = 0.95;
//         _errorMessage = null;
//       });

//       NotificationService().addNotification(
//         title: "Harmful language detected",
//         message: "The analysed text may contain cyberbullying.",
//         icon: Icons.report,
//         color: Colors.red,
//       );

//       if (!widget.fromHistory) {
//         await _saveResultToFirestore(
//           inputText: text,
//           result: "Harmful",
//           confidence: 0.95,
//         );
//       }

//       return;
//     }

//     setState(() {
//       _loading = true;
//       _errorMessage = null;
//       _resultLabel = null;
//       _harmScore = null;
//     });

//     try {
//       final data = await ApiService.analyzeText(text, threshold: threshold);

//       int? prediction;
//       double? probability;

//       if (data['prediction'] != null) {
//         prediction = int.tryParse(data['prediction'].toString());
//       }

//       if (data['probability'] != null) {
//         probability = double.tryParse(data['probability'].toString());
//       }

//       if (probability == null && data['probabilities'] is List) {
//         final list = data['probabilities'];
//         if (list.length >= 2) probability = list[1].toDouble();
//       }

//       String label;
//       double score;

//       if (probability != null && _isValidProbability(probability)) {
//         label = probability >= threshold ? "Harmful" : "Not harmful";
//         score = probability;
//       } else if (prediction != null) {
//         label = prediction == 1 ? "Harmful" : "Not harmful";
//         score = prediction == 1 ? 0.9 : 0.1;
//       } else {
//         label = "Unknown";
//         score = 0.0;
//       }

//       if (mounted) {
//         setState(() {
//           _resultLabel = label;
//           _harmScore = score;
//         });

//         if (label == "Harmful") {
//           NotificationService().addNotification(
//             title: "Harmful language detected",
//             message: "Tap to view analysis details.",
//             icon: Icons.report,
//             color: Colors.red,
//             data: {
//               "type": "text",
//               "text": text,
//               "confidence": score,
//             },
//           );
//         }

//         if (!widget.fromHistory) {
//           await _saveResultToFirestore(
//             inputText: text,
//             result: label,
//             confidence: score,
//           );
//         }
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Error: ${e.toString()}");
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   // ================= RESULT CARD =================

//   Widget _resultCard() {
//     if (_resultLabel == null && _errorMessage == null) {
//       return const SizedBox.shrink();
//     }

//     if (_errorMessage != null) {
//       return Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.red.shade50,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
//       );
//     }

//     final scorePct = (_harmScore ?? 0) * 100;
//     final isHarmful = _resultLabel == "Harmful";
//     final color = isHarmful ? Colors.red : Colors.green.shade700;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 isHarmful ? Icons.warning_amber_rounded : Icons.check_circle,
//                 color: color,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 _resultLabel!,
//                 style: AppText.heading.copyWith(fontSize: 18),
//               ),
//               const Spacer(),
//               Text(
//                 "${scorePct.toStringAsFixed(1)}%",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: color),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _harmScore,
//             minHeight: 8,
//             backgroundColor: Colors.grey.shade200,
//             valueColor: AlwaysStoppedAnimation(color),
//           ),
//         ],
//       ),
//     );
//   }
// // ================= INFO DIALOG =================

//   void _showInfoDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Cyberbullying Detection"),
//         content: const Text(
//           "This feature analyzes text messages, comments, or posts to detect harmful or abusive content.\n\n"
//           "How it works:\n"
//           "• Paste or type the message you want to check.\n"
//           "• Tap 'Analyze text'.\n"
//           "• The model evaluates the content and estimates how harmful it is.\n\n"
//           "Result meanings:\n"
//           "• Harmful – Likely abusive, threatening, or harassing.\n"
//           "• Not harmful – Appears safe.\n\n"
//           "Privacy:\n"
//           "• Your text is analyzed securely.\n"
//           "• No content is shared publicly.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Got it"),
//           ),
//         ],
//       ),
//     );
//   }
//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text("Cyberbullying Detection"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.info_outline),
//             onPressed: _showInfoDialog,
//           )
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Evaluate text for harmful content",
//                 style: AppText.body.copyWith(color: Colors.black54),
//               ),
//               const SizedBox(height: 18),

//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(color: Colors.black12, blurRadius: 8),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _controller,
//                   minLines: 4,
//                   maxLines: 8,
//                   decoration: const InputDecoration(
//                     hintText:
//                         "Paste or type the message you want to analyze....",
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               const SizedBox(height: 18),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   onPressed: _loading ? null : _analyze,
//                   icon: const Icon(Icons.search, color: Colors.white),
//                   label: const Text(
//                     "Analyze text",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               _resultCard(),

//               const SizedBox(height: 18),

//               // ================= CHAT SIMULATOR =================

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton.icon(
//                   icon: const Icon(Icons.chat),
//                   label: const Text(
//                     "Open Chat Simulator",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppColors.primary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChatSimulatorScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../services/api_service.dart';
import '../utils/notification_service.dart';
import 'home_screen.dart';
import 'notification_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'chat_simulator_screen.dart';
import 'complaint_form_screen.dart';

class AnalyzeTextScreen extends StatefulWidget {
  final String? initialText;
  final bool fromHistory;

  const AnalyzeTextScreen({
    super.key,
    this.initialText,
    this.fromHistory = false,
  });

  @override
  State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
}

class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _loading = false;
  String? _resultLabel;
  double? _harmScore;
  String? _errorMessage;

  int _selectedIndex = 0;
  final double threshold = 0.6;

  // ================= BULLYING EMOJI LIST =================

  final List<String> bullyingEmojis = [
    "🤡",
    "💩",
    "🖕",
    "🤬",
    "👎",
    "🐷",
    "🐍",
    "😡",
    "😠",
    "🙄",
    "😤"
  ];

  bool containsBullyingEmoji(String text) {
    for (var emoji in bullyingEmojis) {
      if (text.contains(emoji)) {
        return true;
      }
    }
    return false;
  }

  // ================= EXAMPLE TEXT =================

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
    }
  }

  bool _isValidProbability(double? v) => v != null && v >= 0.0 && v <= 1.0;

  Future<void> _saveReportToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reports')
        .add({
      'type': 'cyberbullying',
      'content': _controller.text.trim(),
      'confidence': _harmScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _saveResultToFirestore({
    required String inputText,
    required String result,
    required double confidence,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cyberbullying_history')
        .add({
      'inputText': inputText,
      'result': result,
      'confidence': confidence,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ================= ANALYZE =================

  Future<void> _analyze() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() => _errorMessage = "Please enter text to analyze.");
      return;
    }

    // ================= EMOJI DETECTION =================

    if (containsBullyingEmoji(text)) {
      setState(() {
        _resultLabel = "Harmful";
        _harmScore = 0.95;
        _errorMessage = null;
      });

      NotificationService().addNotification(
        title: "Harmful language detected",
        message: "The analysed text may contain cyberbullying.",
        icon: Icons.report,
        color: Colors.red,
      );

      if (!widget.fromHistory) {
        await _saveResultToFirestore(
          inputText: text,
          result: "Harmful",
          confidence: 0.95,
        );
      }

      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _resultLabel = null;
      _harmScore = null;
    });

    try {
      final data = await ApiService.analyzeText(text, threshold: threshold);

      int? prediction;
      double? probability;

      if (data['prediction'] != null) {
        prediction = int.tryParse(data['prediction'].toString());
      }

      if (data['probability'] != null) {
        probability = double.tryParse(data['probability'].toString());
      }

      if (probability == null && data['probabilities'] is List) {
        final list = data['probabilities'];
        if (list.length >= 2) probability = list[1].toDouble();
      }

      String label;
      double score;

      if (probability != null && _isValidProbability(probability)) {
        label = probability >= threshold ? "Harmful" : "Not harmful";
        score = probability;
      } else if (prediction != null) {
        label = prediction == 1 ? "Harmful" : "Not harmful";
        score = prediction == 1 ? 0.9 : 0.1;
      } else {
        label = "Unknown";
        score = 0.0;
      }

      if (mounted) {
        setState(() {
          _resultLabel = label;
          _harmScore = score;
        });

        if (label == "Harmful") {
          NotificationService().addNotification(
            title: "Harmful language detected",
            message: "Tap to view analysis details.",
            icon: Icons.report,
            color: Colors.red,
            data: {
              "type": "text",
              "text": text,
              "confidence": score,
            },
          );
        }

        if (!widget.fromHistory) {
          await _saveResultToFirestore(
            inputText: text,
            result: label,
            confidence: score,
          );
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ================= RESULT CARD =================

  Widget _resultCard() {
    if (_resultLabel == null && _errorMessage == null) {
      return const SizedBox.shrink();
    }

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final scorePct = (_harmScore ?? 0) * 100;
    final isHarmful = _resultLabel == "Harmful";
    final color = isHarmful ? Colors.red : Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHarmful ? Icons.warning_amber_rounded : Icons.check_circle,
                color: color,
              ),
              const SizedBox(width: 10),
              Text(
                _resultLabel!,
                style: AppText.heading.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Text(
                "${scorePct.toStringAsFixed(1)}%",
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _harmScore,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }
// ================= INFO DIALOG =================

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cyberbullying Detection"),
        content: const Text(
          "This feature analyzes text messages, comments, or posts to detect harmful or abusive content.\n\n"
          "How it works:\n"
          "• Paste or type the message you want to check.\n"
          "• Tap 'Analyze text'.\n"
          "• The model evaluates the content and estimates how harmful it is.\n\n"
          "Result meanings:\n"
          "• Harmful – Likely abusive, threatening, or harassing.\n"
          "• Not harmful – Appears safe.\n\n"
          "Privacy:\n"
          "• Your text is analyzed securely.\n"
          "• No content is shared publicly.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  // ================= REPORT TO CYBER CELL =================

  Future<void> _showReportConsentDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Report to Cyber Cell"),
        content: const Text(
          "You are about to file a complaint regarding harmful or abusive text.\n\n"
          "If you continue, you will be asked to provide additional details "
          "such as the platform where the message was received and the user ID "
          "of the person responsible.\n\n"
          "This information will help the Cyber Cell investigate the issue.\n\n"
          "Do you want to proceed with filing the complaint?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComplaintFormScreen(
                    complaintType: "cyberbullying",
                    confidence: _harmScore ?? 0,
                    detectedText: _controller.text.trim(),
                  ),
                ),
              );
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Cyberbullying Detection"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Evaluate text for harmful content",
                style: AppText.body.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText:
                        "Paste or type the message you want to analyze....",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _analyze,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    "Analyze text",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _resultCard(),

              if (_resultLabel == "Harmful")
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.report, color: Colors.red),
                      label: const Text(
                        "Report to Cyber Cell",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _showReportConsentDialog,
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // ================= CHAT SIMULATOR =================

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text(
                    "Open Chat Simulator",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatSimulatorScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
