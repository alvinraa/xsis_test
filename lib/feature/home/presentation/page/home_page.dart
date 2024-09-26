import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xsis_test/core/common/constant.dart';
import 'package:xsis_test/core/common/navigation.dart';
import 'package:xsis_test/core/common/routes.dart';
import 'package:xsis_test/core/widget/appbar/default_appbar.dart';
import 'package:xsis_test/core/widget/error/error_content.dart';
import 'package:xsis_test/core/widget/shimmer/default_shimmer.dart';
import 'package:xsis_test/feature/home/bloc/now_playing_movie_list/now_playing_movie_list_bloc.dart';
import 'package:xsis_test/feature/home/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:xsis_test/feature/home/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:xsis_test/feature/home/bloc/upcoming_movie/upcoming_movie_bloc.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
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
  // for favMovie slider
  final PageController nowPlayingMovieController = PageController();
  // for video
  YoutubePlayerController? _ytbPlayerController;
  // list of bloc
  late NowPlayingMovieListBloc nowPlayingMovieListBloc;
  late PopularMovieListBloc popularMovieListBloc;
  late TopRatedMovieListBloc topRatedMovieListBloc;
  late UpcomingMovieListBloc upcomingMovieListBloc;

  int nowPlayingMovieLength = 5;
  List<int> listDataShimmer = [1, 2, 3, 4, 5];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // init for yt video
    _ytbPlayerController = YoutubePlayerController(
      initialVideoId: '6ZfuNTqbHE8',
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        autoPlay: false,
      ),
    );
    // init for bloc
    nowPlayingMovieListBloc = NowPlayingMovieListBloc();
    popularMovieListBloc = PopularMovieListBloc();
    topRatedMovieListBloc = TopRatedMovieListBloc();
    upcomingMovieListBloc = UpcomingMovieListBloc();
    // load data bloc
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    nowPlayingMovieController.dispose();
  }

  _loadData() {
    nowPlayingMovieListBloc.add(GetNowPlayingMovieListRequest());
    popularMovieListBloc.add(GetPopularMovieListRequest());
    topRatedMovieListBloc.add(GetTopRatedMovieListRequest());
    upcomingMovieListBloc.add(GetUpcomingMovieListRequest());
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
            navigatorKey.currentState?.pushNamed(
              Routes.searchPage,
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

    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              // Movie Banner (now playing)
              BlocConsumer(
                bloc: nowPlayingMovieListBloc,
                listener: (context, state) {
                  if (state is NowPlayingMovieListError) {
                    errorMessage = state.errorMessage;
                    setState(() {});
                  }
                },
                builder: nowPlayingMovieBuilder,
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
                        //  onTapSeeAll(context);
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
              BlocConsumer(
                bloc: popularMovieListBloc,
                listener: (context, state) {
                  if (state is PopularMovieListError) {
                    errorMessage = state.errorMessage;
                    setState(() {});
                  }
                },
                builder: popularMovieBuilder,
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
                        // onTapSeeAll(context);
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
              BlocConsumer(
                bloc: topRatedMovieListBloc,
                listener: (context, state) {
                  if (state is TopRatedMovieListError) {
                    errorMessage = state.errorMessage;
                    setState(() {});
                  }
                },
                builder: topRatedMovieBuilder,
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
                        // onTapSeeAll(context);
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
              BlocConsumer(
                bloc: upcomingMovieListBloc,
                listener: (context, state) {
                  if (state is UpcomingMovieListError) {
                    errorMessage = state.errorMessage;
                    setState(() {});
                  }
                },
                builder: upcomingMovieBuilder,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget upcomingMovieBuilder(BuildContext context, Object? state) {
    if (state is UpcomingMovieListLoading) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listDataShimmer.map((item) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: item == 5 ? 0 : 8),
                  child: const DefaultShimmer(
                    height: 90,
                    width: 90,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const DefaultShimmer(
                  height: 12,
                  width: 60,
                )
              ],
            );
          }).toList(),
        ),
      );
    }
    if (state is UpcomingMovieListError) {
      return ErrorContent(
        message: state.errorMessage,
        detailMessage: state.errorMessage,
        onRefresh: () {
          upcomingMovieListBloc.add(GetUpcomingMovieListRequest());
        },
        type: ErrorType.generalSmall,
      );
    }

    return buildUpcomingMovieContent(context);
  }

  buildUpcomingMovieContent(BuildContext context) {
    List<MovieModel> listUpcomingMovie = upcomingMovieListBloc.listMovie;

    if (listUpcomingMovie.isEmpty) {
      return Container();
    }

    return SingleChildScrollView(
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
    );
  }

  Widget topRatedMovieBuilder(BuildContext context, Object? state) {
    if (state is TopRatedMovieListLoading) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listDataShimmer.map((item) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: item == 5 ? 0 : 8),
                  child: const DefaultShimmer(
                    height: 90,
                    width: 90,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const DefaultShimmer(
                  height: 12,
                  width: 60,
                )
              ],
            );
          }).toList(),
        ),
      );
    }
    if (state is TopRatedMovieListError) {
      return ErrorContent(
        message: state.errorMessage,
        detailMessage: state.errorMessage,
        onRefresh: () {
          topRatedMovieListBloc.add(GetTopRatedMovieListRequest());
        },
        type: ErrorType.generalSmall,
      );
    }

    return buildTopRatedMovieContent(context);
  }

  buildTopRatedMovieContent(BuildContext context) {
    List<MovieModel> listTopRatedMovie = topRatedMovieListBloc.listMovie;

    if (listTopRatedMovie.isEmpty) {
      return Container();
    }

    return SingleChildScrollView(
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
    );
  }

  Widget popularMovieBuilder(BuildContext context, Object? state) {
    if (state is PopularMovieListLoading) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listDataShimmer.map((item) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: item == 5 ? 0 : 8),
                  child: const DefaultShimmer(
                    height: 90,
                    width: 90,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const DefaultShimmer(
                  height: 12,
                  width: 60,
                )
              ],
            );
          }).toList(),
        ),
      );
    }
    if (state is PopularMovieListError) {
      return ErrorContent(
        message: state.errorMessage,
        detailMessage: state.errorMessage,
        onRefresh: () {
          popularMovieListBloc.add(GetPopularMovieListRequest());
        },
        type: ErrorType.generalSmall,
      );
    }

    return buildPopularMovieContent(context);
  }

  buildPopularMovieContent(BuildContext context) {
    List<MovieModel> listPopularMovie = popularMovieListBloc.listMovie;

    if (listPopularMovie.isEmpty) {
      return Container();
    }

    return SingleChildScrollView(
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
    );
  }

  Widget nowPlayingMovieBuilder(BuildContext context, Object? state) {
    if (state is NowPlayingMovieListLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: DefaultShimmer(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 160,
        ),
      );
    }

    if (state is NowPlayingMovieListError) {
      return ErrorContent(
        message: state.errorMessage,
        detailMessage: state.errorMessage,
        onRefresh: () {
          nowPlayingMovieListBloc.add(GetNowPlayingMovieListRequest());
        },
        type: ErrorType.generalSmall,
      );
    }

    return buildNowPlayingMovieContent(context);
  }

  Widget buildNowPlayingMovieContent(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    List<MovieModel> listMovie = nowPlayingMovieListBloc.listMovie;

    if (listMovie.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        // content
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      '${Constant.baseImageUrl}${listMovie[index].posterPath}',
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const DefaultShimmer(
                            height: 160,
                            width: 140,
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://placehold.co/600x400.png',
                          fit: BoxFit.cover,
                          height: 160,
                          width: 140,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listMovie[index].title ?? '',
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          listMovie[index].overview ?? '',
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
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
    );
  }

  Widget contentPopularMovie(MovieModel item) {
    return PopularMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: '${Constant.baseImageUrl}${item.posterPath}',
      movieName: item.title ?? '-',
    );
  }

  Widget contentTopRatedMovie(MovieModel item) {
    return TopRatedMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: '${Constant.baseImageUrl}${item.posterPath}',
      movieName: item.title ?? '-',
    );
  }

  Widget contentUpcomingMovie(MovieModel item) {
    return UpcomingMovieWidget(
      onTap: () {
        // show dialog content
      },
      imageUrl: '${Constant.baseImageUrl}${item.posterPath}',
      movieName: item.title ?? '-',
    );
  }

  Future<dynamic> onTapSeeAll(BuildContext context) {
    return Fluttertoast.showToast(
      msg: 'still on development',
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 14,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
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
