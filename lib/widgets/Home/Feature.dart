import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicFeature {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  IslamicFeature({required this.icon, required this.label, this.onTap});
}

class IslamicFeaturesGrid extends StatelessWidget {
  final List<IslamicFeature> features;

  const IslamicFeaturesGrid({Key? key, required this.features})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: features.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 في الصف الواحد
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        return GestureDetector(
          onTap: item.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(item.icon, size: 29, color: const Color(0xFFC8A797)),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: GoogleFonts.amiri(
                  fontSize: 23,
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
