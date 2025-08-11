import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LastReadService {
  static const _kSurahIndex = 'last_surah_index';
  static const _kAyahNumber = 'last_ayah_number';

  static ValueNotifier<Map<String,int>?> lastReadNotifier = ValueNotifier(null);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final si = prefs.getInt(_kSurahIndex);
    final an = prefs.getInt(_kAyahNumber);
    if (si != null && an != null) {
      lastReadNotifier.value = {'surahIndex': si, 'ayahNumber': an};
    } else {
      lastReadNotifier.value = null;
    }
  }


  static Future<void> saveLastRead(int surahIndex, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kSurahIndex, surahIndex);
    await prefs.setInt(_kAyahNumber, ayahNumber);

    lastReadNotifier.value = {'surahIndex': surahIndex, 'ayahNumber': ayahNumber};
  }

  static Future<Map<String,int>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final si = prefs.getInt(_kSurahIndex);
    final an = prefs.getInt(_kAyahNumber);
    if (si == null || an == null) return null;
    return {'surahIndex': si, 'ayahNumber': an};
  }

  static Future<void> clearLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSurahIndex);
    await prefs.remove(_kAyahNumber);
    lastReadNotifier.value = null;
  }
}
