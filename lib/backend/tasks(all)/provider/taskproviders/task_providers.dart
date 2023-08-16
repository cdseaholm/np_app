import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dateProvider = StateProvider<String>((ref) {
  return 'mm/dd/yy';
});

final timeProvider = StateProvider<String>((ref) {
  return 'hh : mm';
});

final repeatingProvider = StateProvider<String>((ref) {
  return 'Repeating?';
});

final categoryColorRadioProvider = StateProvider<String>((ref) {
  return colorToHex(Colors.transparent);
});

final categoryNameRadioProvider = StateProvider<String>((ref) {
  return "Select Category";
});
