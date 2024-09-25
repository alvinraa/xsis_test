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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const DefaultShimmer(
                      height: 60,
                      width: 60,
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://placehold.co/60x60.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
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
            style: textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
