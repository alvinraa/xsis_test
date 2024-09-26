import 'package:flutter/material.dart';
import 'package:xsis_test/core/widget/shimmer/default_shimmer.dart';

class UpcomingMovieWidget extends StatefulWidget {
  final void Function()? onTap;
  final String imageUrl;
  final String movieName;

  const UpcomingMovieWidget({
    super.key,
    this.onTap,
    required this.imageUrl,
    required this.movieName,
  });

  @override
  State<UpcomingMovieWidget> createState() => _UpcomingMovieWidgetState();
}

class _UpcomingMovieWidgetState extends State<UpcomingMovieWidget> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: 140,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.imageUrl,
                  width: 90,
                  height: 140,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const DefaultShimmer(
                        width: 90,
                        height: 140,
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://placehold.co/90x140.png',
                      width: 90,
                      height: 140,
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
