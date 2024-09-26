import 'package:flutter/material.dart';
import 'package:xsis_test/core/widget/shimmer/default_shimmer.dart';

class TopRatedMovieWidget extends StatefulWidget {
  final void Function()? onTap;
  final String imageUrl;
  final String movieName;

  const TopRatedMovieWidget({
    super.key,
    this.onTap,
    required this.imageUrl,
    required this.movieName,
  });

  @override
  State<TopRatedMovieWidget> createState() => _TopRatedMovieWidgetState();
}

class _TopRatedMovieWidgetState extends State<TopRatedMovieWidget> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 240,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  height: 140,
                  width: 240,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const DefaultShimmer(
                        height: 140,
                        width: 240,
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://placehold.co/240x140.png',
                      height: 140,
                      width: 240,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movieName,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
