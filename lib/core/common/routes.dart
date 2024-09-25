import 'package:flutter/material.dart';
import 'package:xsis_test/feature/home/presentation/page/home_page.dart';
import 'package:xsis_test/feature/search/presentation/page/search_page.dart';

class Routes {
  static const String homePage = '/';
  static const String searchPage = 'search';
}

// Map<String, Widget Function(BuildContext)> appRoutes = {
//   Routes.moviePage: (context) => const MoviePage(),
// };

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.homePage:
      return MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
          data: settings.arguments,
        ),
        settings: settings,
      );
    case Routes.searchPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => SearchPage(
          data: settings.arguments,
        ),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => const Scaffold(
          body: Center(
            child: Text('Route not defined'),
          ),
        ),
        settings: settings,
      );
  }
}
