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
