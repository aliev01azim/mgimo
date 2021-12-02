import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgimo_dictionary/widgets/item.dart';
import 'package:mgimo_dictionary/widgets/title.dart' as title;

class Course extends StatelessWidget {
  const Course({Key? key}) : super(key: key);
  static const List<String> list = [
    '1 Курс',
    '2 Курс',
    '3 Курс',
    '4 Курс',
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('main').listenable(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const title.Title('Выберите курс'),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => Item(list[index], 'language'),
            ),
          ),
        ],
      ),
      builder: (_, Box box, Widget? child) {
        return Scaffold(
          backgroundColor:
              (box.get('isDark', defaultValue: false) as bool) == true
                  ? const Color.fromRGBO(30, 30, 30, 1)
                  : Colors.grey[300],
          body: child,
        );
      },
    );
  }
}
