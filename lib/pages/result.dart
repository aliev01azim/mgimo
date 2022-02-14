import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result(this.res, {Key? key}) : super(key: key);
  final Map<String, dynamic> res;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(res['title']),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  res['title'],
                  style: const TextStyle(fontSize: 35, color: Colors.indigo),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Транскрипция'),
              Center(
                child: Text(
                  res['transcription'],
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: res['translations'].length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${index + 1})',
                      style:
                          const TextStyle(fontSize: 35, color: Colors.indigo),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      res['translations'][index]['title'],
                      style:
                          const TextStyle(fontSize: 35, color: Colors.indigo),
                    ),
                  ],
                ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: res['translations']
                //       .map<Widget>(
                //         (v) => Column(
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   '${index + 1})',
                //                   style: const TextStyle(
                //                       fontSize: 35, color: Colors.indigo),
                //                 ),
                //                 const SizedBox(
                //                   width: 4,
                //                 ),
                //                 Text(
                //                   v['title'],
                //                   style: const TextStyle(
                //                       fontSize: 35, color: Colors.indigo),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       )
                //       .toList(),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
