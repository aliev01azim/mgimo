import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mgimo_dictionary/controllers/auth_controller.dart';

class Course extends StatelessWidget {
  Course(this.name, {Key? key}) : super(key: key);
  final _controller = Get.find<AuthController>();
  final String name;
  @override
  Widget build(BuildContext context) {
    final _courses = _controller.getCourse(name);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите курс'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<AuthController>(
          builder: (_) {
            return _.status == UserStatus.Authenticating
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _courses.length,
                    itemBuilder: (context, index) => Item(
                      _courses[index],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item(this.item, {Key? key}) : super(key: key);
  final Map<String, dynamic> item;
  final _controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () => _controller.authUser(item['course_number']),
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
