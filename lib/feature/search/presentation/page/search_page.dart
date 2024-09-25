import 'package:flutter/material.dart';
import 'package:xsis_test/core/utils/text_input_formatter.dart';
import 'package:xsis_test/core/widget/appbar/default_appbar.dart';
import 'package:xsis_test/core/widget/text_field/default_text_field.dart';
import 'package:xsis_test/feature/search/presentation/widget/search_item.dart';

class SearchPage extends StatefulWidget {
  final dynamic data;
  const SearchPage({super.key, this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  String? searchValue;

  List listGroceries = [
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
    {"imageUrl": "", "movieName": "test"},
  ];

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
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // search
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
                      // historySearchBloc.add(
                      //     PostSaveHistorySearchRequest(keyword: searchValue ?? ""));
                      // hit api
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
                  // if (value != "") {
                  //   historySearchBloc
                  //       .add(PostSaveHistorySearchRequest(keyword: value));
                  // }
                  // hit api
                },
              ),
            ),
          ],
        ),

        // result
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              itemCount: listGroceries.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                // this height should not be fixed
                mainAxisExtent: 220,
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
                    imageUrl: listGroceries[index]['imageUrl'] ?? '',
                    movieName: listGroceries[index]['movieName'] ?? '',
                    onTap: () {
                      // call popup
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
