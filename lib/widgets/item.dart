import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgimo_dictionary/pages/main_page.dart';
import 'package:mgimo_dictionary/pages/start_pages/course.dart';
import 'package:mgimo_dictionary/pages/start_pages/language.dart';

class Item extends StatelessWidget {
  const Item(this.name, this.path, {Key? key}) : super(key: key);
  final String name;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
      child: ValueListenableBuilder(
          valueListenable: Hive.box('main').listenable(),
          builder: (_, Box box, __) {
            return InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                path == 'course' || path == 'language'
                    ? Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) {
                          if (path == 'course') {
                            return const Course();
                          } else {
                            return const Language();
                          }
                        }),
                      )
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Body(),
                        ),
                      );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      (box.get('isDark', defaultValue: false) as bool) == false
                          ? Colors.grey[300]
                          : Colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: (box.get('isDark', defaultValue: false) as bool) ==
                              false
                          ? Colors.grey[500]!
                          : Colors.black54,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: (box.get('isDark', defaultValue: false) as bool) ==
                              false
                          ? Colors.white
                          : Colors.grey[800]!,
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: (box.get('isDark', defaultValue: false) as bool) ==
                            false
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
