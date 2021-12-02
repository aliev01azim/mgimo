import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result(this.res, {Key? key}) : super(key: key);
  final String res;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Center(
              child: Text(
                res,
                style: const TextStyle(fontSize: 35, color: Colors.indigo),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Перевод'),
            const SizedBox(
              height: 10,
            ),
            const Text('Бежать'),
            const Text('Управлять'),
          ],
        ),
      ),
    );
  }
}
