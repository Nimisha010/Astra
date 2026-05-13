import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/notification_service.dart';

class ComplaintFormScreen extends StatefulWidget {
  final String? detectedText;
  final double confidence;
  final String complaintType;
  final String? imageUrl;

  const ComplaintFormScreen({
    super.key,
    this.detectedText,
    required this.confidence,
    required this.complaintType,
    this.imageUrl,
  });

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController platformController = TextEditingController();
  final TextEditingController offenderController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String category = "Cyberbullying";

  // ================= SUBMIT COMPLAINT =================

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = {
      "type": widget.complaintType,
      "category": category,
      "platform": platformController.text,
      "offender_id": offenderController.text,
      "description": descriptionController.text,
      "detected_text": widget.detectedText,
      "confidence": widget.confidence,
      "timestamp": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("reports")
        .add(data);

    final String email = "cybercell@keralapolice.gov.in";
    final String subject = "Cybercrime Complaint";

    String body;

    if (widget.complaintType == "cyberbullying") {
      body = """
Respected Cyber Cell Officer,

I would like to formally report an incident of cyberbullying that I recently encountered online.

Platform:
${platformController.text}

Offender ID:
${offenderController.text}

Detected Harmful Message:
"${widget.detectedText ?? "N/A"}"

AI Detection Confidence:
${(widget.confidence * 100).toStringAsFixed(1)}%

Additional Details:
${descriptionController.text}

This message was analyzed using the Astra Safety Application and identified as harmful.

Kindly review this complaint and take necessary action.

Sincerely,
A Concerned User

Submitted via Astra Safety Application
""";
    } else {
      body = """
Respected Cyber Cell Officer,

I would like to report a suspected case of image morphing / digital manipulation.

Platform:
${platformController.text}

Offender ID:
${offenderController.text}

AI Morph Detection Confidence:
${(widget.confidence * 100).toStringAsFixed(1)}%

Additional Details:
${descriptionController.text}

The image was analyzed using the Astra Safety Application and flagged as potentially morphed.

Image Reference:
${widget.imageUrl ?? "Not Available"}

Kindly investigate this matter.

Sincerely,
A Concerned User

Submitted via Astra Safety Application
""";
    }

    final Uri emailUri = Uri.parse(
        "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");

    await launchUrl(emailUri);

    NotificationService().addNotification(
      title: "Complaint email sent",
      message: "Tap to view complaint details.",
      icon: Icons.mail_outline,
      color: Colors.blue,
      data: {
        "type": "complaint",
        "platform": platformController.text,
        "offender": offenderController.text,
        "description": descriptionController.text,
        "confidence": widget.confidence,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint submitted successfully")),
    );

    Navigator.pop(context);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cybercrime Complaint"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // ================= INTRO TEXT =================

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Text(
                    "Please provide the details related to the cybercrime incident. "
                    "This information will help the Cyber Cell investigate the issue.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= IMAGE PREVIEW =================

                if (widget.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.imageUrl!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                if (widget.imageUrl != null) const SizedBox(height: 20),

                // ================= CATEGORY =================

                DropdownButtonFormField(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: "Complaint Category",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: "Cyberbullying", child: Text("Cyberbullying")),
                    DropdownMenuItem(
                        value: "Harassment", child: Text("Harassment")),
                    DropdownMenuItem(value: "Threat", child: Text("Threat")),
                    DropdownMenuItem(
                        value: "Fake Profile", child: Text("Fake Profile")),
                    DropdownMenuItem(
                        value: "Morphed Image", child: Text("Morphed Image")),
                  ],
                  onChanged: (v) => setState(() => category = v.toString()),
                ),

                const SizedBox(height: 16),

                // ================= PLATFORM =================

                TextFormField(
                  controller: platformController,
                  decoration: const InputDecoration(
                    labelText: "Platform (Instagram / WhatsApp / etc)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.public),
                  ),
                  validator: (v) => v!.isEmpty ? "Please enter platform" : null,
                ),

                const SizedBox(height: 16),

                // ================= OFFENDER =================

                TextFormField(
                  controller: offenderController,
                  decoration: const InputDecoration(
                    labelText: "Offender Username / ID",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Please enter offender ID" : null,
                ),

                const SizedBox(height: 16),

                // ================= DESCRIPTION =================

                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Describe the Incident",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= SUBMIT BUTTON =================

                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.report),
                    label: const Text(
                      "Submit Complaint",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _submitComplaint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
