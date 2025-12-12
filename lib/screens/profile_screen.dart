// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../utils/app_colors.dart';
// import 'login_screen.dart'; // 👈 add this import

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text(
//           "My Account",
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "User Information",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Email
//             Row(
//               children: [
//                 const Icon(Icons.email, color: AppColors.primary),
//                 const SizedBox(width: 12),
//                 Text(
//                   user?.email ?? "No email found",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // UID
//             Row(
//               children: [
//                 const Icon(Icons.fingerprint, color: AppColors.primary),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     user?.uid ?? "No UID",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 40),

//             // Logout button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Logout",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 onPressed: () async {
//                   await FirebaseAuth.instance.signOut();

//                   // 🔥 Clear all routes and go to LoginScreen
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                       builder: (_) => const LoginScreen(),
//                     ),
//                     (route) => false,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE PHOTO
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person,
                        size: 50, color: AppColors.primary)
                    : null,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "User Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // NAME
            Row(
              children: [
                const Icon(Icons.person, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user?.displayName ?? "Name not available",
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // EMAIL
            Row(
              children: [
                const Icon(Icons.email, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user?.email ?? "No email found",
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // LOGOUT BUTTON
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
