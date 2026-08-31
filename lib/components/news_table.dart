import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

// Model for news article
class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final int views; // This would normally come from your backend

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    this.views = 0, // Default value since API doesn't provide views
  });




  factory NewsArticle.fromJson(Map<String, dynamic> json) {


String parseDate(String? dateStr) {
  if (dateStr == null) {
    return DateFormat('MMM d').format(DateTime.now());
  }
  try {
    DateTime parsedDate = DateTime.parse(dateStr);
    return DateFormat('MMM d').format(parsedDate);
  } catch (e) {
    print('Error parsing date: $e');
    return DateFormat('MMM d').format(DateTime.now());
  }
}

    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/60',
      publishedAt: parseDate(json['publishedAt']),
      views: 1000, // Example static value
    );
  }
}

class NewsHeadlinesList extends StatefulWidget {
  const NewsHeadlinesList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsHeadlinesListState createState() => _NewsHeadlinesListState();
}

class _NewsHeadlinesListState extends State<NewsHeadlinesList> {


final _random = Random();
  late Future<List<NewsArticle>> _newsArticles;
  final String apiKey = 'e546264b3b7e4fad8700ce704cc3b9e3';

  Future<List<NewsArticle>> fetchNewsArticles() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final articles = data['articles'] as List;
      articles.shuffle();
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  @override
  void initState() {
    super.initState();
    _newsArticles = fetchNewsArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsArticle>>(
      future: _newsArticles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _newsArticles = fetchNewsArticles();
              });
            },
            child: ListView.builder(physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,
          
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return NewsArticleCard(
                  title: article.title,
                  timeAgo: article.publishedAt.toString(),
                  views: _random.nextInt(1000),
                  thumbnailUrl: article.urlToImage,
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _newsArticles = fetchNewsArticles();
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class NewsArticleCard extends StatelessWidget {
  final String title;
  final String timeAgo;
  final int views;
  final String thumbnailUrl;

  const NewsArticleCard({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.views,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl:  thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$views views',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}