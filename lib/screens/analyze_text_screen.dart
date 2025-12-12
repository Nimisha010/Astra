/*import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnalyzeTextScreen extends StatefulWidget {
  const AnalyzeTextScreen({super.key});

  @override
  State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
}

class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Back Button
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),

            // 🔹 Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Title
                    const Text(
                      "Cyberbullying\nDetection",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Times New Roman',
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 🔹 Subtitle
                    Text(
                      "Evaluate text for harmful content",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔹 Text Input Container
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText:
                              "Paste or type the message you want to analyze....",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Analyze Button - Centered
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _onAnalyzePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Analyze text",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 🔹 Bottom Navigation
                    _buildBottomNav(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAnalyzePressed() {
    String text = textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter some text to analyze."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show analyzing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(width: 20),
            Text("Analyzing text..."),
          ],
        ),
      ),
    );

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _showAnalysisResult(text);
    });
  }

  void _showAnalysisResult(String text) {
    // Simple analysis logic (replace with your ML model)
    bool isHarmful = _containsHarmfulKeywords(text);
    String result = isHarmful
        ? "Potential harmful content detected"
        : "No harmful content detected";
    Color color = isHarmful ? Colors.red : Colors.green;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Analysis Result",
          style: TextStyle(color: AppColors.primary),
        ),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    // Add to recent checks
    _addToRecentChecks(text, isHarmful ? "High Risk" : "Low Risk");
  }

  bool _containsHarmfulKeywords(String text) {
    final harmfulKeywords = [
      'hate',
      'kill',
      'stupid',
      'ugly',
      'worthless',
      'die',
      'hurt',
      'attack',
      'threat',
      'bully',
      'abuse'
    ];

    String lowerText = text.toLowerCase();
    return harmfulKeywords.any((keyword) => lowerText.contains(keyword));
  }

  void _addToRecentChecks(String text, String riskLevel) {
    // You can integrate this with your RecentChecksManager
    print("Text analysis completed: $riskLevel");
  }

  // 🔹 Bottom Navigation
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavIcon(Icons.home, true),
          _buildNavIcon(Icons.search, false),
          _buildNavIcon(Icons.history, false),
          _buildNavIcon(Icons.person, false),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
*/
// lib/screens/analyze_text_screen.dart

/*import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class AnalyzeTextScreen extends StatefulWidget {
  const AnalyzeTextScreen({super.key});

  @override
  State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
}

class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
  final TextEditingController textController = TextEditingController();
  int _selectedIndex = 0; // used by bottom nav to show selection

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _onAnalyzePressed() {
    final text = textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text to analyze.")),
      );
      return;
    }

    // TODO: call ML / API for analysis
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Analyzing text... (demo)")),
    );
  }

  void _onBottomNavTap(int idx) {
    setState(() => _selectedIndex = idx);

    // Provide basic navigation behavior for index 0 (home). Replace with full routing as needed.
    if (idx == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }

    // For other indexes, show a placeholder message (replace with real navigation)
    final labels = ['Home', 'Messages', 'History', 'Profile'];
    final label = (idx >= 0 && idx < labels.length) ? labels[idx] : 'Item';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped: $label (index $idx)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // allow curved bottom nav overlap
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
          child: Column(
            children: [
              // Top bar with back + title + info
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 26),
                    ),

                    // title
                    const Text(
                      "Cyberbullying\nDetection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    // info
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('About'),
                            content: const Text(
                                'Paste or type any message and press Analyze text to detect harmful content.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'))
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.info_outline, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // subtitle
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Evaluate text for harmful content",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Text box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 22),
                padding: const EdgeInsets.all(14),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: TextField(
                  controller: textController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Paste or type the message you want to analyze....",
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Analyze button
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _onAnalyzePressed,
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text(
                    "Analyze text",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                  ),
                ),
              ),

              const Spacer(),

              // Bottom nav (floating curved)
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, 8))
                      ],
                    ),
                    child: Row(
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
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 26,
          color: selected ? AppColors.primary : Colors.white,
        ),
      ),
    );
  }
}
*/

// lib/screens/analyze_text_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../services/api_service.dart';

class AnalyzeTextScreen extends StatefulWidget {
  const AnalyzeTextScreen({super.key});

  @override
  State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
}

class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _resultLabel; // "Harmful" / "Not harmful"
  double? _harmScore; // 0.0 - 1.0
  String? _errorMessage;

  // threshold for marking harmful
  final double threshold = 0.6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidProbability(double? v) => v != null && v >= 0.0 && v <= 1.0;

  Future<void> _analyze() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorMessage = "Please enter text to analyze.");
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _resultLabel = null;
      _harmScore = null;
    });

    try {
      // call ApiService; pass threshold if you want server-side thresholding
      final Map<String, dynamic> data =
          await ApiService.analyzeText(text, threshold: threshold);

      // The Flask API returns keys: prediction (0/1), probability (0.0-1.0), rule (string)
      int? prediction;
      double? probability;
      String? rule;

      if (data.containsKey('prediction')) {
        final pRaw = data['prediction'];
        if (pRaw is int)
          prediction = pRaw;
        else if (pRaw is String)
          prediction = int.tryParse(pRaw);
        else if (pRaw is num) prediction = pRaw.toInt();
      }

      if (data.containsKey('probability')) {
        final probRaw = data['probability'];
        if (probRaw is num)
          probability = probRaw.toDouble();
        else if (probRaw is String) probability = double.tryParse(probRaw);
      }

      if (data.containsKey('rule')) {
        rule = data['rule']?.toString();
      }

      // fallbacks: sometimes API might return 'probabilities' list
      if (probability == null && data.containsKey('probabilities')) {
        try {
          final p = data['probabilities'];
          if (p is List && p.length >= 2) {
            final maybe = p[1];
            if (maybe is num) probability = maybe.toDouble();
          }
        } catch (_) {}
      }

      // Determine final label & confidence for the UI
      String finalLabel;
      double finalScore;

      if (probability != null && _isValidProbability(probability)) {
        finalScore = probability;
        finalLabel = (probability >= threshold) ? "Harmful" : "Not harmful";
      } else if (prediction != null) {
        finalLabel = (prediction == 1) ? "Harmful" : "Not harmful";
        finalScore = (prediction == 1) ? 0.9 : 0.1;
      } else {
        finalLabel = "Unknown";
        finalScore = 0.0;
      }

      // Optional: show rule in debug/errorMessage area (or add a small widget)
      if (rule != null && rule.isNotEmpty) {
        _errorMessage = null; // clear previous error
        // You may want to show rule to user or log it; here we set errorMessage as a small note:
        // (Alternatively create a new state field like _provenance)
      }

      if (mounted) {
        setState(() {
          _resultLabel = finalLabel;
          _harmScore = finalScore;
          // store rule if you want to display it (optional)
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _resultCard() {
    if (_resultLabel == null && _errorMessage == null)
      return const SizedBox.shrink();

    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final scorePct = (_harmScore ?? 0.0) * 100.0;
    final isHarmful = _resultLabel == "Harmful";
    final color = isHarmful ? Colors.red : Colors.green.shade700;
    final subtitle =
        isHarmful ? "This text is likely harmful" : "This text is likely safe";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(isHarmful ? Icons.warning_amber_rounded : Icons.check_circle,
              color: color),
          const SizedBox(width: 10),
          Text(_resultLabel ?? "Result",
              style: AppText.heading.copyWith(fontSize: 18)),
          const Spacer(),
          Text("${scorePct.toStringAsFixed(1)}%",
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ]),
        const SizedBox(height: 8),
        Text(subtitle, style: AppText.body.copyWith(color: Colors.black54)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_harmScore ?? 0.0),
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPad = 12;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Cyberbullying Detection"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFE8F3FF), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, topPad, 18, 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Text("Evaluate text for harmful content",
                  style: AppText.body.copyWith(color: Colors.black54)),
              const SizedBox(height: 18),

              // Input box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 6))
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
              const SizedBox(height: 18),

              // Analyze Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search),
                  label: Text(_loading ? "Analyzing..." : "Analyze text",
                      style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: _loading ? null : _analyze,
                ),
              ),

              const SizedBox(height: 18),

              // Result / Error
              _resultCard(),

              const SizedBox(height: 18),

              // helper note
              Text(
                  "Tip: We mark content as harmful if model confidence >= ${(threshold * 100).toStringAsFixed(0)}%",
                  style: AppText.body.copyWith(color: Colors.black54)),
            ]),
          ),
        ),
      ),
    );
  }
}
