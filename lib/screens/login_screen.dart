// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';
// import 'SignUpScreen.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool rememberMe = false;
//   bool obscurePassword = true;

//   String? _emailError;
//   String? _passwordError;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   void _showSnack(String message) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _onLoginPressed() {
//     final email = emailController.text.trim();
//     final password = passwordController.text;

//     // Reset errors
//     setState(() {
//       _emailError = null;
//       _passwordError = null;
//     });

//     // Validate
//     bool hasError = false;
//     if (email.isEmpty) {
//       _emailError = "Email cannot be empty";
//       hasError = true;
//     }
//     if (password.isEmpty) {
//       _passwordError = "Password cannot be empty";
//       hasError = true;
//     }

//     if (hasError) {
//       setState(() {}); // update UI to show error texts
//       _showSnack("Please fill the required fields.");
//       return;
//     }

//     // If validation passes, navigate to HomeScreen (replace with actual auth later)
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const HomeScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Container(
//         height: height, // Ensure full height
//         width: width, // Ensure full width
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
//               crossAxisAlignment: CrossAxisAlignment
//                   .start, // Changed to start for left alignment
//               children: [
//                 // 🔹 Logo - Aligned to left
//                 Container(
//                   height: height * 0.25,
//                   width: height * 0.25, // Square container for logo
//                   alignment: Alignment.centerLeft, // Left align
//                   child: Image.asset(
//                     'assets/astra_logo.png',
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

//                 // 🔹 LOGIN Title - Also aligned to left
//                 const Text(
//                   "LOGIN",
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Times New Roman',
//                     color: Color(0xFF1565C0),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // 🔹 Email TextField
//                 TextField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     prefixIcon:
//                         const Icon(Icons.email, color: AppColors.primary),
//                     labelText: "Email",
//                     labelStyle: const TextStyle(color: AppColors.primary),
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide:
//                           BorderSide(color: AppColors.primary, width: 2),
//                     ),
//                     errorText: _emailError,
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 // 🔹 Password TextField
//                 TextField(
//                   controller: passwordController,
//                   obscureText: obscurePassword,
//                   decoration: InputDecoration(
//                     prefixIcon:
//                         const Icon(Icons.lock, color: AppColors.primary),
//                     labelText: "Password",
//                     labelStyle: const TextStyle(color: AppColors.primary),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: AppColors.primary,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           obscurePassword = !obscurePassword;
//                         });
//                       },
//                     ),
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide:
//                           BorderSide(color: AppColors.primary, width: 2),
//                     ),
//                     errorText: _passwordError,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // 🔹 Remember me + Forgot password
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: rememberMe,
//                           activeColor: AppColors.primary,
//                           onChanged: (value) {
//                             setState(() {
//                               rememberMe = value!;
//                             });
//                           },
//                         ),
//                         const Text("Remember me"),
//                       ],
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Forgot password?",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // 🔹 Login Button
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
//                     onPressed: _onLoginPressed,
//                     child: const Text(
//                       "LOGIN",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // 🔹 Sign Up text - Centered
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Don't have an account? ",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                       // Replace the current GestureDetector in login_screen.dart
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignUpScreen()),
//                           );
//                         },
//                         child: const Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // 🔹 Add some extra space at the bottom to ensure content doesn't get cut off
//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/* only google not working

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/app_colors.dart';
import 'SignUpScreen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _loginWithEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Reset errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;
    if (email.isEmpty) {
      _emailError = "Email cannot be empty";
      hasError = true;
    }
    if (password.isEmpty) {
      _passwordError = "Password cannot be empty";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      _showSnack("Please fill the required fields.");
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Because of AuthGate in main.dart, screen will change automatically.
      // You CAN also navigate manually if you want:
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Login failed. Please try again.";

      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password. Please try again.";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email format.";
      }

      _showSnack(msg);
    } catch (e) {
      _showSnack("An unexpected error occurred: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 🔹 UPDATED: Google Sign-In for google_sign_in v7+
  Future<void> _loginWithGoogle() async {
    try {
      setState(() => _isLoading = true);

      // Trigger the authentication flow (new API)
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() => _isLoading = false);
        return;
      }

      // Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential (no accessToken in new API)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      if (!mounted) return;

      // Navigate to Home (AuthGate will also handle this)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnack("Google sign-in failed: ${e.message}");
    } catch (e) {
      _showSnack("Google sign-in error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
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
                // 🔹 Logo
                Container(
                  height: height * 0.25,
                  width: height * 0.25,
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/astra_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/astra_logo.jpg',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.security,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 LOGIN Title
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Times New Roman',
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 Email TextField
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.email, color: AppColors.primary),
                    labelText: "Email",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorText: _emailError,
                  ),
                ),
                const SizedBox(height: 25),

                // 🔹 Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.lock, color: AppColors.primary),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorText: _passwordError,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 Remember me + Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showSnack("Forgot password not implemented yet.");
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _loginWithEmailPassword,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 OR divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 Google Sign-In button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      "assets/google_logo.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _loginWithGoogle,
                  ),
                ),

                const SizedBox(height: 25),

                // 🔹 Sign Up text
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/app_colors.dart';
import 'SignUpScreen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // 👈 v6 API

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _loginWithEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;
    if (email.isEmpty) {
      _emailError = "Email cannot be empty";
      hasError = true;
    }
    if (password.isEmpty) {
      _passwordError = "Password cannot be empty";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      _showSnack("Please fill the required fields.");
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Login failed. Please try again.";

      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password. Please try again.";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email format.";
      }

      _showSnack(msg);
    } catch (e) {
      _showSnack("An unexpected error occurred: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// ✅ Google Sign-In using google_sign_in 6.x
  Future<void> _loginWithGoogle() async {
    try {
      setState(() => _isLoading = true);

      // Start the Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnack("Google sign-in failed: ${e.code}");
    } catch (e) {
      _showSnack("Google sign-in error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
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
                // Logo
                Container(
                  height: height * 0.15,
                  width: height * 0.15,
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/astra_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.security,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Times New Roman',
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.email, color: AppColors.primary),
                    labelText: "Email",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorText: _emailError,
                  ),
                ),
                const SizedBox(height: 25),

                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.lock, color: AppColors.primary),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorText: _passwordError,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showSnack("Forgot password not implemented yet.");
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isLoading ? null : _loginWithEmailPassword,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      "assets/google_logo.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _loginWithGoogle,
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
}
