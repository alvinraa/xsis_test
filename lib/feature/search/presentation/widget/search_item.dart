import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xsis_test/core/widget/shimmer/default_shimmer.dart';

class SearchItem extends StatelessWidget {
  final void Function()? onTap;
  final String imageUrl;
  final String movieName;

  const SearchItem({
    super.key,
    this.onTap,
    required this.imageUrl,
    required this.movieName,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // text
          Text(
            movieName,
            maxLines: 1,
            style: GoogleFonts.lato(
              textStyle: textTheme.labelLarge?.copyWith(
                color: colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 150,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const DefaultShimmer(
                    width: 120,
                    height: 150,
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://placehold.co/80x80.png',
                  width: 120,
                  height: 150,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
