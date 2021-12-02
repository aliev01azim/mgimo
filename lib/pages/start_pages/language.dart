import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgimo_dictionary/widgets/item.dart';
import 'package:mgimo_dictionary/widgets/title.dart' as title;

class Language extends StatelessWidget {
  const Language({Key? key}) : super(key: key);
  static const List<String> list = ['Английский первый', "Английский второй"];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('main').listenable(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const title.Title('Выберите язык'),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => Item(list[index], 'body'),
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
