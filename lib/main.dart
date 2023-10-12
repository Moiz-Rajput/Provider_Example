import 'package:flutter/material.dart';
import 'package:provier_example/provider/country_provider/country_provider.dart';
import 'package:provier_example/screens/countries/countries.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
// You can wrap multiple providers in a list.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
      ],
      child: const CountriesDemoApp(),
    ),
  );
}

class CountriesDemoApp extends StatelessWidget {
  const CountriesDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries Demo GraphQL, Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountriesList(),
    );
  }
}
