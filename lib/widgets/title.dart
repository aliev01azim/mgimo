import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Title extends StatelessWidget {
  const Title(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('main').listenable(),
      builder: (_, Box box, __) {
        return Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    var value = box.get('isDark', defaultValue: false) as bool;
                    await box.put('isDark', !value);
                  },
                  icon: Icon(
                    (box.get('isDark', defaultValue: false) as bool) == false
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode,
                  ),
                  color:
                      (box.get('isDark', defaultValue: false) as bool) == false
                          ? Colors.black
                          : Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      color: (box.get('isDark', defaultValue: false) as bool) ==
                              false
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
