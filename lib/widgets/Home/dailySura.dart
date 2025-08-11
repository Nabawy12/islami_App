import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../Quran/surah.dart';

class DailyAyahFromFiles extends StatefulWidget {
  const DailyAyahFromFiles({super.key});

  @override
  State<DailyAyahFromFiles> createState() => _DailyAyahFromFilesState();
}

class _DailyAyahFromFilesState extends State<DailyAyahFromFiles> {
  String? ayahText;
  String? surahName;

  @override
  void initState() {
    super.initState();
    _loadDailyAyah();
  }

  Future<void> _loadDailyAyah() async {
    String manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> quranFiles = manifestMap.keys
        .where((path) => path.startsWith('assets/quran/') && path.endsWith('.txt'))
        .toList();

    quranFiles.sort((a, b) {
      int numA = int.parse(a.split('/').last.split('.').first);
      int numB = int.parse(b.split('/').last.split('.').first);
      return numA.compareTo(numB);
    });

    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);

    final randomSurahFile = quranFiles[random.nextInt(quranFiles.length)];
    String surahContent = await rootBundle.loadString(randomSurahFile);
    List<String> ayahs = surahContent.split('\n').where((line) => line.trim().isNotEmpty).toList();

    final randomAyah = ayahs[random.nextInt(ayahs.length)];

    int surahIndex = int.parse(randomSurahFile.split('/').last.split('.').first) - 1;

    setState(() {
      ayahText = randomAyah;
      surahName = surahNames[surahIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ayahText == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  ": آيه اليوم",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "من سورة $surahName",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                ayahText!,
                style: const TextStyle(fontSize: 18, height: 1.6),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
