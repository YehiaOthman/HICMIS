
import 'package:backtotrack/screens/login/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Check Your Email', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Custom Circular Icon with Checkmark
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF2353D0).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2353D0).withOpacity(0.2), width: 2),
                    ),
                    child: const Icon(Icons.email_outlined, color: Color(0xFF2353D0), size: 40),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF2353D0), shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text('Link Sent!', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              'A password reset link has been sent to your email address. Please check your inbox and follow the instructions.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 40),
            // Info Box
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFFB800).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.email_outlined, color: Color(0xFFFFB800), size: 20),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SENT TO', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                      Text(email, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                      Text('Link expires in 30 minutes', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              text: 'Back to Sign In',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {},
              child: Text('Resend Email', style: GoogleFonts.poppins(color: Color(0xFF2353D0), fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}