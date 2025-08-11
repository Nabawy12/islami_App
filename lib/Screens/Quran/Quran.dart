import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app/Screens/Quran/Surah/Surah.dart';
import 'package:islami_app/core/Colors/colors.dart';

import '../../widgets/Quran/surah.dart';

class QuranScreen extends StatelessWidget {
  static const String routeName = '/quranScreen';
   QuranScreen({super.key});

  Future<List<String>> loadQuranFiles() async {
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

    return quranFiles;
  }

  MianColors mainColors = MianColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        centerTitle: true,
        backgroundColor: mainColors.primaryColor,
      ),
      body: FutureBuilder<List<String>>(
        future: loadQuranFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لم يتم العثور على ملفات القرآن'));
          }

          final files = snapshot.data!;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: files.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColors.secondaryColor,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      surahNames[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    trailing:  Icon(
                      Icons.menu_book_rounded,
                      color: mainColors.secondaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahScreen(
                            filePath: 'assets/quran/${index + 1}.txt',
                            surahIndex: index!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
