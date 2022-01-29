import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as dio;
import '../helpers/alerts.dart';
import '../helpers/api_services.dart';

class MainScreenController extends GetxController {
  // search
  Timer? _zaderjka;
  var _loading = false;

  get loading => _loading;

  List _items = [];

  List get items => _items;

  final List _searchHistory =
      Hive.box('main').get('history', defaultValue: []) as List;
  Future<void> getData(String query) async {
    _zaderjka?.cancel();
    _zaderjka = Timer(const Duration(milliseconds: 200), () async {
      _loading = true;
      update();
      try {
        dio.Response response = await getSearchApi(query);
        final result = response.data;
        print(result);
        if (result == null) return;
        final List loadedData = [];
        for (var word in result['results']) {
          loadedData.add(word);
        }
        _items = loadedData;
      } on dio.DioError catch (e) {
        if (e.response?.statusCode == 401) {
          final _reftoken = Hive.box('main').get('tokens')['refresh_token'];
          final data = {'refresh': _reftoken};
          dio.Response response = await getAccessTokenApi(data);
          var result = response.data;
          if (result != null) {
            print(result);
            await Hive.box('main').put('token', result);
          }
        }
      } catch (e) {
        e.printError();
        errorAlert(e);
      } finally {
        _loading = false;
        update();
      }
    });
  }

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
    update();
  }

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
}

extension StringExtension on String {
  String capitalizze() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
