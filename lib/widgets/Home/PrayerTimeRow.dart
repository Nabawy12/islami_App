import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;

  const PrayerTimeRow({
    required this.name,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final info = prayerData[name] ?? PrayerInfo("assets/icons/default.svg", Colors.grey);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.amiri(fontSize: 22,fontWeight: FontWeight.w500),  // شويه كبرت شويه
          ),
          const SizedBox(height: 10),
          SvgPicture.asset(
            info.iconPath,
            color: info.color,
            width: 30,
            height: 30,
          ),
          const SizedBox(height: 10),
          Text(
            time,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.amiri(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class PrayerInfo {
  final String iconPath;
  final Color color;
  PrayerInfo(this.iconPath, this.color);
}

final Map<String, PrayerInfo> prayerData = {
  "الفجر":    PrayerInfo("assets/icons/fajr.svg",   Colors.blue.shade300),
  "الشروق":   PrayerInfo("assets/icons/sunrise.svg",Colors.orange.shade300),
  "الظهر":    PrayerInfo("assets/icons/dhuhr.svg",  Colors.yellow.shade600),
  "العصر":    PrayerInfo("assets/icons/asr.svg",    Colors.amber.shade700),
  "المغرب":   PrayerInfo("assets/icons/maghrib.svg",Colors.deepOrange.shade400),
  "العشاء":   PrayerInfo("assets/icons/fajr.svg",   Colors.indigo.shade700),
};
