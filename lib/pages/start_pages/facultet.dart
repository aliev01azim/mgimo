import 'package:flutter/material.dart';
import 'package:mgimo_dictionary/widgets/item.dart';
import 'package:mgimo_dictionary/widgets/title.dart' as title;

class StartingPages extends StatelessWidget {
  const StartingPages({Key? key}) : super(key: key);
  static const List<String> list = [
    'Международные экономические отношеня',
    'Международные отношения',
    'Международная журналистика',
    'Международный бизнес и деловое администрирование',
    'Управление и политика',
    'Международно-правовой'
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const title.Title('Выберите факультет'),
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Item(list[index], 'course'),
          ),
        ),
      ],
    );
  }
}
