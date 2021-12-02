import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mgimo_dictionary/services/api_services.dart';

import 'result.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var loading = false;
  final List _searchHistory =
      Hive.box('main').get('history', defaultValue: []) as List;
  List items = [];
  Future<void> filterSearchTerms({
    @required String? filter,
  }) async {
    if (filter != null && filter.isNotEmpty) {
      _searchHistory.reversed.where((term) => term.startsWith(filter)).toList();
      await Hive.box('main').put('history', _searchHistory);
    } else {
      _searchHistory.reversed.toList();
      await Hive.box('main').put('history', _searchHistory);
    }
    setState(() {});
  }

  Timer? _zaderjka;
  void addSearchTerm(String term) async {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    await filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) async {
    _searchHistory.removeWhere((t) => t == term);
    await filterSearchTerms(filter: null);
    await Hive.box('main').put('history', _searchHistory);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filterSearchTerms(filter: null);
  }

  Future<void> getData(String query) async {
    _zaderjka?.cancel();
    _zaderjka = Timer(const Duration(milliseconds: 200), () async {
      setState(() {
        loading = true;
      });
      // var response = await BaseClient().get('/api/v1/search_author/?q=$query');
      var response;
      if (response == null) return;
      final List loadedData = [];
      for (var author in response['data']) {
        loadedData.add(author['name']);
      }
      setState(() {
        loading = false;
      });
      items = loadedData;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        progress: loading == false ? false : true,
        controller: controller,
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: controller.query.isEmpty
            ? null
            : Text(
                controller.query,
                style: Theme.of(context).textTheme.headline6,
              ),
        hint: 'Поиск слова',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) async {
          if (query.isNotEmpty) {
            await getData(query.capitalize());
          }
          await filterSearchTerms(filter: query);
          setState(() {});
        },
        onSubmitted: (query) async {
          if (query.isNotEmpty) {
            addSearchTerm(query);
            await getData(query.capitalize());
            setState(() {
              controller.query = query;
            });
          }

          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (controller.query.isNotEmpty) {
                    return FloatingSearchBarScrollNotifier(
                      child: SearchResultsListView(
                        items: items,
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _searchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  controller.query = term;
                                });
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final List items;
  SearchResultsListView({
    Key? key,
    required this.items,
  }) : super(key: key);
  static const historyLength = 13;
  final List _searchHistory =
      Hive.box('main').get('history', defaultValue: []) as List;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ListTile(
        title: Text("Не удалось найти.   (·_·)"),
      );
    }

    final fsb = FloatingSearchBar.of(context)!.offset;

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: fsb),
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          if (_searchHistory.contains(items[index].toString())) {
            _searchHistory.remove(items[index]);
          }
          _searchHistory.insert(0, items[index].toString());
          if (_searchHistory.length > historyLength) {
            _searchHistory.removeRange(
                0, _searchHistory.length - historyLength);
          }
          await Hive.box('main').put('history', _searchHistory);
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Result(items[index]),
            ),
          );
        },
        title: Text(
          items[index].toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_right_outlined),
      ),
      itemCount: items.length,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
