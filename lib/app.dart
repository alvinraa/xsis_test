import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xsis_test/core/common/helper.dart';
import 'package:xsis_test/core/common/navigation.dart';
import 'package:xsis_test/core/common/routes.dart';
import 'package:xsis_test/core/theme/style.dart';
import 'package:xsis_test/feature/home/bloc/now_playing_movie_list/now_playing_movie_list_bloc.dart';
import 'package:xsis_test/feature/home/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:xsis_test/feature/home/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:xsis_test/feature/home/bloc/upcoming_movie/upcoming_movie_bloc.dart';
import 'package:xsis_test/feature/search/bloc/search_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();

  static AppState of(BuildContext context) =>
      context.findAncestorStateOfType<AppState>()!;
}

class AppState extends State<App> {
  ThemeType themeType = ThemeType.light;

  @override
  Widget build(BuildContext context) {
    // layout potrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      // list of bloc
      providers: [
        BlocProvider(create: (context) => NowPlayingMovieListBloc()),
        BlocProvider(create: (context) => PopularMovieListBloc()),
        BlocProvider(create: (context) => TopRatedMovieListBloc()),
        BlocProvider(create: (context) => UpcomingMovieListBloc()),
        BlocProvider(create: (context) => SearchBloc()),
      ],
      child: MaterialApp(
        title: 'Xsis',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: Styles.appTheme(context, themeType),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: GestureDetector(
                onTap: () {
                  Helper.hideKeyboard(context);
                },
                child: child!),
          );
        },
        // routes: appRoutes,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
