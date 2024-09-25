import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xsis_test/app.dart';
import 'package:xsis_test/core/client/client.dart';

Future<void> main() async {
  await Client().setupClient();
  initializeDateFormatting();
  runApp(const App());
}
