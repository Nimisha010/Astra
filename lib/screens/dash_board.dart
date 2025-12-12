import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: Text(
          'Dashboard Screen - Under Construction',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
