import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minor_project_sem_7/components/custom_card.dart';
import 'package:minor_project_sem_7/components/custom_elevated_button.dart';
import 'package:minor_project_sem_7/components/menu_chip.dart';
import 'package:minor_project_sem_7/components/news_table.dart';
import 'package:minor_project_sem_7/components/search_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/poll_card.dart';
import 'components/weather_warning.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class JsonWidgetBuilder extends StatelessWidget {
  final Future<List<dynamic>> Function() fetchData;
  final double spacing;

  JsonWidgetBuilder({
    super.key,
    required this.fetchData,
    this.spacing = 16.0,
  });
  final partyData = [
    PartySeats(
      name: "Bharatiya Janata Party",
      shortName: "BJP",
      seats: 285,
      color: Colors.orange,
      alliance: "NDA",
    ),
    PartySeats(
      name: "Indian National Congress",
      shortName: "INC",
      seats: 95,
      color: Colors.blue,
      alliance: "INDIA",
    ),
    PartySeats(
      name: "Others",
      shortName: "OTH",
      seats: 163,
      color: Colors.grey,
      alliance: "Others",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                for (var widgetData in snapshot.data!) ...[
                  _buildWidget(widgetData as Map<String, dynamic>),
                  SizedBox(height: spacing),
                ],
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildWidget(Map<String, dynamic> widgetData) {
    switch (widgetData['type']) {
      case 'textformfield':
        return TextFormField(
          decoration: InputDecoration(
            labelText: widgetData['content'] ?? 'Enter text',
          ),
        );
      case 'button':
        return CustomElevatedButton(
          buttonText: Text(widgetData['content'] ?? 'Button'),
          onPressed: () {},
        );

      case 'header':
        return WeatherWarningCard(imageUrl: widgetData['imgURL'],subtype:  widgetData['subtype'],
  warningMessage: widgetData['content'],);
      case 'body':
        return Text(widgetData['content'] ?? '');
      case 'list':
        return const NewsHeadlinesList();
      case 'election':
        return ElectionSpeedometer(
          title: "Lok Sabha Election 2024",
          partyData: partyData,
        );
      case 'spacer':
        return SizedBox(
          height:
              (widgetData['content'] != null && widgetData['content'] is num)
                  ? widgetData['content'].toDouble()
                  : 10.00,
        );
      case 'search':
        return SearchTextFormField();
      case 'menu':
        return MenuChip(
            options: List<String>.from(widgetData['content'] ?? []));
      case 'cardText':
        return TextCard(title: widgetData['content'] ?? '');
      case 'text':
        return Text(
          widgetData['content'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        );
      default:
        return Text('Unknown widget type: ${widgetData['type']}');
    }
  }
}

class WidgetDataService {
  static const String _cacheKey = 'widget_data';
  static const String _isLatestKey = 'widget_data_is_latest';

  Future<List<dynamic>> fetchWidgetData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    // Cache is not latest or doesn't exist, fetch new data
    try {
      final response = await http.get(Uri.parse(
          'https://cloudflare-b2.madangovind122.workers.dev/govtest122/c4de32e2-7c6f-44e6-b729-c7c3fc32f54a/abcdef'));
      // print(response.bo);
      if (response.statusCode == 200) {
        final newData = response.body;
        final decodedData = json.decode(newData) as List<dynamic>;
        // Cache the new data
        await prefs.setString(_cacheKey, newData);
        await prefs.setBool(_isLatestKey, true);
        return decodedData;
      } else {
        throw Exception('Failed to load widget data');
      }
    } catch (e) {
      // If there's an error fetching new data and we have cached data, use it as a fallback
      if (cachedData != null) {
        return json.decode(cachedData) as List<dynamic>;
      }
      rethrow;
    }
  }

  Future<void> invalidateCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLatestKey, false);
  }
}

class MyHomePage extends StatelessWidget {
  final WidgetDataService _dataService = WidgetDataService();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  15.0),
          child: JsonWidgetBuilder(
            fetchData: _dataService.fetchWidgetData,
            spacing: 10.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _dataService.invalidateCache();
          // Trigger a rebuild of the widget tree
          (context as Element).markNeedsBuild();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
