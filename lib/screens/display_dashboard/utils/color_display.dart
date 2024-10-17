import 'dart:ui';

import 'package:flutter/material.dart';

Color gaugeDisplay( {double? trustScore,String? trustScoreString}) {

  if (trustScoreString != null) {
    switch (trustScoreString.toLowerCase()) {
      case 'extremely low':
        return Colors.red.shade900; // Dark Red
      case 'very low':
        return Colors.red; // Red
      case 'low':
        return Colors.orange; // Orange
      case 'moderately low':
        return Colors.yellow; // Yellow
      case 'slightly low':
        return Colors.lightGreenAccent; // Light Green
      case 'high':
        return Colors.green; // Green
      default:
        return Colors.grey; // Fallback color
    }
  }

  if (trustScore == null) {
    return Colors.grey;
  }

  if (trustScore >= 0 && trustScore < 15) {
    return Colors.red.shade900; // Extremely Low (Dark Red)
  } else if (trustScore >= 15 && trustScore < 25) {
    return Colors.red; // Very Low (Red)
  } else if (trustScore >= 25 && trustScore < 38) {
    return Colors.orange; // Low (Orange)
  } else if (trustScore >= 38 && trustScore < 48) {
    return Colors.yellow; // Moderately Low (Yellow)
  } else if (trustScore >= 49 && trustScore < 70) {
    return Colors.lightGreenAccent; // Slightly Low (Light Green)
  } else if (trustScore >= 70 && trustScore <= 100) {
    return Colors.green; // High (Green)
  } else {
    return Colors.grey;
  }
}

String trustScoreDescription({required double trustScore}) {
  if (trustScore >= 0 && trustScore < 15) {
    return "Extremely Low"; // Dark Red
  } else if (trustScore >= 15 && trustScore < 25) {
    return "Very Low"; // Red
  } else if (trustScore >= 25 && trustScore < 38) {
    return "Low"; // Orange
  } else if (trustScore >= 38 && trustScore < 48) {
    return "Moderately Low"; // Yellow
  } else if (trustScore >= 49 && trustScore < 70) {
    return "Slightly Low"; // Light Green
  } else if (trustScore >= 70 && trustScore <= 100) {
    return "High"; // Green
  } else {
    return "Invalid Score"; // Fallback for out of range values
  }
}

double getFieldGaugeValue(String trustScoreString) {
  switch (trustScoreString.toLowerCase()) {
    case 'normal':
      return 6; // Normal
    case 'slightly low':
      return 5; // Slightly Low
    case 'moderately low':
      return 4; // Moderately Low
    case 'low':
      return 3; // Low
    case 'very low':
      return 1.7; // Very Low
    case 'extremely low':
      return 0.3;// Extremely Low
    default:
      return 6; // Fallback for invalid string input or dark red (you can customize this value)
  }
}

Color getFieldGaugeColor (String trustScoreString) {
  switch (trustScoreString.toLowerCase()) {
    case 'normal':
      return Colors.green; // Normal
    case 'slightly low':
      return Colors.lightGreenAccent; // Slightly Low
    case 'moderately low':
      return Colors.yellow; // Moderately Low
    case 'low':
      return Colors.orange; // Low
    case 'very low':
      return Colors.red; // Very Low
    case 'extremely low':
      return Colors.red.shade900;// Extremely Low
    default:
      return Colors.red.shade900; // Fallback for invalid string input or dark red (you can customize this value)
  }
}
