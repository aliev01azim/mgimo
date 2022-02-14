import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mgimo_dictionary/helpers/purchases_api.dart';

import '../widgets/paywall_widget.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформить подписку'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.hourglass_empty_outlined,
              size: 200,
              color: Colors.amber,
            ),
            const Text(
              'Время пользования приложением истекло.',
              textAlign: TextAlign.center,
            ),
            const Text(
              'Чтобы продолжить пользоваться "MGIMO dictionary" преобретите подписку.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: fetchOffers,
              child: const Text('Оформить подписку'),
            ),
          ],
        ),
      ),
    );
  }
}

Future fetchOffers() async {
  final offerings = await PurchasesApi.fetchOffers();
  if (offerings.isEmpty) {
    Get.snackbar('Отказано', 'Планы не найдены');
  } else {
    final packages = offerings
        .map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();
    Get.bottomSheet(
      PaywallWidget(
        packages: packages,
        title: 'Преобретите подписку!',
        description: 'Купите подписку и продолжите пользоваться приложением!',
        onClickedPackage: (package) async {
          await PurchasesApi.purchasePackage(package);

          Get.back();
        },
      ),
      backgroundColor: Colors.green[100],
    );
  }
}
