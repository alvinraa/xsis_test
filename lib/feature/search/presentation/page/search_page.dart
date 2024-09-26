import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xsis_test/core/common/constant.dart';
import 'package:xsis_test/core/common/helper.dart';
import 'package:xsis_test/core/utils/text_input_formatter.dart';
import 'package:xsis_test/core/widget/appbar/default_appbar.dart';
import 'package:xsis_test/core/widget/error/error_content.dart';
import 'package:xsis_test/core/widget/indicator/loading_widget.dart';
import 'package:xsis_test/core/widget/text_field/default_text_field.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/search/bloc/search_bloc.dart';
import 'package:xsis_test/feature/search/presentation/widget/search_item.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SearchPage extends StatefulWidget {
  final dynamic data;
  const SearchPage({super.key, this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // for video
  YoutubePlayerController? _ytbPlayerController;

  List<MovieModel> listSearchResult = [];
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  String? searchValue;

  // bloc
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    // bloc
    searchBloc = SearchBloc();
    // yt
    _ytbPlayerController = YoutubePlayerController(
      // note: the video base on this initialId, i dont found any open source that provide youtube. so i hardcode it
      initialVideoId: '6ZfuNTqbHE8',
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildContent(context),
    );
  }

  DefaultAppBar buildAppBar(BuildContext context) {
    return const DefaultAppBar(
      type: AppBarType.basic,
      title: "Search",
    );
  }

  Widget buildContent(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // search
        const SizedBox(height: 16),
        ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: DefaultTextField(
                controller: searchController,
                focusNode: searchFocusNode,
                autofocus: true,
                inputFormatters: [
                  NoLeadingSpacesInputFormatter(),
                ],
                hintStyle:
                    textTheme.labelLarge?.copyWith(color: Colors.grey.shade500),
                suffixIcon: InkWell(
                  onTap: () {
                    if (searchValue != "" && searchValue != null) {
                      searchBloc
                          .add(GetSearchRequest(keyword: searchValue ?? ''));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ),
                ),
                border: Colors.grey.shade300,
                borderRadius: 28,
                onChanged: (val) {
                  // _debouncer.run(() {
                  searchValue = val;
                  //   setState(() {
                  // initSearch = false;
                  //     suggestionSearchBloc.keyword = searchValue ?? "";
                  //     suggestionSearchBloc.add(const GetSuggestionSearch());
                  //   });
                  // });
                },
                onFieldSubmitted: (value) {
                  if (value != "") {
                    searchBloc.add(GetSearchRequest(keyword: value));
                  }
                  // hit api
                },
              ),
            ),
          ],
        ),
        // result
        BlocConsumer(
          bloc: searchBloc,
          listener: (context, state) {
            // do something if needed: implement listener.
          },
          builder: (context, state) {
            if (state is SearchLoading) {
              return const LoadingWidget();
            }

            return buildSearchContent(context);
          },
        ),
      ],
    );
  }

  buildSearchContent(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    listSearchResult = searchBloc.listMovie;

    if (listSearchResult.isEmpty) {
      return const Expanded(
        child: ErrorContent(
          showRefresh: false,
          type: ErrorType.empty,
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GridView.builder(
          itemCount: listSearchResult.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            // this height should not be fixed
            mainAxisExtent: 240,
          ),
          itemBuilder: (context, index) {
            return Container(
              // margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SearchItem(
                imageUrl:
                    '${Constant.baseImageUrl}${listSearchResult[index].posterPath}',
                movieName: listSearchResult[index].title ?? '',
                onTap: () {
                  // call popup
                  onTapItem(context, listSearchResult[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // can make it into one function, cause using at home_page and search_page
  Future<dynamic> onTapItem(BuildContext context, MovieModel item) {
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
                          item.title ?? '',
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
                          "iMBD Rating ${item.voteAverage}/10 (${item.voteCount}) ",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Popularity ${item.popularity}",
                          style: GoogleFonts.lato(
                            textStyle: textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              "Release ",
                              style: GoogleFonts.lato(
                                textStyle: textTheme.labelLarge?.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                Helper.formatDateTime(item.releaseDate,
                                    format: 'dd MMM yyyy'),
                                style: GoogleFonts.lato(
                                  textStyle: textTheme.labelLarge?.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                          item.overview ?? '',
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
