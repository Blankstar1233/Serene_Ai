import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for Serene AI
/// Using Inter for headings and Nunito Sans for body text
class AppTypography {
  static const double baseFontSize = 16.0;
  static const double lineHeight = 1.6;

  // Font families
  static const String headingFont = 'Inter';
  static const String bodyFont = 'Nunito Sans';

  // Heading styles using Inter
  static TextStyle h1({Color? color}) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: lineHeight,
    color: color,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: lineHeight,
    color: color,
  );

  static TextStyle h3({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: lineHeight,
    color: color,
  );

  static TextStyle h4({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: lineHeight,
    color: color,
  );

  static TextStyle h5({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: lineHeight,
    color: color,
  );

  // Body text styles using Nunito Sans
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: lineHeight,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: baseFontSize,
    fontWeight: FontWeight.normal,
    height: lineHeight,
    color: color,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: lineHeight,
    color: color,
  );

  // Special text styles
  static TextStyle greeting({Color? color}) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: lineHeight,
    color: color,
  );

  static TextStyle cardTitle({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: lineHeight,
    color: color,
  );

  static TextStyle cardSubtitle({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: lineHeight,
    color: color,
  );

  static TextStyle buttonText({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: lineHeight,
    color: color,
  );

  static TextStyle caption({Color? color}) => GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: lineHeight,
    color: color,
  );
}
