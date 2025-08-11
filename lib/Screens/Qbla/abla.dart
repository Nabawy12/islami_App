import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami_app/core/Colors/colors.dart';

class QiblaScreen extends StatefulWidget {
  static const String routeName = '/qiblaScreen';
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _heading; // اتجاه الجهاز
  double? _qiblaDirection; // زاوية القبلة
  bool _isFacingQibla = false;

  @override
  void initState() {
    super.initState();
    _getLocationAndQibla();
    FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading;
        _checkIfFacingQibla();
      });
    });
  }

  Future<void> _getLocationAndQibla() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _qiblaDirection =
        _calculateQiblaDirection(position.latitude, position.longitude);
  }

  double _calculateQiblaDirection(double lat, double lon) {
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;

    double latRad = lat * pi / 180;
    double lonRad = lon * pi / 180;
    double kaabaLatRad = kaabaLat * pi / 180;
    double kaabaLonRad = kaabaLon * pi / 180;

    double deltaLon = kaabaLonRad - lonRad;

    double y = sin(deltaLon) * cos(kaabaLatRad);
    double x = cos(latRad) * sin(kaabaLatRad) -
        sin(latRad) * cos(kaabaLatRad) * cos(deltaLon);

    double direction = atan2(y, x) * 180 / pi;
    return (direction + 360) % 360;
  }

  void _checkIfFacingQibla() {
    if (_heading == null || _qiblaDirection == null) return;
    double diff = (_qiblaDirection! - _heading!).abs();
    if (diff > 180) diff = 360 - diff;
    _isFacingQibla = diff < 2;
  }
  MianColors mianColors = MianColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(
            'اتجاه القبلة',
          style: GoogleFonts.amiri(
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: mianColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_heading != null && _qiblaDirection != null)
              Transform.rotate(
                angle: ((_qiblaDirection! - _heading!) * (pi / 180)),
                child: Icon(
                  Icons.navigation,
                  size: 150,
                  color: _isFacingQibla ? Colors.green : Colors.grey,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _isFacingQibla
                  ? "أنت الآن في اتجاه القبلة ✅"
                  : "لف حتى تصل لاتجاه القبلة...",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
