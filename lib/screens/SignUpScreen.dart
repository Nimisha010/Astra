// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   bool obscurePassword = true;
//   bool obscureConfirmPassword = true;

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Container(
//         height: height,
//         width: width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Color(0xFFE3F2FD)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 Back Button
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: AppColors.primary,
//                     size: 24,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // 🔹 Logo
//                 Container(
//                   height: height * 0.15,
//                   width: height * 0.15,
//                   alignment: Alignment.centerLeft,
//                   child: Image.asset(
//                     'assets/astra_logo.jpg',
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Image.asset(
//                         'assets/astra_logo.jpg',
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.primary.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: AppColors.primary,
//                                 width: 2,
//                               ),
//                             ),
//                             child: const Icon(
//                               Icons.security,
//                               size: 40,
//                               color: AppColors.primary,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // 🔹 CREATE AN ACCOUNT Title
//                 const Text(
//                   "Create an account",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Times New Roman',
//                     color: Color(0xFF1565C0),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // 🔹 Name TextField
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       hintText: "Name",
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔹 Email TextField
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       hintText: "Email",
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔹 Password TextField
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: passwordController,
//                     obscureText: obscurePassword,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 16),
//                       hintText: "Password",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             obscurePassword = !obscurePassword;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔹 Confirm Password TextField
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: confirmPasswordController,
//                     obscureText: obscureConfirmPassword,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 16),
//                       hintText: "Confirm Password",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureConfirmPassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             obscureConfirmPassword = !obscureConfirmPassword;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 35),

//                 // 🔹 SIGN UP Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 4,
//                     ),
//                     onPressed: () {
//                       // Add sign up logic here
//                     },
//                     child: const Text(
//                       "SIGN UP",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // 🔹 Add some extra space at the bottom
//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  bool _validateInputs() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pw = passwordController.text;
    final cpw = confirmPasswordController.text;

    if (name.isEmpty) {
      _showSnack("Please enter your name.");
      return false;
    }
    if (email.isEmpty) {
      _showSnack("Please enter your email.");
      return false;
    }
    // Basic email format check
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      _showSnack("Please enter a valid email address.");
      return false;
    }
    if (pw.isEmpty || cpw.isEmpty) {
      _showSnack("Please fill both password fields.");
      return false;
    }
    if (pw.length < 6) {
      _showSnack("Password must be at least 6 characters.");
      return false;
    }
    if (pw != cpw) {
      _showSnack("Passwords do not match.");
      return false;
    }
    return true;
  }

  Future<void> _register() async {
    if (!_validateInputs()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      setState(() => _isLoading = true);

      // Create user
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally set display name
      if (userCred.user != null) {
        await userCred.user!.updateDisplayName(name);
        await userCred.user!.reload(); // refresh user
      }

      // Navigate to Home (or pop to login screen if you prefer)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed. Please try again.";

      if (e.code == 'email-already-in-use') {
        message =
            "This email is already registered. Please login or use another email.";
      } else if (e.code == 'weak-password') {
        message =
            "The password is too weak. Please choose a stronger password.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address.";
      }

      _showSnack(message);
    } catch (e) {
      _showSnack("An unexpected error occurred: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.primary),
                ),

                const SizedBox(height: 10),

                // logo
                Container(
                  height: height * 0.15,
                  width: height * 0.15,
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/madeastralogo.png',
                      fit: BoxFit.contain),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Times New Roman',
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(height: 30),

                // Name
                _buildInputBox(
                  controller: nameController,
                  hint: "Name",
                  prefix: const Icon(Icons.person, color: AppColors.primary),
                ),

                const SizedBox(height: 16),

                // Email
                _buildInputBox(
                  controller: emailController,
                  hint: "Email",
                  prefix: const Icon(Icons.email, color: AppColors.primary),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Password
                _buildPasswordBox(
                  controller: passwordController,
                  hint: "Password",
                  obscure: obscurePassword,
                  onToggle: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),

                const SizedBox(height: 16),

                // Confirm password
                _buildPasswordBox(
                  controller: confirmPasswordController,
                  hint: "Confirm Password",
                  obscure: obscureConfirmPassword,
                  onToggle: () {
                    setState(
                        () => obscureConfirmPassword = !obscureConfirmPassword);
                  },
                ),

                const SizedBox(height: 30),

                // Sign up button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // small helpers to keep build clean
  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    Widget? prefix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefix,
        ),
      ),
    );
  }

  Widget _buildPasswordBox({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
