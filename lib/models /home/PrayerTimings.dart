import 'package:intl/intl.dart';

class PrayerTimings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    final bool use24Hour = _deviceUses24HourFormat();

    return PrayerTimings(
      fajr: _formatTime(json['Fajr'], use24Hour),
      sunrise: _formatTime(json['Sunrise'], use24Hour),
      dhuhr: _formatTime(json['Dhuhr'], use24Hour),
      asr: _formatTime(json['Asr'], use24Hour),
      maghrib: _formatTime(json['Maghrib'], use24Hour),
      isha: _formatTime(json['Isha'], use24Hour),
    );
  }

  static bool _deviceUses24HourFormat() {
    final now = DateTime.now();
    final localTime = DateFormat.jm().format(now);
    // لو النتيجة فيها AM/PM يبقى الجهاز بيستخدم 12 ساعة
    return !localTime.contains(RegExp(r'AM|PM', caseSensitive: false));
  }

  static String _formatTime(String time24, bool use24Hour) {
    try {
      final date = DateFormat("HH:mm").parse(time24);
      if (use24Hour) {
        return DateFormat("HH:mm").format(date);
      } else {
        return DateFormat("h:mm").format(date); // بدون AM/PM
      }
    } catch (e) {
      return time24;
    }
  }

  ({String prayer, Duration duration})? getNextPrayerAndDuration() {
    final now = DateTime.now();
    final formatter = DateFormat("HH:mm");

    final times = {
      "الفجر": fajr,
      "الشروق": sunrise,
      "الظهر": dhuhr,
      "العصر": asr,
      "المغرب": maghrib,
      "العشاء": isha,
    };

    for (final entry in times.entries) {
      final prayerName = entry.key;
      final timeStr = entry.value;

      try {
        final time = formatter.parse(timeStr);
        final todayPrayerTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        if (todayPrayerTime.isAfter(now)) {
          final duration = todayPrayerTime.difference(now);
          return (prayer: prayerName, duration: duration);
        }
      } catch (_) {
        continue;
      }
    }

    final time = formatter.parse(fajr);
    final nextDayFajr = DateTime(
      now.year,
      now.month,
      now.day + 1,
      time.hour,
      time.minute,
    );
    final duration = nextDayFajr.difference(now);

    return (prayer: "الفجر", duration: duration);
  }
}
