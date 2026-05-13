import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../utils/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationService = NotificationService();

  List<Map<String, dynamic>> get notifications =>
      notificationService.notifications;

  @override
  void initState() {
    super.initState();
    notificationService.addListener(_refresh);
  }

  @override
  void dispose() {
    notificationService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  /// ---------------- TIME FORMAT ----------------
  String getTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} day ago";
  }

  /// ---------------- SECTION TYPE ----------------
  String getSection(DateTime time) {
    final now = DateTime.now();

    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return "Today";
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (time.year == yesterday.year &&
        time.month == yesterday.month &&
        time.day == yesterday.day) {
      return "Yesterday";
    }

    return "Earlier";
  }

  List<Map<String, dynamic>> filterSection(String section) {
    return notifications
        .where((n) => getSection(n["timestamp"]) == section)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final today = filterSection("Today");
    final yesterday = filterSection("Yesterday");
    final earlier = filterSection("Earlier");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            const Text("Notifications"),
            const SizedBox(width: 8),
            if (notificationService.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notificationService.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all read",
            onPressed: notificationService.markAllRead,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: "Clear all",
            onPressed: () {
              setState(() {
                notificationService.clearAll();
              });
            },
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
        child: notifications.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No notifications yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (today.isNotEmpty) _buildSection("Today", today),
                  if (yesterday.isNotEmpty)
                    _buildSection("Yesterday", yesterday),
                  if (earlier.isNotEmpty) _buildSection("Earlier", earlier),
                ],
              ),
      ),
    );
  }

  void _openNotificationDetails(Map<String, dynamic> item) {
    final data = item["data"] ?? {};

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item["title"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["message"]),
            const SizedBox(height: 12),
            if (data["type"] == "text") ...[
              const Text("Detected Text:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data["text"] ?? ""),
              const SizedBox(height: 10),
              Text(
                  "Confidence: ${(data["confidence"] * 100).toStringAsFixed(1)}%"),
            ],
            if (data["type"] == "morph") ...[
              const Text("Result:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data["result"]),
              const SizedBox(height: 10),
              Text(
                  "Confidence: ${(data["confidence"] * 100).toStringAsFixed(1)}%"),
            ],
            if (data["type"] == "complaint") ...[
              const Text("Platform:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data["platform"] ?? ""),
              const SizedBox(height: 8),
              const Text("Offender ID:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data["offender"] ?? ""),
              const SizedBox(height: 8),
              const Text("Description:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data["description"] ?? ""),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  /// ---------------- SECTION ----------------
  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, style: AppText.heading.copyWith(fontSize: 16)),
        ),
        ...items.map((item) {
          return Dismissible(
            key: ValueKey(item["id"]),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              notificationService.remove(item["id"]);
            },
            child: GestureDetector(
              onTap: () {
                notificationService.markRead(item["id"]);
                _openNotificationDetails(item);
              },
              child: _buildNotificationCard(item),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------------- CARD ----------------
  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final timeAgo = getTimeAgo(item["timestamp"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item["read"] ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item["color"].withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item["icon"], color: item["color"]),
          ),

          const SizedBox(width: 12),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: AppText.heading.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  item["message"],
                  style: AppText.body.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// Unread dot
          if (!item["read"])
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
