import 'package:flutter/material.dart';
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Search')), body: const Padding(padding: EdgeInsets.all(16), child: TextField(decoration: InputDecoration(labelText: 'Search articles'), semanticsLabel: 'Search articles')));
}
