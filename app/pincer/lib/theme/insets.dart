import 'package:flutter/material.dart';

/// A utility class for defining common spacing values in the app.
///
/// This class provides a centralized way to manage spacing values such as padding and margins, ensuring consistency
/// throughout the app's UI. It defines several static constants for different spacing sizes and corresponding
/// [EdgeInsets] for easy use with Flutter widgets.
class Insets {
  /// Small spacing value, typically used for tight spacing.
  static const double small = 8.0;

  /// Medium spacing value, ideal for default spacing.
  static const double medium = 16.0;

  /// Large spacing value, used for more pronounced spacing.
  static const double large = 24.0;

  /// Extra large spacing value, for large spacing.
  static const double extraLarge = 32.0;

  /// Extra, extra large spacing value, for maximum spacing.
  static const double extraExtraLarge = 128.0;

  /// EdgeInsets with small spacing for all sides.
  static const EdgeInsets paddingSmall = EdgeInsets.all(small);

  /// EdgeInsets with medium spacing for all sides.
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);

  /// EdgeInsets with large spacing for all sides.
  static const EdgeInsets paddingLarge = EdgeInsets.all(large);

  /// EdgeInsets with extra large spacing for all sides.
  static const EdgeInsets paddingExtraLarge = EdgeInsets.all(extraLarge);

  /// EdgeInsets with maximum spacing for all sides.
  static const EdgeInsets paddingExtraExtraLarge = EdgeInsets.all(extraExtraLarge);
}