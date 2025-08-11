import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Screens/Quran/Surah/Surah.dart';
import '../../core/Colors/colors.dart';
import '../../core/LastReadService/lastread.dart';
import '../Quran/surah.dart';

class LastReadWidget extends StatelessWidget {
  const LastReadWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MianColors mainColors = MianColors() ;
    return ValueListenableBuilder<Map<String,int>?>(
      valueListenable: LastReadService.lastReadNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.bookmark_add_outlined),
              title:  Text(
                'لم تقرأ أي آية بعد',
                style: GoogleFonts.amiri(
                  fontSize: 17,
                ),
              ),
              subtitle:  Text(
                  'سيظهر آخر موضع مقروء هنا',
                style: GoogleFonts.amiri(
                fontSize: 18,
              ),
            ),
            ),
          );
        }

        final surahIndex = value['surahIndex']!;
        final ayahNumber = value['ayahNumber']!;
        final surahName = (surahIndex >= 0 && surahIndex < surahNames.length)
            ? surahNames[surahIndex]
            : 'سورة';

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: mainColors.primaryColor,
              child: Text('${surahIndex + 1}', style: const TextStyle(color: Colors.white,fontSize: 19)),
            ),
            title: Text(
                surahName,
                style: GoogleFonts.amiri(
                  fontSize: 19,
                ),

            ),
            subtitle: Text(
                'آخر قراءة: آية $ayahNumber',
              style: GoogleFonts.amiri(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurahScreen(
                    filePath: 'assets/quran/${surahIndex + 1}.txt',
                    surahIndex: surahIndex,
                    initialAyahNumber: ayahNumber,
                  ),
                ),
              );
            },
            onLongPress: () async {
              await LastReadService.clearLastRead();
            },
          ),
        );
      },
    );
  }
}
