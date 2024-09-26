import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/core/common/navigation.dart';
import 'package:xsis_test/core/common/routes.dart';
import 'package:xsis_test/core/widget/appbar/default_appbar.dart';
import 'package:xsis_test/core/widget/shimmer/default_shimmer.dart';
import 'package:xsis_test/feature/home/presentation/widget/popular_movie_widget.dart';
import 'package:xsis_test/feature/home/presentation/widget/top_rated_movie_widget.dart';
import 'package:xsis_test/feature/home/presentation/widget/upcoming_movie_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomePage extends StatefulWidget {
  final dynamic data;
  const HomePage({super.key, this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dummy length
  int nowPlayingMovieLength = 3;
  List listPopularMovie = [
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
  ];
  List listTopRatedMovie = [
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
  ];
  List listUpcomingMovie = [
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
  ];

  // for favMovie slider
  final PageController nowPlayingMovieController = PageController();
  // for video
  YoutubePlayerController? _ytbPlayerController;

  @override
  void initState() {
    super.initState();
    // do something for init
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: '6ZfuNTqbHE8',
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nowPlayingMovieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: buildContent(context),
    );
  }

  buildAppbar(BuildContext context) {
    return DefaultAppBar(
      type: AppBarType.main,
      leading: Text(
        "Netflix",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),
      ),
      actions: [
        // search
        GestureDetector(
          onTap: () {
            String id = '';
            Logger.print('id : $id');
            // nav.push(Routes.searchPage);
            navigatorKey.currentState?.pushNamed(
              Routes.searchPage,
              arguments: id,
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 14, 0),
            child: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  buildContent(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              // Movie Banner (now playing)
              Column(
                children: [
                  // content
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PageView.builder(
                      controller: nowPlayingMovieController,
                      itemCount: nowPlayingMovieLength,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                height: 160,
                                width: 140,
                                // change to image from API
                                'https://placehold.co/600x400.png',
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const DefaultShimmer(
                                      height: 160,
                                      width: 240,
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://placehold.co/600x400.png',
                                    fit: BoxFit.cover,
                                    height: 160,
                                    width: 240,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  "title",
                                  style: GoogleFonts.lato(
                                    textStyle: textTheme.labelLarge?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "desc",
                                  style: GoogleFonts.lato(
                                    textStyle: textTheme.labelLarge?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  // little dot
                  Center(
                    child: SmoothPageIndicator(
                      controller: nowPlayingMovieController,
                      count: nowPlayingMovieLength,
                      textDirection: TextDirection.ltr,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                        dotColor: Colors.grey.shade400,
                        type: WormType.normal,
                      ),
                    ),
                  ),
                ],
              ),
              // popular
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Movie",
                      style: GoogleFonts.lato(
                        textStyle: textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // not yet
                        onTapItem(context);
                      },
                      child: Text(
                        "see all",
                        style: GoogleFonts.roboto(
                          textStyle: textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listPopularMovie.map((item) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: item == listPopularMovie.lastOrNull ? 0 : 8,
                      ),
                      child: contentPopularMovie(item),
                    );
                  }).toList(),
                ),
              ),
              // top rated
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Movie",
                      style: GoogleFonts.lato(
                        textStyle: textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // not yet
                      },
                      child: Text(
                        "see all",
                        style: GoogleFonts.roboto(
                          textStyle: textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listTopRatedMovie.map((item) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: item == listTopRatedMovie.lastOrNull ? 0 : 8,
                      ),
                      child: contentTopRatedMovie(item),
                    );
                  }).toList(),
                ),
              ),
              // upcoming
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcoming Movie",
                      style: GoogleFonts.lato(
                        textStyle: textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // not yet
                      },
                      child: Text(
                        "see all",
                        style: GoogleFonts.roboto(
                          textStyle: textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listUpcomingMovie.map((item) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: item == listUpcomingMovie.lastOrNull ? 0 : 8,
                      ),
                      child: contentUpcomingMovie(item),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget contentPopularMovie(item) {
    return PopularMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: item['imageUrl'] ?? 'https://placehold.co/60x60.png',
      movieName: item['movieName'] ?? '-',
    );
  }

  Widget contentTopRatedMovie(item) {
    return TopRatedMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: item['imageUrl'] ?? 'https://placehold.co/60x60.png',
      movieName: item['movieName'] ?? '-',
    );
  }

  Widget contentUpcomingMovie(item) {
    return UpcomingMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: item['imageUrl'] ?? 'https://placehold.co/60x60.png',
      movieName: item['movieName'] ?? '-',
    );
  }

  Future<dynamic> onTapItem(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    _ytbPlayerController?.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _ytbPlayerController?.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    };

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              reverse: true,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        // line
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // the content
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: YoutubePlayerIFrame(
                              controller: _ytbPlayerController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "The Crow",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "iMBD Rating 6.77/100 (356) ",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Popularity 2177.43",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Release 2024-08-21",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Synopsis",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Soulmates Eric and Shelly are brutally murdered when the demons of her dark past catch up with them. Given the chance to save his true love by sacrificing himself, Eric sets out to seek merciless revenge on their killers, traversing the worlds of the living and the dead to put the wrong things right.",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
