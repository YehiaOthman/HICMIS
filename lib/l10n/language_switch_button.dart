import 'package:backtotrack/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return TextButton.icon(
      onPressed: localeProvider.toggle,
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF2353D0)),
      icon: Icon(Icons.language, size: 18.r),
      label: Text(
        localeProvider.isArabic ? 'English' : 'العربية',
        style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}
