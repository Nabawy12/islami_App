import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami_app/core/Colors/colors.dart';
import 'package:islami_app/widgets/Home/dailySura.dart';
import '../../models /home/PrayerTimings.dart';
import '../../services/home/PrayerTimings.dart';
import '../../widgets/Home/Feature.dart';
import '../../widgets/Home/PrayerTimeRow.dart';
import '../../widgets/Home/lastreadwidget.dart';
import '../Qbla/abla.dart';
import '../Quran/Quran.dart';
import '../Tasbeeh/tasbeeh.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';
  final PrayerTimings? prayerTimings;
  static PrayerService prayerService = PrayerService();

   HomeScreen({super.key, this.prayerTimings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String prayerName = '';
  String prayerDuration = '';
  Timer? _timer;
  PrayerTimings? _timings;

  @override
  void initState() {
    super.initState();
    _timings = widget.prayerTimings;
    if (_timings == null) {
      _fetchTimings();
    } else {
      _startPrayerCountdown();
    }
  }

  Future<void> _fetchTimings() async {
    final timings = await HomeScreen.prayerService.fetchPrayerTimings();
    if (mounted) {
      setState(() {
        _timings = timings;
      });
      _startPrayerCountdown();
    }
  }

  void _startPrayerCountdown() {
    if (_timings == null) return;
    _updatePrayerTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updatePrayerTime();
    });
  }

  void _updatePrayerTime() {
    if (_timings == null) return;
    final result = _timings!.getNextPrayerAndDuration();
    if (result != null) {
      final duration = result.duration;
      setState(() {
        prayerName = result.prayer;
        prayerDuration =
        "${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}";
      });
    } else {
      setState(() {
        prayerName = "—";
        prayerDuration = "--:--";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainColors = MianColors();
    if (_timings == null) {
      return Scaffold(
        backgroundColor: mainColors.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final data = _timings!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mainColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_back2.jpg"),
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "باقي علي $prayerName",
                    style: GoogleFonts.cairo(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    prayerDuration.isNotEmpty ? prayerDuration : "--:--",
                    style: GoogleFonts.cairo(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrayerTimeRow(name: "العشاء", time: data.isha),
                            PrayerTimeRow(name: "المغرب", time: data.maghrib),
                            PrayerTimeRow(name: "العصر", time: data.asr),
                            PrayerTimeRow(name: "الظهر", time: data.dhuhr),
                            PrayerTimeRow(name: "الفجر", time: data.fajr),
                          ],
                        ),
                        const SizedBox(height: 20),
                        IslamicFeaturesGrid(
                          features: [
                            IslamicFeature(
                                icon: Icons.menu_book,
                                label: "القرآن",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, QuranScreen.routeName);
                                }),
                            IslamicFeature(
                                icon: Icons.star_rate,
                                label: "احاديث",
                                onTap: () {}),
                            IslamicFeature(
                                icon: Icons.pan_tool_alt,
                                label: "دعاء",
                                onTap: () {}),
                            IslamicFeature(
                                icon: Icons.brightness_low,
                                label: "تسبيح",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, TasbeehScreen.routeName);
                                }),
                            IslamicFeature(
                                icon: Icons.explore,
                                label: "القبله",
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, QiblaScreen.routeName);
                                }),
                          ],
                        ),
                        const LastReadWidget(),
                        const DailyAyahFromFiles(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
