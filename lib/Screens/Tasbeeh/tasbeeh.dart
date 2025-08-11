import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/Colors/colors.dart'; // for HapticFeedback

class TasbeehScreen extends StatefulWidget {
  static const String routeName = '/tasbeehScreen';
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> with SingleTickerProviderStateMixin {
  int _count = 0;

  final List<String> _dhikrList = ['سبحان الله', 'الحمد لله', 'الله أكبر'];
  final int perCycle = 33;

  late final AnimationController _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.0,
    upperBound: 0.08,
  );

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  int get _currentDhikrIndex {
    return ((_count) ~/ perCycle) % _dhikrList.length;
  }

  String get _currentDhikr => _dhikrList[_currentDhikrIndex];

  int get _remainingToNext {
    final mod = _count % perCycle;
    return mod == 0 ? perCycle : (perCycle - mod);
  }

  void _increment() {
    HapticFeedback.selectionClick();
    _animCtrl.forward().then((_) => _animCtrl.reverse());
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count <= 0) return;
    HapticFeedback.lightImpact();
    setState(() {
      _count--;
    });
  }

  void _reset() {
    HapticFeedback.heavyImpact();
    setState(() {
      _count = 0;
    });
  }

  MianColors mainColors = MianColors();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool atCycleBoundary = (_count != 0 && _count % perCycle == 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            'المسبحة',
          style: GoogleFonts.amiri(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        centerTitle: true,
        backgroundColor: mainColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
               SvgPicture.asset(
                   "assets/icons/tasbih.svg",
                 color: mainColors.secondaryColor,
                 width: 150,
                 height: 150,
               ),

            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                '$_count',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: mainColors.secondaryColor,
                ),
              ),
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _currentDhikr,
                      style: GoogleFonts.amiri(
                        fontSize: 27,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      atCycleBoundary ? 'تمت مُجموعة ($_currentDhikrIndex + 1)' :
                      'تبقّى $_remainingToNext لتبديل الذكر',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 0.96).animate(_animCtrl),
              child: GestureDetector(
                onTap: _increment,
                onLongPress: _decrement,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color:_count > 0 && atCycleBoundary ? Colors.grey.withOpacity(0.1):
                    mainColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        atCycleBoundary ? 'تمت المجموعة — استمر' : 'اضغط للتسبيح',
                        style: GoogleFonts.amiri(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentDhikr,
                        style: GoogleFonts.amiri(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh, color: Colors.redAccent),
                  label: const Text('إعادة تعيين', style: TextStyle(color: Colors.redAccent,)),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
