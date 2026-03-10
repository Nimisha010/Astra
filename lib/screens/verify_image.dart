import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VerifyImageScreen extends StatefulWidget {
  const VerifyImageScreen({super.key});

  @override
  State<VerifyImageScreen> createState() => _VerifyImageScreenState();
}

class _VerifyImageScreenState extends State<VerifyImageScreen> {
  File? _image;
  bool _loading = false;
  String? _resultLabel;
  double? _riskScore;

  final ImagePicker _picker = ImagePicker();

  // 📸 Pick image
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _resultLabel = null;
        _riskScore = null;
      });
    }
  }

  // ❌ Remove image
  void _removeImage() {
    setState(() {
      _image = null;
      _resultLabel = null;
      _riskScore = null;
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Image Morphing Detection"),
        content: const Text(
          "This feature detects whether a facial image is authentic or digitally morphed.\n\n"
          "How it works:\n"
          "• The image is sent to the AI backend.\n"
          "• The system predicts whether the image is REAL or MORPHED.\n\n"
          "Green → Authentic Image\n"
          "Red → Morphed Image\n\n"
          "Results are stored securely in your history.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          )
        ],
      ),
    );
  }

  Future<void> _saveMorphResultToFirestore({
    required String label,
    required double confidence,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _image == null) return;

    try {
      final fileName = "morph_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final ref = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(user.uid)
          .child("morph_images")
          .child(fileName);

      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('morph_history')
          .add({
        'label': label,
        'confidence': confidence,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving morph result: $e");
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
      _resultLabel = null;
      _riskScore = null;
    });

    try {
      final result = await ApiService.analyzeImage(_image!);

      final label = result['label'];
      final confidence = (result['confidence'] as num).toDouble();

      setState(() {
        _resultLabel = label;
        _riskScore = confidence;
        _loading = false;
      });

      await _saveMorphResultToFirestore(
        label: label,
        confidence: confidence,
      );
    } catch (e) {
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _sendComplaint() async {
    final String email = "cybercell@keralapolice.gov.in";
    final String subject = "Complaint: Suspected Morphed Image";

    final String body = """
Respected Cybercell Team,

A morphed image has been detected.

Detection Result:
Confidence Score: ${(_riskScore! * 100).toStringAsFixed(1)}%

Kindly take necessary action.

Regards,
Concerned User
""";

    final Uri emailUri = Uri.parse("mailto:$email"
        "?subject=${Uri.encodeComponent(subject)}"
        "&body=${Uri.encodeComponent(body)}");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Widget _resultCard() {
    if (_resultLabel == null) return const SizedBox.shrink();

    final isMorphed = _resultLabel!.toLowerCase().contains("morph");

    final color = isMorphed ? Colors.red : Colors.green;

    return Container(
      width: double.infinity,
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
                isMorphed ? Icons.warning_amber_rounded : Icons.check_circle,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                _resultLabel!,
                style: AppText.heading.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Text(
                "${(_riskScore! * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: _riskScore,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),

          const SizedBox(height: 8),

          // ✅ Show warning only if MORPHED
          if (isMorphed)
            Text(
              "This image is likely digitally morphed or manipulated.",
              style: AppText.body.copyWith(color: Colors.red),
            ),

          if (!isMorphed)
            Text(
              "This image appears authentic.",
              style: AppText.body.copyWith(color: Colors.green),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMorphed =
        _resultLabel != null && _resultLabel!.toLowerCase().contains("morph");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Morphed Image Detection"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
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
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload an image to verify authenticity",
                style: AppText.body.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              // IMAGE BOX
              GestureDetector(
                onTap: _image == null ? _pickImage : null,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Tap to upload image",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // ANALYZE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.search),
                  label: Text(
                    _loading ? "Analyzing..." : "Check Image",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      (_loading || _image == null) ? null : _analyzeImage,
                ),
              ),

              const SizedBox(height: 18),

              _resultCard(),

              if (isMorphed)
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
                      onPressed: _sendComplaint,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_text.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../services/api_service.dart';

// class VerifyImageScreen extends StatefulWidget {
//   const VerifyImageScreen({super.key});

//   @override
//   State<VerifyImageScreen> createState() => _VerifyImageScreenState();
// }

// class _VerifyImageScreenState extends State<VerifyImageScreen> {
//   File? _image;
//   bool _loading = false;
//   String? _resultLabel;
//   double? _riskScore;

//   final ImagePicker _picker = ImagePicker();

//   // 📸 Pick image
//   Future<void> _pickImage() async {
//     final picked = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (picked != null) {
//       setState(() {
//         _image = File(picked.path);
//         _resultLabel = null;
//         _riskScore = null;
//       });
//     }
//   }

//   // ❌ Remove image
//   void _removeImage() {
//     setState(() {
//       _image = null;
//       _resultLabel = null;
//       _riskScore = null;
//     });
//   }

//   // 🔍 Analyze image (
//   Future<void> _analyzeImage() async {
//     if (_image == null) return;

//     setState(() {
//       _loading = true;
//       _resultLabel = null;
//       _riskScore = null;
//     });

//     try {
//       final result = await ApiService.analyzeImage(_image!);

//       setState(() {
//         _resultLabel = result['label'];
//         _riskScore = (result['confidence'] as num).toDouble();
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _loading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   // 📧 Send Cybercell Complaint
//   Future<void> _sendComplaint() async {
//     final String email = "cybercell@keralapolice.gov.in";
//     final String subject = "Complaint: Suspected Morphed Image";
//     final String body = """
// Respected Cybercell Team,

// I would like to report a suspected morphed image detected using a cyber safety application.

// Detection Result:
// - Risk Level: High Morph Risk
// - Confidence Score: ${(_riskScore! * 100).toStringAsFixed(1)}%

// Please find the attached image and take necessary action.

// Thank you.

// Regards,
// Concerned User
// """;

//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: Uri.encodeFull(
//         'subject=$subject&body=$body',
//       ),
//     );

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     }
//   }

//   // 📊 Result Card
//   Widget _resultCard() {
//     if (_resultLabel == null) return const SizedBox.shrink();

//     final isRisky = _riskScore! >= 0.6;
//     final color = isRisky ? Colors.red : Colors.green;

//     return Container(
//       width: double.infinity,
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
//               Icon(Icons.warning_amber_rounded, color: color),
//               const SizedBox(width: 8),
//               Text(
//                 _resultLabel!,
//                 style: AppText.heading.copyWith(fontSize: 18),
//               ),
//               const Spacer(),
//               Text(
//                 "${(_riskScore! * 100).toStringAsFixed(1)}%",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _riskScore,
//             backgroundColor: Colors.grey.shade200,
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "This image may contain face morphing or manipulation.",
//             style: AppText.body.copyWith(color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text("Morphed Image Detection"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
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
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Upload an image to verify authenticity",
//                 style: AppText.body.copyWith(color: Colors.black54),
//               ),
//               const SizedBox(height: 18),

//               /// 🔲 IMAGE UPLOAD BOX
//               GestureDetector(
//                 onTap: _image == null ? _pickImage : null,
//                 child: Container(
//                   height: 220,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: _image == null
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.add_photo_alternate,
//                                 size: 50, color: Colors.grey),
//                             SizedBox(height: 10),
//                             Text("Tap to upload image",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         )
//                       : Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.file(
//                                 _image!,
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                             ),
//                             Positioned(
//                               top: 8,
//                               right: 8,
//                               child: GestureDetector(
//                                 onTap: _removeImage,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(6),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.black54,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               /// 🔍 ANALYZE BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   icon: _loading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.search),
//                   label: Text(
//                     _loading ? "Analyzing..." : "Check Image",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed:
//                       (_loading || _image == null) ? null : _analyzeImage,
//                 ),
//               ),

//               const SizedBox(height: 18),

//               /// 📊 RESULT
//               _resultCard(),

//               /// 📧 CYBERCELL BUTTON (ONLY IF HIGH RISK)
//               if (_resultLabel != null &&
//                   _riskScore != null &&
//                   _riskScore! >= 0.6)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: OutlinedButton.icon(
//                       icon: const Icon(Icons.outgoing_mail),
//                       label: const Text(
//                         "Report to Cybercell",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: AppColors.primary),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: _sendComplaint,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
