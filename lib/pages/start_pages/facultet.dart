import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mgimo_dictionary/pages/start_pages/course.dart';
import 'package:mgimo_dictionary/controllers/auth_controller.dart';
import '../../controllers/auth_controller.dart';

class Facultet extends StatelessWidget {
  Facultet({Key? key}) : super(key: key);
  final _controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите факультет'),
        centerTitle: true,
      ),
      body: GetBuilder<AuthController>(
        initState: (_) => _controller.getFacultets(),
        builder: (_) {
          if (_.status == UserStatus.IsAuthenticated) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _.facultets.length,
                itemBuilder: (context, index) => Item(_.facultets[index]),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item(this.item, {Key? key}) : super(key: key);
  final Map<String, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () => Get.to(() => Course(item['name'])),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500]!,
                offset: const Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Text(
            item['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
