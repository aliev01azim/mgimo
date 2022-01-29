import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../controllers/main_page_controller.dart';
import 'result.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List _searchHistory =
      Hive.box('main').get('history', defaultValue: []) as List;
  final _mainController = Get.find<MainScreenController>();
  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    _mainController.filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainScreenController>(
        builder: (_) {
          return FloatingSearchBar(
            progress: _.loading == false ? false : true,
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
                await _.getData(query.capitalizze());
              }
              await _.filterSearchTerms(filter: query);
            },
            onSubmitted: (query) async {
              if (query.isNotEmpty) {
                _.addSearchTerm(query);
                await _.getData(query.capitalizze());
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
                            items: _.items,
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
                                    onPressed: () => _.deleteSearchTerm(term),
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
          if (_searchHistory.contains(items[index]['title'])) {
            _searchHistory.remove(items[index]['title']);
          }
          _searchHistory.insert(0, items[index]['title']);

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
          items[index]['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_right_outlined),
      ),
      itemCount: items.length,
    );
  }
}
