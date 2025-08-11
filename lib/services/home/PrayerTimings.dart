import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../models /home/PrayerTimings.dart';

class PrayerService {
  Future<PrayerTimings?> fetchPrayerTimings() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("خدمة تحديد الموقع غير مفعلة");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("تم رفض إذن الوصول للموقع");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("تم رفض إذن الوصول للموقع نهائيًا");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      final url =
          'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=5';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final timings = jsonBody['data']['timings'];
        return PrayerTimings.fromJson(timings);
      } else {
        print("فشل تحميل مواقيت الصلاة: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("خطأ: $e");
      return null;
    }
  }
}
