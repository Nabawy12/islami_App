import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islami_app/core/Colors/colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../core/LastReadService/lastread.dart';
import '../../../widgets/Quran/surah.dart';

class SurahScreen extends StatefulWidget {
  static const String routeName = '/surahScreen';
  final String? filePath;
  final int? surahIndex;
  final int? initialAyahNumber;

  const SurahScreen({
    Key? key,
     this.filePath,
     this.surahIndex,
    this.initialAyahNumber,
  }) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  late Future<List<String>> _versesFuture;
  final ItemScrollController _scrollController = ItemScrollController();
  MianColors mianColors = MianColors();
  @override
  void initState() {
    super.initState();
    _versesFuture = _loadVerses();
  }

  Future<List<String>> _loadVerses() async {
    final text = await rootBundle.loadString(widget.filePath!);
    final verses = text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialAyahNumber != null && verses.isNotEmpty) {
        final index = (widget.initialAyahNumber! - 1).clamp(0, verses.length - 1);
        if (_scrollController.isAttached) {
          _scrollController.jumpTo(index: index);
        } else {
          // لو مش attached، نأخر قليلًا ثم نقفز
          Future.delayed(const Duration(milliseconds: 200), () {
            if (_scrollController.isAttached) {
              _scrollController.jumpTo(index: index);
            }
          });
        }
      }
    });
    return verses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: Text(surahNames[widget.surahIndex!]),
        backgroundColor: mianColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      body: FutureBuilder<List<String>>(
        future: _versesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('تعذر تحميل السورة'));
          }
          final verses = snapshot.data!;

          return ScrollablePositionedList.builder(
            itemScrollController: _scrollController,
            itemCount: verses.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final ayahNumber = index + 1;
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      '${verses[index]}  ﴿$ayahNumber﴾',
                      style: const TextStyle(fontSize: 20, height: 1.6, fontFamily: 'Amiri'),
                    ),
                  ),
                  onTap: () async {
                    await LastReadService.saveLastRead(widget.surahIndex!, ayahNumber);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('حُفِظ: ${surahNames[widget.surahIndex!]} آية $ayahNumber')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
