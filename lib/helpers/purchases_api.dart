import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {
  static const _apiKey = 'goog_lWeyVZHNmbMiCrVVdouPGzaPXrS';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    final user = Hive.box('main').get('user', defaultValue: {}) ?? {};
    String userId = '';
    if (user.isNotEmpty) {
      userId = user['id'];
      await Purchases.setup(_apiKey, appUserId: userId);
    } else {
      await Purchases.setup(_apiKey);
    }
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      print('current : $current');
      return current == null ? [] : [current];
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      final data = await Purchases.purchasePackage(package);
      print('data : $data');
      // PurchaserInfo(
      // entitlements: EntitlementInfos(all: {}, active: {}),
      // allPurchaseDates: {mgimodictionary_279_1m: 2022-02-05T21:30:57.000Z},
      // activeSubscriptions: [mgimodictionary_279_1m],
      // allPurchasedProductIdentifiers: [mgimodictionary_279_1m],
      // nonSubscriptionTransactions: [],
      // firstSeen: 2022-02-05T20:51:07.000Z,
      // originalAppUserId: $RCAnonymousID:a3ea1c0906874f6b9f0b07b909609d5e,
      // allExpirationDates: {mgimodictionary_279_1m: 2022-02-05T21:36:49.000Z},
      // requestDate: 2022-02-05T21:31:02.000Z,
      // latestExpirationDate: 2022-02-05T21:36:49.000Z,
      // originalPurchaseDate: null,
      // originalApplicationVersion: null,
      // managementURL: https://play.google.com/store/account/subscriptions)
      return true;
    } catch (e) {
      return false;
    }
  }
}
