import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complaint_form_screen.dart';
import '../utils/notification_service.dart';

class VerifyImageScreen extends StatefulWidget {
  final String? imageUrl;

  const VerifyImageScreen({super.key, this.imageUrl});

  @override
  State<VerifyImageScreen> createState() => _VerifyImageScreenState();
}

class _VerifyImageScreenState extends State<VerifyImageScreen> {
  File? _image;
  bool _loading = false;
  String? _resultLabel;
  double? _riskScore;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.imageUrl != null) {
      _imageUrl = widget.imageUrl;
    }
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _imageUrl = null;
        _resultLabel = null;
        _riskScore = null;
      });
    }
  }

  // ================= REMOVE IMAGE =================
  void _removeImage() {
    setState(() {
      _image = null;
      _imageUrl = null;
      _resultLabel = null;
      _riskScore = null;
    });
  }

  // ================= INFO DIALOG =================
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

  // ================= SAVE RESULT =================
  Future<void> _saveMorphResultToFirestore({
    required String label,
    required double confidence,
    required String imageUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('morph_history');

    final existing =
        await historyRef.where('imageUrl', isEqualTo: imageUrl).get();

    if (existing.docs.isNotEmpty) {
      return;
    }

    await historyRef.add({
      'label': label,
      'confidence': confidence,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ================= ANALYZE IMAGE =================
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
      final imageUrl = result['image_url'];

      final isMorphed = label.toString().toLowerCase().contains("morph");

      if (isMorphed) {
        NotificationService().addNotification(
          title: "Potential morphed image detected",
          message: "Please review the detection result.",
          icon: Icons.warning_amber,
          color: Colors.orange,
          data: {
            "type": "morph",
            "result": label,
            "confidence": confidence,
            "imageUrl": imageUrl,
          },
        );
      } else {
        NotificationService().addNotification(
          title: "Image verified as authentic",
          message: "Tap to view analysis details.",
          icon: Icons.verified,
          color: Colors.green,
          data: {
            "type": "morph",
            "result": label,
            "confidence": confidence,
            "imageUrl": imageUrl,
          },
        );
      }

      setState(() {
        _resultLabel = label;
        _riskScore = confidence;
        _imageUrl = imageUrl;
        _loading = false;
      });

      await _saveMorphResultToFirestore(
        label: label,
        confidence: confidence,
        imageUrl: imageUrl,
      );
    } catch (e) {
      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ================= SEND COMPLAINT =================
  Future<void> _showReportConsentDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Report to Cyber Cell"),
        content: const Text(
            "You are about to file a complaint regarding a suspected morphed image.\n\n"
            "If you continue, you will be asked to provide additional details "
            "such as the platform where the image was found and the user ID of the person responsible.\n\n"
            "This information will help the Cyber Cell investigate the issue.\n\n"
            "Do you want to proceed with filing the complaint?"),
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
                    complaintType: "morphing",
                    confidence: _riskScore ?? 0,
                    imageUrl: _imageUrl,
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

  // ================= RESULT CARD =================
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isMorphed
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
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
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _riskScore,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
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
                  child: _image != null
                      ? Stack(
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

                            // ❌ Remove image button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
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
                        )
                      : _imageUrl != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),

                                // ❌ Remove image button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
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
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_photo_alternate,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text("Tap to upload image",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 18),
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
                  label: Text(_loading ? "Analyzing..." : "Check Image"),
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
                      onPressed: _showReportConsentDialog,
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
