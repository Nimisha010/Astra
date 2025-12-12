import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // body: ListView(
      //   padding: const EdgeInsets.all(16),
      //   children: [
      //     _buildNotificationCard(
      //       "Text Analysis Completed",
      //       "Your last cyberbullying analysis result is ready.",
      //       Icons.check_circle,
      //     ),
      //     const SizedBox(height: 12),
      //     _buildNotificationCard(
      //       "Image Verified",
      //       "No manipulation detected in your recent uploaded image.",
      //       Icons.verified_user,
      //     ),
      //     const SizedBox(height: 12),
      //     _buildNotificationCard(
      //       "Safety Alert",
      //       "Learn how to stay safe online with new protection tips.",
      //       Icons.warning_amber_rounded,
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildNotificationCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.heading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppText.body.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
